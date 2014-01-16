//
//  ViewController.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/13.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()
<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *_webView;
    NSMutableData *_data;
    
    int _num;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //param
    NSDictionary *param;
    param = @{@"month": @"01",
              @"day":@"30",
              @"hour":@"13",
              @"minute":@"30",
              @"train":@"5",
              @"dep_stn":@"新大阪",
              @"arr_stn":@"東京"};
    
    NSString *param_str = @"month=01&day=30&hour=13&minute=30&train=1&dep_stn=%8b%9e%93s&arr_stn=%93%8c%8b%9e";

    //request
    
    NSURL *url = [NSURL URLWithString:@"http://www1.jr.cyberstation.ne.jp/csws/Vacancy.do"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[param_str dataUsingEncoding:NSUTF8StringEncoding]];
    [req setValue:@"http://www.jr.cyberstation.ne.jp/vacancy/Vacancy.html" forHTTPHeaderField:@"Referer"];
    
    
    //webViewに表示してみる
    _webView.delegate = self;
    [_webView loadRequest:req];
    
    
    _num = 0;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(testBackGround) userInfo:nil repeats:YES];
    [timer fire];
    

    
    
}

- (void)testBackGround
{
    //バックグラウンドでwebへの定期的な接続を試みる
    NSString *url_str = @"http://yahoo.co.jp";
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    [op setCompletionBlock:^{
        NSLog(@"num:%d",_num);
        _num += 1;
    }];
    
    [op start];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *body  = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"innerHTML=%@",body);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *html = [[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"html2:%@",html);
    return YES;
}


@end
