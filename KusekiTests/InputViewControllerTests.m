//
//  InputViewControllerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/15.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "InputViewController.h"

@interface InputViewControllerTests : XCTestCase

@end

@implementation InputViewControllerTests

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

- (void)testIsValidTime
{
    InputViewController *inputCon = [InputViewController new];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];

    [formatter setDateFormat:@"yyyy/mm/dd HH:mm"];
    
    //too early
    NSDate *erary = [formatter dateFromString:@"2014/02/15 06:15"];
    XCTAssertFalse([inputCon isValidTime:erary], @"時間のバリデーションに失敗");
    //valid time
    NSDate *valid = [formatter dateFromString:@"2014/02/15 06:40"];
    XCTAssertTrue([inputCon isValidTime:valid], @"時間のバリデーションに失敗");
    
    //too late
    NSDate *late = [formatter dateFromString:@"2014/02/15 23:40"];
    XCTAssertFalse([inputCon isValidTime:late], @"時間のバリデーションに失敗");
    NSLog(@"late:%@",[formatter stringFromDate:late]);
}


@end
