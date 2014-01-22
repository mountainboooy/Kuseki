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

@interface ResultsViewController ()
<UIWebViewDelegate>

{
    //model
    KUSearchParamManager *_paramManager;
    KUResponseManager    *_responseManager;
    
    UIWebView *_webView;
    KUClient *_client;
}

@end

@implementation ResultsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //model
    _paramManager = [KUSearchParamManager sharedManager];
    _responseManager = [KUResponseManager sharedManager];
    
    [_responseManager getResponsesWithParam:_paramManager completion:^{
        NSLog(@"completion:");
        
    } failure:^{
        NSLog(@"failure");
    }];
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
