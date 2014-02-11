//
//  KUDifferencesManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUDifferencesManager.h"

@interface KUDifferencesManagerTests : XCTestCase

@end

@implementation KUDifferencesManagerTests

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

- (void)testCompareResponseWithTarget
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
    
    KUDifferencesManager *manager = [KUDifferencesManager sharedManager];
    
    [manager compareResponse:response withTarget:target];
    
    XCTAssertEqual(manager.differences.count, 2u, @"空席情報の差異の取得に失敗");

}

@end
