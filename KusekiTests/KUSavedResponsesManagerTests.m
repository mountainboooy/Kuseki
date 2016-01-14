//
//  KUSavedResponsesManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUSearchCondition.h"
#import "KUSavedResponsesManager.h"
#import "KUFactory.h"

@interface KUSavedResponsesManagerTests : XCTestCase
<KUSavedResponsesManagerDelegate>

{
    BOOL _isFinished;
}

@end

@implementation KUSavedResponsesManagerTests

- (void)setUp
{
    [super setUp];
    _isFinished = YES;
}

- (void)tearDown
{
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (!_isFinished);
    
    [super tearDown];
}


- (void)testGetResponsesWithParamOfWestLine
{
    _isFinished = NO;
    KUFactory *sharedFactory = [KUFactory sharedFactory];
    NSDictionary *sampleParam = [sharedFactory sampleParam];
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:sampleParam];
    
    KUSavedResponsesManager *manager =[KUSavedResponsesManager sharedManager];
    [manager getResponsesWithParam:condition completion:^{
        XCTAssertTrue(manager.responses.count>0, @"単一条件からの空席情報の取得に失敗");
        _isFinished = YES;
    
    }failure:^(NSHTTPURLResponse *res, NSError *err) {
        XCTFail(@"単一条件からの空席情報の取得に失敗");
        _isFinished = YES;
    }];
    
}


- (void)testGetResponsesWithParamOfEastLine
{
    _isFinished = NO;
    
    //東
    NSDictionary *dic = @{@"year":@"2014",
                          @"month":@"05",
                          @"day":@"20",
                          @"hour":@"15",
                          @"minute":@"30",
                          @"train":@"3",
                          @"dep_stn":@"東京",
                          @"arr_stn":@"上野"
                          };
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:dic];
    
    KUSavedResponsesManager *manager = [KUSavedResponsesManager sharedManager];
    
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


- (void)testGetResponsesWithConditions
{
    _isFinished = NO;
    NSDictionary *dic1 = @{@"identifier":@"1",
                           @"month":@"5",
                           @"day":@"20",
                           @"hour":@"15",
                           @"minute":@"30",
                           @"train":@"1",
                           @"dep_stn":@"東京",
                           @"arr_stn":@"新大阪"
                           };
    
    NSDictionary *dic2 = @{@"identifier":@"2",
                           @"month":@"5",
                           @"day":@"21",
                           @"hour":@"15",
                           @"minute":@"30",
                           @"train":@"1",
                           @"dep_stn":@"京都",
                           @"arr_stn":@"新横浜"
                           };
    
    NSDictionary *dic3 = @{@"identifier":@"3",
                           @"month":@"5",
                           @"day":@"22",
                           @"hour":@"16",
                           @"minute":@"30",
                           @"train":@"1",
                           @"dep_stn":@"名古屋",
                           @"arr_stn":@"東京"
                           };
    
    KUSearchCondition *condition1 = [[KUSearchCondition alloc]initWithDictionary:dic1];
    
    KUSearchCondition *condition2 = [[KUSearchCondition alloc]initWithDictionary:dic2];
    
    KUSearchCondition *condition3 = [[KUSearchCondition alloc]initWithDictionary:dic3];
    
    NSArray *conditions = @[condition1, condition2, condition3];
    
    
    KUSavedResponsesManager *manager = [KUSavedResponsesManager sharedManager];
    manager.delegate  = self;
    
    [manager getResponsesWithConditions:conditions];
    
    
}


- (void)savedResponseManager:(id)manager DidFinishLoadingResponses:(NSArray *)responses
{
    XCTAssertTrue(responses.count > 0, @"複数の検索条件からの空席情報取得に失敗");
    NSLog(@"responses.count:%d",responses.count);
    _isFinished = YES;
}


- (void)savedResponseManagerDidFailLoading
{
    XCTFail(@"複数の検索条件からの空席情報取得に失敗");
    _isFinished = YES;
}

    


@end
