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
    return 10;
}



@end
