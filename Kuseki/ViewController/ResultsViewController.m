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

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    KUResponse *response = _responseManager.responses[indexPath.row];
    
    UILabel *lb_name = (UILabel*)[cell viewWithTag:1];
    lb_name.text = response.name;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}



- (IBAction)btSavePressed:(id)sender {

    [_condition postCondition];
    
    //確認
    KUSearchConditionManager *manager = [KUSearchConditionManager sharedManager];
    [manager getConditionsFromDB];
    NSLog(@"array:%d",manager.conditions.count);
    
}
- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
