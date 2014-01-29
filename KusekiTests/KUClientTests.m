//
//  KUClientTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/18.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>   
#import "KUClient.h"

@interface KUClientTests : XCTestCase
{
    BOOL _isFinished;
}
@end

@implementation KUClientTests

- (void)setUp
{
    
    [super setUp];
    _isFinished  = YES;
}

- (void)tearDown
{
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (!_isFinished);
    
    [super tearDown];
}


- (void)testStringPramFromDictionary
{
    NSDictionary *dic_param = @{@"firstname":@"takeru",
                                @"lastname":@"yoshihara",
                                @"age":@"33",
                                @"city":@"osaka"};
    
    KUClient *client = [KUClient new];
    NSString *str_param = [client stringParamFromDictionary:dic_param];
    NSString *str_correct = @"age=33&lastname=yoshihara&city=osaka&firstname=takeru&";
    XCTAssertEqualObjects(str_param, str_correct, @"パラメータの作成に失敗");
    
}


- (void)testPost
{
    _isFinished = NO;
    
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
        _isFinished = YES;
        
    
    } failure:^(NSHTTPURLResponse *res, NSError *error) {
        XCTAssertEqual(res.statusCode, 200u, @"HTMLの取得に失敗");
        _isFinished = YES;
        
    }];
    
}


@end
