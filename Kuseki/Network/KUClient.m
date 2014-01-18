//
//  KUClient.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUClient.h"

@interface KUClient()
<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation KUClient


- (void)getSheetInfoWithParam:(NSDictionary *)param completion:(KUNetworkCompletion)completion failure:(KUNetworkFailure)failure
{
    
    //param
    NSString *param_str = [self stringParamFromDictionary:param];
    
    
    NSString *url_str = @"http://www1.jr.cyberstation.ne.jp/csws/Vacancy.do";
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[param_str dataUsingEncoding:NSUTF8StringEncoding]];
    [req setValue:@"http://www.jr.cyberstation.ne.jp/vacancy/Vacancy.html" forHTTPHeaderField:@"Referer"];
    
    
    
    
    
}


- (NSString*)stringParamFromDictionary:(NSDictionary*)dic_param
{
    NSMutableString *param_str = [NSMutableString new];
    //stringの一文で作成
    NSArray *keys = [dic_param allKeys];
    for (NSString *key in keys) {
        NSString *p = [NSString stringWithFormat:@"%@=%@&",key,dic_param[key]];
    
        [param_str appendString:p];
    }
    
    
    return param_str;
}


#pragma mark -
#pragma mark webView

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //error
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *body = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"innerHTML:%@",body);
}



@end
