//
//  KUDBClientTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/30.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUDBClient.h"
#import "KUResponse.h"
#import "KUSearchCondition.h"

@interface KUDBClientTests : XCTestCase

@end

@implementation KUDBClientTests

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


- (void)testUpdateNotificationTarget
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteAllTargets];
    
    KUNotificationTarget *target = [KUNotificationTarget new];
    target.name = @"target_name";
    target.dep_time = @"dep_time";
    target.arr_time = @"arr_time";
    target.seat_ec_ns = 1;
    target.seat_ec_s  = 1;
    target.seat_gr_ns = 1;
    target.seat_gr_s  = 1;
    target.seat_gs_ns = 1;
    target.condition_id = 0;
    target.dep_stn = @"dep_stn";
    target.arr_stn = @"arr_stn";
    target.month = @"1";
    target.day = @"1";
    
    //保存
    [client insertNotificationTarget:target];
    
    //通知対象が保存されていること
    NSArray *targets = [client selectAllNotificationTargets];
    KUNotificationTarget *savedTarget = targets[0];
    XCTAssertEqualObjects(savedTarget.name, @"target_name", @"通知対象の保存に失敗");
    
    savedTarget.name = @"target_name_2";
    [client updateNotificationTarget:savedTarget];
    
    //通知対象が更新されていること
    NSArray *targets_2 = [client selectAllNotificationTargets];
    KUNotificationTarget  *savedTarget2 = targets_2[0];
    XCTAssertEqualObjects(savedTarget2.name, @"target_name_2", @"通知対象の更新に失敗");
    
}


@end
