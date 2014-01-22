//
//  KUResponseManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/21.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUResponseManager.h"
#import "KUClient.h"

@interface KUResponseManagerTests : XCTestCase
{
    BOOL _isFinished;
}

@end

@implementation KUResponseManagerTests

- (void)setUp
{
    [super setUp];
    _isFinished = YES;
}

- (void)tearDown
{
    do {
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (!_isFinished);
    
    [super tearDown];
}

- (void)testParseHTML
{
    _isFinished = NO;
    
    //html取得
    NSDictionary *dic_param = @{@"month":@"02",
                                @"day":@"15",
                                @"hour":@"15",
                                @"minute":@"30",
                                @"train":@"1",
                                @"dep_stn":@"東京",
                                @"arr_stn":@"新大阪"};
    
    NSURL *base_url = [NSURL URLWithString:@"http://www1.jr.cyberstation.ne.jp/"];
    NSString *path = @"csws/Vacancy.do";
    
    KUClient *client = [[KUClient alloc]initWithBaseUrl:base_url];
    
    
    [client postPath:path param:dic_param completion:^(NSString *dataString) {
        
        NSLog(@"取得成功");
        KUResponseManager *manager = [KUResponseManager sharedManager];
        [manager parseHTML:dataString];
        
        _isFinished = YES;
        
        
    } failure:^(NSHTTPURLResponse *res, NSError *error) {
        
        NSLog(@"取得失敗");
        _isFinished = YES;
        
    }];
    
    
}

@end
