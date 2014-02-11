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
    
    KUResponse *response1 = [KUResponse new];
    KUResponse *response2 = [KUResponse new];
    
    response1.name = @"name";
    response1.dep_time = @"dep_time";
    response1.arr_time = @"arr_time";
    
    response2.name = @"name2";
    response2.dep_time = @"dep_time2";
    response2.arr_time = @"arr_time2";
    
    XCTAssertTrue([target isSameTrainWithResponse:response1], @"通知ターゲットと結果の整合チェックに失敗");
    XCTAssertFalse([target isSameTrainWithResponse:response2], @"通知ターゲットと結果の整合チェックに失敗");
    
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