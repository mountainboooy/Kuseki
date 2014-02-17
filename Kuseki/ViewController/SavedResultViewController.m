//
//  SavedResultViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/01.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "SavedResultViewController.h"
#import "KUResponse.h"
#import "KUResponseManager.h"
#import "KUButton.h"
#import "KUSwitch.h"
#import "KUNotificationTarget.h"

@interface SavedResultViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    
    //outlet
    __weak IBOutlet UITableView *_tableView;
    
    //model
    KUResponseManager *_responseManager;
    
}

@end

@implementation SavedResultViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //model
    _responseManager = [KUResponseManager sharedManager];
    [_responseManager getResponsesWithParam:_condition completion:^{
        [_tableView reloadData];
    
    } failure:^(NSHTTPURLResponse *res, NSError *err) {
        
        if (res || err) {//通信問題、サーバーエラーなど
            NSString* title = [NSString stringWithFormat:@"statusCode:%d",res.statusCode];
            NSString *message = @"空席情報を取得できませんでした。後ほどお試しください";
            [AppDelegate showAlertWithTitle:title message:message completion:nil];
            
            return;
        }
        
        if(!res && !err){//入力内容に問題あり
            NSString *message = @"条件に合う空席情報は見つかりませんでした";
            [AppDelegate showAlertWithTitle:nil message:message completion:nil];
            return;
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _responseManager.responses.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if([_condition.train isEqualToString:@"1"] || [_condition.train isEqualToString:@"2"]){//西側
        cell =  [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
    }else{//東
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header0"];
    UILabel *lb_month_day = (UILabel*)[cell viewWithTag:1];
    UILabel *lb_dep_stn = (UILabel*)[cell viewWithTag:2];
    UILabel *lb_arr_stn = (UILabel*)[cell viewWithTag:3];
    
    lb_month_day.text = [NSString stringWithFormat:@"%@月%@日",_condition.month, _condition.day];
    lb_dep_stn.text = _condition.dep_stn;
    lb_arr_stn.text = _condition.arr_stn;
    
    return cell;
    
}


- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    if(_responseManager.responses.count == 0){
        return;
    }
    
    KUResponse * response = _responseManager.responses[indexPath.row];
    
    
    //name
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = response.name;
    
    //dep_time
    UILabel *lb_dep_time = (UILabel*)[cell viewWithTag:2];
    lb_dep_time.text = [NSString stringWithFormat:@"%@発", response.dep_time];
    
    if([_condition.train isEqualToString:@"1"] || [_condition.train isEqualToString:@"2"])
    {//西側
        //ec_ns
        UIImageView *iv_ec_ns = (UIImageView*)[cell viewWithTag:4];
        iv_ec_ns.image = [self imgForSeatValue:response.seat_ec_ns];
        
        //ec_s
        UIImageView *iv_ec_s = (UIImageView*)[cell viewWithTag:5];
        iv_ec_s.image = [self imgForSeatValue:response.seat_ec_s];
        
        //gr_ns
        UIImageView *iv_gr_ns = (UIImageView*)[cell viewWithTag:6];
        iv_gr_ns.image = [self imgForSeatValue:response.seat_gr_ns];
        
        //gr_s
        UIImageView *iv_gr_s = (UIImageView*)[cell viewWithTag:7];
        iv_gr_s.image = [self imgForSeatValue:response.seat_gr_s];
        
        
    }else{//東側
        //ec_ns
        UIImageView *iv_ec_ns = (UIImageView*)[cell viewWithTag:4];
        iv_ec_ns.image = [self imgForSeatValue:response.seat_ec_ns];
        
        //gr_ns
        UIImageView *iv_gr_ns = (UIImageView *)[cell viewWithTag:5];
        iv_gr_ns.image = [self imgForSeatValue:response.seat_gr_ns];
        
        //gs_ns
        UIImageView *iv_gs_ns = (UIImageView*)[cell viewWithTag:6];
        iv_gs_ns.image = [self imgForSeatValue:response.seat_gs_ns];
    }
    
     //switch
    KUSwitch *sw_notification = (KUSwitch*)[cell viewWithTag:9];
    sw_notification.indexPath = indexPath;
    [sw_notification addTarget:self action:@selector(swNotificationChanged:) forControlEvents:UIControlEventValueChanged];
    
    sw_notification.on = ([response isNotificationTarget])? YES:NO;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


#pragma mark -
#pragma mark button action

- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)swNotificationChanged:(KUSwitch*)sw
{
    KUResponse *response = _responseManager.responses[sw.indexPath.row];
    
    if (sw.on) {//通知オン
        [KUNotificationTarget saveWithResponse:response condition:_condition];
    }
    
    else if(!sw.on){//通知オフ
        
        [KUNotificationTarget removeWithResonse:response condition:_condition];
        
    }
    
    
}

#pragma mark -
#pragma mark private method

- (UIImage*)imgForSeatValue:(enum KUSheetValue)seatValue
{
    NSString *imgName;
    
    switch (seatValue) {
            
        case SEAT_VACANT:{
            imgName = @"seat_vacant";
            break;
        }
            
        case SEAT_BIT:{
            imgName = @"seat_bit";
            break;
        }
            
        case SEAT_FULL:{
            imgName = @"seat_full";
            break;
        }
            
        case SEAT_INVALID:{
            imgName = @"seat_invalid";
            break;
        }
            
        case SEAT_NOT_EXIST_SMOKINGSEAT:{
            imgName = @"seat_not_exist_smokingseat";
            break;
        }
            
        default:
            break;
    }
    
    
    return [UIImage imageNamed:imgName];
}


@end
