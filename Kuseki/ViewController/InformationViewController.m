//
//  InformatoinViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/04/25.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()
<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
}

@end

@implementation InformationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lb_icons = (UILabel *)[cell viewWithTag:1];
    lb_icons.text = NSLocalizedString(@"meaningOfIcons", nil);
    
    UILabel *lb_vacant = (UILabel *)[cell viewWithTag:2];
    lb_vacant.text = NSLocalizedString(@"vacant", nil);
    
    UILabel *lb_slightly = (UILabel *)[cell viewWithTag:3];
    lb_slightly.text = NSLocalizedString(@"remainingSlightly", nil);
    
    UILabel *lb_occupied = (UILabel *)[cell viewWithTag:4];
    lb_occupied.text = NSLocalizedString(@"occupied", nil);
    
    UILabel *lb_not_applicable = (UILabel *)[cell viewWithTag:5];
    lb_not_applicable.text = NSLocalizedString(@"notApplicable", nil);
    
    UILabel *lb_nosmoking = (UILabel *)[cell viewWithTag:6];
    lb_nosmoking.text = NSLocalizedString(@"noSmokingVehicle", nil);
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}



- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
