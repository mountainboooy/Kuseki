//
//  ResultsViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "ResultsViewController.h"
#import "KUSearchParamManager.h"
#import "KUClient.h"
#import "KUResponseManager.h"
#import "KUResponse.h"
#import "KUSearchCondition.h"
#import "KUSearchConditionManager.h"

@interface ResultsViewController ()
<UITableViewDataSource, UITableViewDelegate>

{
    //outlet
    __weak IBOutlet UITableView *_tableView;
    
    
    //model
    KUSearchCondition    *_condition;
    KUResponseManager    *_responseManager;
    
    KUClient *_client;
}

@end

@implementation ResultsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableView
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //model
    _responseManager = [KUResponseManager sharedManager];
    
    [_responseManager getResponsesWithParam:_condition completion:^{
        NSLog(@"completion:");
        NSLog(@"num:%lu",(unsigned long)_responseManager.responses.count);
        [_tableView reloadData];
        
    } failure:^{
        NSLog(@"failure");
    }];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
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
    KUResponse *response = _responseManager.responses[indexPath.row];

    
    //name
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = response.name;
    
    //dep_time
    UILabel *lb_dep_time = (UILabel*)[cell viewWithTag:2];
    lb_dep_time.text = [NSString stringWithFormat:@"%@発", response.dep_time];
    
    //arr_time
    UILabel *lb_arr_time = (UILabel*)[cell viewWithTag:3];
    lb_arr_time.text = [NSString stringWithFormat:@"%@着", response.arr_time];
    
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
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}



- (IBAction)btSavePressed:(id)sender {

    [_condition postConditionWithCompletion:^{
        NSString *message = @"この検索条件を保存しました";
        [AppDelegate showAlertWithTitle:nil message:message];
        
    } failure:^{
        NSString *message = @"保存に失敗しました";
        [AppDelegate showAlertWithTitle:nil message:message];
    }];
    
    //確認
    KUSearchConditionManager *manager = [KUSearchConditionManager sharedManager];
    [manager getConditionsFromDB];
    NSLog(@"array:%d",manager.conditions.count);
    
}
- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

@end
