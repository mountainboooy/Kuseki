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
#import "MBProgressHUD.h"

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
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    [_responseManager getResponsesWithParam:_condition completion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [_tableView reloadData];
    
    } failure:^(NSHTTPURLResponse *res, NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
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


- (void)viewWillAppear:(BOOL)animated
{
    [self setTitle];
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
    NSString *cellIdentifier;
    
    if([_condition.train isEqualToString:@"1"] || [_condition.train isEqualToString:@"2"])
    { cellIdentifier = @"header0";//西
    }else{ cellIdentifier = @"header1"; }//東
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *lb_month = (UILabel*)[cell viewWithTag:4];
    lb_month.text = _condition.month;
    
    UILabel *lb_day = (UILabel*)[cell viewWithTag:5];
    lb_day.text = _condition.day;
    
    UILabel *lb_dep_stn = (UILabel*)[cell viewWithTag:2];
    UILabel *lb_arr_stn = (UILabel*)[cell viewWithTag:3];
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
    
    //dep_time
    UILabel *lb_dep_time = (UILabel*)[cell viewWithTag:2];
    lb_dep_time.text = response.dep_time;
    
    //arr_timr
    UILabel *lb_arr_time = (UILabel*)[cell viewWithTag:3];
    lb_arr_time.text = response.arr_time;
    
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
    
    //結果選択時は列車名と通知スイッチを表示
    //view
    UIView *selected_view = (UIView*)[cell viewWithTag:10];
    selected_view.alpha = 0;
    
     //switch
    KUSwitch *sw_notification = (KUSwitch*)[cell viewWithTag:9];
    sw_notification.indexPath = indexPath;
    [sw_notification addTarget:self action:@selector(swNotificationChanged:) forControlEvents:UIControlEventValueChanged];
    
    sw_notification.on = ([response isNotificationTarget])? YES:NO;
    
    //name
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = response.name;
    
    //通知マーク
    UIImageView *ic_notification = (UIImageView*)[cell viewWithTag:8];
    NSString *imgName = ([response isNotificationTarget])? @"notification_on":@"notification_off";
    ic_notification.alpha = ([response isNotificationTarget])? 1:0;
    ic_notification.image = [UIImage imageNamed:imgName];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //列車名を表示
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *selected_view = (UIView*)[cell viewWithTag:10];
    selected_view.alpha = (selected_view.alpha == 0)? 1:0;
    
    //他は選択解除
    for(UITableViewCell *other_cell in tableView.visibleCells){
        if(other_cell != cell){
        UIView *other_view = (UIView*)[other_cell viewWithTag:10];
        other_view.alpha = 0;
        }
    }
}

#pragma mark -
#pragma mark button action

- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)swNotificationChanged:(KUSwitch*)sw
{
    KUResponse *response = _responseManager.responses[sw.indexPath.row];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:sw.indexPath];
    UIImageView *ic_notification = (UIImageView*)[cell viewWithTag:8];

    
    if (sw.on) {//通知オン
        [KUNotificationTarget saveWithResponse:response condition:_condition];
        ic_notification.image = [UIImage imageNamed:@"notification_on"];
        ic_notification.alpha = 1.0;
    }
    
    else if(!sw.on){//通知オフ
        
        [KUNotificationTarget removeWithResonse:response condition:_condition];
        ic_notification.image = [UIImage imageNamed:@"notification_off"];
        ic_notification.alpha = 0;
        
    }
}

#pragma mark -
#pragma mark private method

- (UIImage*)imgForSeatValue:(enum KUSheetValue)seatValue
{
    NSString *imgName;
    
    switch (seatValue) {
            
        case SEAT_VACANT:{
            imgName = @"ic_vacant";
            break;
        }
            
        case SEAT_BIT:{
            imgName = @"ic_bit";
            break;
        }
            
        case SEAT_FULL:{
            imgName = @"ic_full";
            break;
        }
            
        case SEAT_INVALID:{
            imgName = @"ic_invalid";
            break;
        }
            
        case SEAT_NOT_EXIST_SMOKINGSEAT:{
            imgName = @"ic_not_exist";
            break;
        }
            
        default:
            break;
    }
    
    
    return [UIImage imageNamed:imgName];
}


- (void)setTitle
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    label.text = @"検索結果";
    self.navigationItem.titleView = label;
}

@end
