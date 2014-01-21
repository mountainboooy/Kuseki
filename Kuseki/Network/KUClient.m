//
//  KUClient.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUClient.h"
#import "AFHTTPRequestOperation.h"

@interface KUClient()
<UIWebViewDelegate>
{
}
@end

@implementation KUClient


- (id)initWithBaseUrl:(NSURL*)base_url;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _base_url = base_url;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _webView.delegate = self;
    
    return self;
}



- (void)postPath:(NSString*)path param:(NSDictionary*)param completion:(KUNetworkCompletion)completion failure:(KUNetworkFailure)failure
{
    //action
    _completion = completion;
    _failure = failure;
    
    //url
    NSString *base_url_str = [_base_url absoluteString];
    NSString *full_url_str = [NSString stringWithFormat:@"%@%@",base_url_str, path];
    NSURL *url = [NSURL URLWithString:full_url_str];
    NSLog(@"url:%@",url.absoluteString);
    
    //param
    NSString *param_str;
    if (param) {
        param_str = [self stringParamFromDictionary:param];
    }
    NSLog(@"param_str:%@",param_str);
    NSData *sendData = [param_str dataUsingEncoding:NSUTF8StringEncoding];
    
    //request
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"http://www.jr.cyberstation.ne.jp/vacancy/Vacancy.html" forHTTPHeaderField:@"Referer"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[sendData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:sendData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:req];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *buffer = responseObject;
        if (buffer) {
            //resonse
            int encodeArray[] = {
                NSUTF8StringEncoding,			// UTF-8
                NSShiftJISStringEncoding,		// Shift_JIS
                NSJapaneseEUCStringEncoding,	// EUC-JP
                NSISO2022JPStringEncoding,		// JIS
                NSUnicodeStringEncoding,		// Unicode
                NSASCIIStringEncoding			// ASCII
            };
            
            
            NSString *dataString = nil;
            int max = sizeof(encodeArray) / sizeof(encodeArray[0]);
            
            for (int i=0; i<max; i++) {
                dataString = [[NSString alloc]initWithData:buffer encoding:encodeArray[i]];
                
                if(dataString){
                    break;
                }
            }
            
            if (completion) {
                completion(dataString);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(operation.response, error);
        }
        
    }];
    
    [op start];
z1
}



- (NSString*)stringParamFromDictionary:(NSDictionary*)dic_param
{
    NSMutableString *param_str = [NSMutableString new];
    //stringの一文で作成
    NSArray *keys = [dic_param allKeys];
    for (NSString *key in keys) {
        NSString *p = [NSString stringWithFormat:@"%@=%@&",key,[self urlEncodeString:dic_param[key]]];
    
        [param_str appendString:p];
    }
    
    
    return param_str;
}



- (NSString*)urlEncodeString:(NSString*)string
{
    NSString *escapedStfing = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingShiftJIS));
    
    return escapedStfing;
}




@end
