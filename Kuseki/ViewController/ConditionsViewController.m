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
    [_conditionManager getConditionsFromDB];
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
    
    UILabel *lb_dep_stn = (UILabel*)[cell viewWithTag:1];
    lb_dep_stn.text = condition.dep_stn;
    
}


@end
