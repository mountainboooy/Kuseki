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

@interface KUSavedResponsesManagerTests : XCTestCase

@end

@implementation KUSavedResponsesManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetResponsesWithConditions
{
    /*
    NSDictionary *dic1 = @{@"identifier":@"1",
                           @"month":@"2",
                           @"day":@"20",
                           @"hour":@"15",
                           @"minute":@"30",
                           @"train":@"1",
                           @"dep_stn":@"東京",
                           @"arr_stn":@"新大阪"
                           };
    
    NSDictionary *dic2 = @{@"identifier":@"2",
                           @"month":@"2",
                           @"day":@"21",
                           @"hour":@"15",
                           @"minute":@"30",
                           @"train":@"1",
                           @"dep_stn":@"京都",
                           @"arr_stn":@"新横浜"
                           };
    
    NSDictionary *dic3 = @{@"identifier":@"3",
                           @"month":@"2",
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
    
    [manager getResponsesWithConditions:conditions];
    
    NSLog(@"manager.responses.count:%d",manager.responses.count);
    XCTAssertTrue(manager.responses.count > 0, @"複数の空席情報の結果取得に失敗");
    
    
    */

    
    
}

@end
