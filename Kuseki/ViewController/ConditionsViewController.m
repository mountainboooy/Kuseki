//
//  ConditionsViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/01.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "ConditionsViewController.h"
#import "KUSearchConditionManager.h"
#import "KUSearchCondition.h"
#import "SavedResultViewController.h"

@interface ConditionsViewController ()
<UITableViewDataSource, UITableViewDelegate>
{
    //outlet
    __weak IBOutlet UITableView *_tableView;
    
    //model
    KUSearchConditionManager *_conditionManager;
}

@end

@implementation ConditionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _conditionManager = [KUSearchConditionManager sharedManager];
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [_conditionManager getConditionsFromDB];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -
#pragma  makrk tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _conditionManager.conditions.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    if (_conditionManager.conditions.count == 0) {
        return;
    }
    
    KUSearchCondition *condition = _conditionManager.conditions[indexPath.row];
    
    //月日
    UILabel *lb_month_day = (UILabel*)[cell viewWithTag:1];
    lb_month_day.text = [NSString stringWithFormat:@"%@月%@日", condition.month, condition.day];
    
    //時間
    UILabel *lb_time = (UILabel*)[cell viewWithTag:2];
    lb_time.text = [NSString stringWithFormat:@"%@時%@分",condition.hour, condition.minute];
    
    //dep_stn
    UILabel *lb_dep_stn = (UILabel*)[cell viewWithTag:3];
    lb_dep_stn.text = condition.dep_stn;
    
    //arr_stn
    UILabel *lb_arr_stn = (UILabel*)[cell viewWithTag:4];
    lb_arr_stn.text= condition.arr_stn;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isValidTime:[NSDate date]]) {
        NSString *message = @"23:30〜6:30の間は情報が提供されません";
        [AppDelegate showAlertWithTitle:nil message:message completion:nil];
    }
    
    
    SavedResultViewController *savedResCon = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedResultViewController"];
    savedResCon.condition = _conditionManager.conditions[indexPath.row];
    savedResCon.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:savedResCon animated:YES];
    
    
}


#pragma mark -
#pragma mark private methods
- (BOOL)isValidTime:(NSDate*)date
{
    
    if (!date) {
        [[NSException exceptionWithName:@"TimeValudateionExecption" reason:@"date is null" userInfo:nil] raise];
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    //    formatter.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    //    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JIST"];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *date_str = [formatter stringFromDate:date];
    NSLog(@"current time:%@", date_str);
    
    NSLog(@"toindex2:%@",[date_str substringToIndex:2]);
    NSLog(@"fromindex3:%@",[date_str substringFromIndex:3]);
    
    
    if ([date_str substringToIndex:2].intValue < 6 ||
        ([date_str substringToIndex:2].intValue == 6 &&
         [date_str substringFromIndex:3].intValue < 30)) {
            //時間が早すぎる
            return NO;
        }
    
    if ([date_str substringToIndex:2].intValue > 22 ||
        ([date_str substringToIndex:2].intValue == 22 &&
         [date_str substringFromIndex:3].intValue > 30)) {
            //時間が遅すぎる
            return NO;
        }
    
    return YES;
    
}


@end
