//
//  KUDifferenceTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUDifference.h"
#import "KUNotificationTarget.h"
@interface KUDifferenceTests : XCTestCase

@end

@implementation KUDifferenceTests

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

- (void)testInitWithCondition
{
    
    KUNotificationTarget  *target;
    target.name = @"のぞみ";
    target.dep_time = @"11:00";
    target.arr_time = @"15:00";
    target.dep_stn = @"東京";
    target.arr_stn = @"新大阪";
    
    KUDifference *diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_ns" previousValue:SEAT_FULL currentValue:SEAT_BIT];
    
    XCTAssertEqualObjects(diff.trainName, target.name, @"空席情報差異の生成に失敗");
    XCTAssertEqualObjects(diff.dep_time, target.dep_time, @"空席情報差異の生成に失敗");
    XCTAssertEqualObjects(diff.arr_time, target.arr_time, @"空席情報差異の生成に失敗");
    XCTAssertEqualObjects(diff.dep_stn, target.dep_stn, @"空席情報差異の生成に失敗");
    XCTAssertEqualObjects(diff.arr_stn, target.arr_stn, @"空席情報差異の生成に失敗");    

}


- (void)testStringWithSeatValue
{
    //空席情報をstringのマークに変換する機能のテスト
    
    //previousValue
    KUDifference *diff = [KUDifference new];
    diff.previousValue = SEAT_BIT;
    XCTAssertEqualObjects([diff stringWithPreviousValue], @"△", @"空席値のstring化に失敗");
    diff.previousValue = SEAT_FULL;
    XCTAssertEqualObjects([diff stringWithPreviousValue], @"×", @"空席値のstring化に失敗");
    
    diff.previousValue = SEAT_INVALID;
    XCTAssertEqualObjects([diff stringWithPreviousValue], @"-", @"空席値のstring化に失敗");
    
    diff.previousValue = SEAT_NOT_EXIST_SMOKINGSEAT;
    XCTAssertEqualObjects([diff stringWithPreviousValue], @"＊", @"空席値のstring化に失敗");
    
    diff.previousValue = SEAT_VACANT;
    XCTAssertEqualObjects([diff stringWithPreviousValue], @"○", @"空席値のstring化に失敗");
    
}


- (void)testStringWithSeatGrade
{
    KUNotificationTarget  *target = [KUNotificationTarget new];
    target.name = @"のぞみ";
    target.dep_time = @"11:00";
    target.arr_time = @"15:00";
    target.dep_stn = @"東京";
    target.arr_stn = @"新大阪";
    
    KUDifference *diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_ns" previousValue:SEAT_FULL currentValue:SEAT_BIT];
    
    XCTAssertEqualObjects([diff stringWithSeatGrade], @"普通車(禁煙)", @"座席の表示内容変換に失敗");
    
    diff.seat = @"seat_ec_s";
    XCTAssertEqualObjects([diff stringWithSeatGrade], @"普通車(喫煙)", @"座席の表示内容変換に失敗");
    
    diff.seat = @"seat_gr_ns";
    XCTAssertEqualObjects([diff stringWithSeatGrade], @"グリーン車(禁煙)", @"座席の表示内容変換に失敗");
    
    diff.seat = @"seat_gr_s";
    XCTAssertEqualObjects([diff stringWithSeatGrade], @"グリーン車(喫煙)", @"座席の表示内容変換に失敗");
    
}

- (void)testMessageForNotification
{
    KUNotificationTarget  *target = [KUNotificationTarget new];
    target.name = @"のぞみ";
    target.dep_time = @"11:00";
    target.arr_time = @"15:00";
    target.dep_stn = @"東京";
    target.arr_stn = @"新大阪";
    
    KUDifference *diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_ns" previousValue:SEAT_FULL currentValue:SEAT_BIT];
    
    NSString *connrectMessage = @"のぞみ 東京11:00発 新大阪15:00着 普通車(禁煙) ×から△に変化";
    NSString *message = [diff messageForNotification];
    XCTAssertEqualObjects(message, connrectMessage, @"通知用のメッセージの生成に失敗");
}


@end
