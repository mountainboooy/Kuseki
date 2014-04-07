//
//  KUSearchConditionManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/04/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUSearchCondition.h"
#import "KUSearchConditionManager.h"

@interface KUSearchConditionManagerTests : XCTestCase

@end

@implementation KUSearchConditionManagerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDeleteOldConditions
{
    KUSearchConditionManager *manager = [KUSearchConditionManager sharedManager];
    [manager deleteAllConditions];

    //古い検索条件を保存
    NSMutableDictionary *dic = [@{@"identifier":@"1",
                          @"year" :@"2013",
                          @"month":@"2",
                          @"day":@"20",
                          @"hour":@"15",
                          @"minute":@"30",
                          @"train":@"1",
                          @"dep_stn":@"東京",
                          @"arr_stn":@"新大阪"
                                   }mutableCopy];
    
    KUSearchCondition *condition_old = [[KUSearchCondition alloc]initWithDictionary:dic];
    [condition_old postConditionWithCompletion:nil failure:nil];
    
    
    //新しい検索条件を保存
    NSDateComponents *comps_plus = [NSDateComponents new];
    [comps_plus setYear:1];
    NSDate *date = [[NSCalendar currentCalendar]dateByAddingComponents:comps_plus toDate:[NSDate date] options:0];
    
    NSDateComponents *comps = [NSDateComponents new];
    comps = [[NSCalendar currentCalendar]components:NSYearCalendarUnit fromDate:date];
    
    dic[@"year"] = [NSString stringWithFormat:@"%ld",(long)comps.year];
    KUSearchCondition *condition_new = [[KUSearchCondition alloc]initWithDictionary:dic];
    [condition_new postConditionWithCompletion:nil failure:nil];
    
    [manager getConditionsFromDB];
    
    //古い検索条件を全て破棄
    [manager deleteOldConditions];
    
    XCTAssertEqual(manager.conditions.count, 1, @"古い検索条件の削除に失敗しました");
}

@end
