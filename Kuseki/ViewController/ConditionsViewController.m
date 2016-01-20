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
#import "KUButton.h"
#import "KUNotificationTarget.h"
#import "Flurry.h"
#import "KUStationsManager.h"

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
    
    [self setTitle];
    
    _conditionManager = [KUSearchConditionManager sharedManager];
}


- (void)viewWillAppear:(BOOL)animated
{
    //時期を過ぎてしまった検索条件を削除
    [_conditionManager deleteOldConditions];
    
    [_conditionManager getConditionsFromDB];
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *num = [NSString stringWithFormat:@"%ld",_conditionManager.conditions.count];
    NSDictionary *param = @{@"number_of_conditions":num};
    
    [Flurry logEvent:@"ConditionsViewDidAppear" withParameters:param];
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
    lb_month_day.text = [NSString stringWithFormat:@"%@/%@", condition.month, condition.day];
    
    //時間
    UILabel *lb_time = (UILabel*)[cell viewWithTag:2];
    lb_time.text = [NSString stringWithFormat:@"%@ : %@",condition.hour, condition.minute];
    
    //dep_stn
    UILabel *lb_dep_stn = (UILabel*)[cell viewWithTag:3];
    lb_dep_stn.text = [KUStationsManager localizedStation:condition.dep_stn];
    
    //arr_stn
    UILabel *lb_arr_stn = (UILabel*)[cell viewWithTag:4];
    lb_arr_stn.text= [KUStationsManager localizedStation:condition.arr_stn];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header0"];
    UILabel *lb_date = (UILabel *)[cell viewWithTag:1];
    UILabel *lb_time = (UILabel *)[cell viewWithTag:2];
    UILabel *lb_departure = (UILabel *)[cell viewWithTag:3];
    UILabel *lb_destination = (UILabel *)[cell viewWithTag:4];
    lb_date.text = NSLocalizedString(@"rideDate", nil);
    lb_time.text = NSLocalizedString(@"rideTime", nil);
    lb_departure.text = NSLocalizedString(@"departureStation", nil);
    lb_destination.text = NSLocalizedString(@"destinationStation", nil);
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isValidTime:[NSDate date]]) {
        NSString *message = @"22:30〜6:30の間は情報が提供されません";
        [AppDelegate showAlertWithTitle:nil message:message completion:nil];
    }
    
    
    SavedResultViewController *savedResCon = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedResultViewController"];
    savedResCon.condition = _conditionManager.conditions[indexPath.row];
    savedResCon.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:savedResCon animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //検索条件を削除
    KUSearchCondition *condition = _conditionManager.conditions[indexPath.row];
    [condition deleteCondition];
    
    //テーブル更新
    [_conditionManager getConditionsFromDB];
    //[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_tableView reloadData];
    
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


- (void)setTitle
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    label.text = NSLocalizedString(@"savedHistory", nil);
    self.navigationItem.titleView = label;
    
}

#pragma mark -
#pragma mark button action
- (IBAction)btTrashPressed:(UIBarButtonItem *)sender {
    
    if (_tableView.isEditing) {//編集を完了
        [_tableView setEditing:NO animated:YES];
        [sender setTintColor:[UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1]];
        
        return;
    }
    
    [_tableView setEditing:YES animated:YES];
    [sender setTintColor:[UIColor colorWithRed:0 green:0.47 blue:1.0 alpha:1.0]];
}





@end
