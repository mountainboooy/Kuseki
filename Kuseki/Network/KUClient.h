//
//  KUClient.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^KUNetworkCompletion)(NSString *dataString);
typedef void(^KUNetworkFailure)(NSHTTPURLResponse *res, NSError *error);

@interface KUClient : NSObject

@property (nonatomic,copy) KUNetworkCompletion completion;
@property (nonatomic,copy) KUNetworkFailure failure;
@property (nonatomic,strong) NSURL *base_url;
@property (nonatomic,strong) UIWebView *webView;

- (id)initWithBaseUrl:(NSURL*)base_url;

- (void)postPath:(NSString*)path param:(NSDictionary*)param completion:(KUNetworkCompletion)completion failure:(KUNetworkFailure)failure;

- (void)testWebView;

- (NSString*)stringParamFromDictionary:(NSDictionary*)dic_param;


@end
