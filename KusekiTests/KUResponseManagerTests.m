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
#import "KUFactory.h"

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
    KUFactory *factory = [KUFactory sharedFactory];
    NSDictionary *param = [factory sampleParamForWestLine];
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:param];
    
    KUResponseManager *manager = [KUResponseManager sharedManager];
    
    [manager getResponsesWithParam:condition completion:^{
        NSLog(@"空席情報の数：%lu",(unsigned long)manager.responses.count);
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
    KUFactory *factory = [KUFactory sharedFactory];
    
    NSDictionary *param = [factory sampleParamForEastLine];
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:param];
    
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
