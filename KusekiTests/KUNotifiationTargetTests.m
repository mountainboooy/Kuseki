//
//  KUNotifiationTargetTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUNotificationTarget.h"
#import "KUResponse.h"
#import "KUNotificationTargetsManager.h"

@interface KUNotifiationTargetTests : XCTestCase

@end

@implementation KUNotifiationTargetTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testIsSameTrainWithResponse
{
    KUNotificationTarget *target = [KUNotificationTarget new];
    target.name = @"name";
    target.dep_time = @"dep_time";
    target.arr_time = @"arr_time";
    target.month = @"01";
    target.day   = @"19";
    
    KUResponse *response1 = [KUResponse new];
    KUResponse *response2 = [KUResponse new];
    
    response1.name = @"name";
    response1.dep_time = @"dep_time";
    response1.arr_time = @"arr_time";
    response1.month = @"01";
    response1.day = @"19";
    
    response2.name = @"name";
    response2.dep_time = @"dep_time";
    response2.arr_time = @"arr_time";
    response2.day = @"20";
    response1.month = @"01";
    
    XCTAssertTrue([target isSameTrainWithResponse:response1], @"通知ターゲットと結果の整合チェックに失敗");
    XCTAssertFalse([target isSameTrainWithResponse:response2], @"通知ターゲットと結果の整合チェックに失敗");
    
}



-(void)testSaveWithResponse
{
    
    //DBクリア
    KUNotificationTargetsManager *manager = [KUNotificationTargetsManager sharedManager];
    [manager removeAllTargets];
    
    //response
    NSDictionary *dic = @{@"name":@"のぞみ",
                          @"dep_time":@"10:00",
                          @"arr_time":@"12:00",
                          @"seat_ec_ns":@"○",
                          @"seat_ec_s":@"○",
                          @"seat_gr_ns":@"○",
                          @"seat_gr_s":@"○",
                          @"month":@"01",
                          @"day":@"19"
                          };
    KUResponse *response  = [[KUResponse alloc]initWithDictionary:dic];
    
    //condition
    KUSearchCondition *condition = [KUSearchCondition new];
    condition.dep_stn = @"東京";
    condition.arr_stn = @"新大阪";
    
    [KUNotificationTarget saveWithResponse:response condition:condition];
    
    
    //保存した内容を確認
    [manager selectAllTargets];
    KUNotificationTarget *savedTarget = manager.targets[0];
    
    XCTAssertEqualObjects(savedTarget.name, @"のぞみ", @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.dep_time, @"10:00", @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.arr_time, @"12:00", @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.dep_stn, @"東京", @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.arr_stn, @"新大阪", @"通知対象の保存に失敗");
    XCTAssertEqual(savedTarget.seat_ec_ns, SEAT_VACANT, @"通知対象の保存に失敗");
    XCTAssertEqual(savedTarget.seat_ec_s, SEAT_VACANT, @"通知対象の保存に失敗");
    XCTAssertEqual(savedTarget.seat_gr_ns, SEAT_VACANT, @"通知対象の保存に失敗");
    XCTAssertEqual(savedTarget.seat_gr_s, SEAT_VACANT, @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.month, @"01", @"通知対象の保存に失敗");
    XCTAssertEqualObjects(savedTarget.day, @"19", @"通知対象の保存に失敗");
    
    
    
    
}


- (void)testDifferencesWithResponse
{
    KUNotificationTarget *target = [KUNotificationTarget new];
    target.name = @"name";
    target.dep_time = @"dep_time";
    target.arr_time = @"arr_time";
    target.seat_ec_ns   = SEAT_FULL;
    target.seat_ec_s    = SEAT_FULL;
    target.seat_gr_ns   = SEAT_FULL;
    target.seat_gr_s    = SEAT_FULL;
    
    
    KUResponse *response = [KUResponse new];
    response.name = @"name";
    response.dep_time = @"dep_time";
    response.arr_time = @"arr_time";
    response.seat_ec_ns   = SEAT_FULL;
    response.seat_ec_s    = SEAT_FULL;
    response.seat_gr_ns   = SEAT_BIT;
    response.seat_gr_s    = SEAT_BIT;
    
}

@end
