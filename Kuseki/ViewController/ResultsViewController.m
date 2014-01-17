//
//  ResultsViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "ResultsViewController.h"
#import "KUSearchParamManager.h"

@interface ResultsViewController ()

{
    KUSearchParamManager *_paramManager;
}

@end

@implementation ResultsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //model
    _paramManager = [KUSearchParamManager sharedManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
