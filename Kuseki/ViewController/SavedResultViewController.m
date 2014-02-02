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
    } failure:^{
        NSLog(@"失敗");
        
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
    cell =  [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    [self updateCell:cell atIndexPath:indexPath];
    
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
    
    //arr_time
    UILabel *lb_arr_time = (UILabel*)[cell viewWithTag:3];
    
    //ec_ns
    UIImageView *iv_ec_ns = (UIImageView*)[cell viewWithTag:4];
    
    //ec_s
    UIImageView *iv_ec_s = (UIImageView*)[cell viewWithTag:5];
    
    //gr_ns
    UIImageView *iv_gr_ns = (UIImageView*)[cell viewWithTag:6];
    
    //gr_s
    UIImageView *iv_gr_s = (UIImageView*)[cell viewWithTag:7];
    
    
    
}


- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
