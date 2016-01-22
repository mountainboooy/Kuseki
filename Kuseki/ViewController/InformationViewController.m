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
    
    UILabel *icons_meaning = (UILabel *)[cell viewWithTag:1];
    icons_meaning.text = NSLocalizedString(@"meaningOfIcons", nil);
    
    UILabel *vacant = (UILabel *)[cell viewWithTag:2];
    vacant.text = NSLocalizedString(@"vacant", nil);
    
    UILabel *remaining_slightly = (UILabel *)[cell viewWithTag:3];
    remaining_slightly.text = NSLocalizedString(@"remainingSlightly", nil);
    
    UILabel *occupied = (UILabel *)[cell viewWithTag:4];
    occupied.text = NSLocalizedString(@"occupied", nil);
    
    UILabel *not_applicable = (UILabel *)[cell viewWithTag:5];
    not_applicable.text = NSLocalizedString(@"notApplicable", nil);
    
    UILabel *nosmoking = (UILabel *)[cell viewWithTag:6];
    nosmoking.text = NSLocalizedString(@"noSmokingVehicle", nil);
    
    UILabel *usage = (UILabel *)[cell viewWithTag:7];
    usage.text = NSLocalizedString(@"useage", nil);
    
    UILabel *available_time = (UILabel *)[cell viewWithTag:8];
    available_time.text = NSLocalizedString(@"availableTime", nil);
    
    UILabel *max_length = (UILabel *)[cell viewWithTag:9];
    max_length.text = NSLocalizedString(@"maxLength", nil);
    
    UILabel *soucrce = (UILabel *)[cell viewWithTag:11];
    soucrce.text = NSLocalizedString(@"infoSource", nil);
    
    UILabel *notificationFeature = (UILabel *)[cell viewWithTag:12];
    notificationFeature.text = NSLocalizedString(@"notificationFeature", nil);
    
    UILabel *description_notification = (UILabel *)[cell viewWithTag:13];
    description_notification.text = NSLocalizedString(@"descriptionForNotification", nil);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}



- (IBAction)btBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
