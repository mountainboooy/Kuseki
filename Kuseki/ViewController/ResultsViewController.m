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

@interface ResultsViewController ()
<UIWebViewDelegate>

{
    KUSearchParamManager *_paramManager;
    UIWebView *_webView;
    KUClient *_client;
}

@end

@implementation ResultsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    
    //model
    _paramManager = [KUSearchParamManager sharedManager];
    
    NSURL *url = [NSURL URLWithString:@"http://yahoo.co.jp"];
    KUClient *client = [[KUClient alloc]initWithBaseUrl:url];
    

    

}

- (void)test{
    [_client testWebView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
