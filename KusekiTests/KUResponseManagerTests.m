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


- (void)testGetResponsesWithParamOfWestLine
{
    _isFinished = NO;
    
    //西側
    NSDictionary *dic = @{@"year":@"2014",
                          @"month":@"02",
                          @"day":@"20",
                          @"hour":@"15",
                          @"minute":@"30",
                          @"train":@"1",
                          @"dep_stn":@"東京",
                          @"arr_stn":@"新大阪"
                          };
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:dic];
    
    KUResponseManager *manager = [KUResponseManager sharedManager];
    
    [manager getResponsesWithParam:condition completion:^{
        NSLog(@"空席情報の数：%d",manager.responses.count);
        XCTAssertTrue(manager.responses.count > 0, @"空席情報の取得に失敗");
        _isFinished = YES;
        
    } failure:^(NSHTTPURLResponse *res, NSError *err) {
        if (!res && err) {
            XCTFail(@"空席情報が0です");
        
        }else{
            XCTFail(@"bodyDataを取得できませんでした");
        }
        _isFinished = YES;
    }];
}



- (void)testGetResponsesWithParamOfEastLine
{
    _isFinished = NO;
    
    //東
    NSDictionary *dic = @{@"year":@"2014",
                          @"month":@"02",
                          @"day":@"20",
                          @"hour":@"15",
                          @"minute":@"30",
                          @"train":@"3",
                          @"dep_stn":@"東京",
                          @"arr_stn":@"上野"
                          };
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:dic];
    
    KUResponseManager *manager = [KUResponseManager sharedManager];
    
    [manager getResponsesWithParam:condition completion:^{
        NSLog(@"空席情報の数：%d",manager.responses.count);
        XCTAssertTrue(manager.responses.count > 0, @"空席情報の取得に失敗");
        _isFinished = YES;
        
    } failure:^(NSHTTPURLResponse *res, NSError *err) {
        if (!res && !err) {
            XCTFail(@"空席情報が0です");
            
        }else{
            XCTFail(@"bodyDataを取得できませんでした");
        }
        _isFinished = YES;
    }];
}




@end
