//
//  KUNotificationTargetsManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/12.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUNotificationTargetsManager.h"
#import "KUNotificationTarget.h"

@interface KUNotificationTargetsManagerTests : XCTestCase

@end

@implementation KUNotificationTargetsManagerTests

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

- (void)testRemoveAllTargets
{
    
    //ひとつ保存
    //response
    NSDictionary *dic = @{@"name":@"のぞみ",
                          @"dep_time":@"10:00",
                          @"arr_time":@"12:00",
                          @"seat_ec_ns":@"○",
                          @"seat_ec_s":@"○",
                          @"seat_gr_ns":@"○",
                          @"seat_gr_s":@"○"
                          };
    
    KUResponse *response  = [[KUResponse alloc]initWithDictionary:dic];
    
    //condition
    KUSearchCondition *condition = [KUSearchCondition new];
    condition.dep_stn = @"東京";
    condition.arr_stn = @"新大阪";
    
    [KUNotificationTarget saveWithResponse:response condition:condition];
    
    //クリア
    NSLog(@"クリア");
    KUNotificationTargetsManager *manager = [KUNotificationTargetsManager sharedManager];
    [manager removeAllTargets];
    
    XCTAssertEqual(manager.targets.count, 0u, @"通知設定のクリアに失敗");
     
}

@end
