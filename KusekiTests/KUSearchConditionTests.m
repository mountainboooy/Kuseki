//
//  KUSearchConditionTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/30.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUSearchCondition.h"

@interface KUSearchConditionTests : XCTestCase

@end

@implementation KUSearchConditionTests

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

- (void)testInitWithDictionary
{
    NSDictionary *dic = @{@"identifier" : @"111",
                          @"month"  : @"1",
                          @"day"    : @"15",
                          @"hour"   : @"21",
                          @"minute" : @"30",
                          @"train"  : @"train",
                          @"dep_stn": @"tokyo",
                          @"arr_stn": @"hakata"
                          };
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:dic];
    
    XCTAssertEqualObjects(condition.identifier, dic[@"identifier"], @"");
    XCTAssertEqualObjects(condition.month, dic[@"month"], @"");
    XCTAssertEqualObjects(condition.day, dic[@"day"], @"");
    XCTAssertEqualObjects(condition.hour, dic[@"hour"], @"");
    XCTAssertEqualObjects(condition.minute, dic[@"minute"], @"");
    XCTAssertEqualObjects(condition.train, dic[@"train"], @"");
    XCTAssertEqualObjects(condition.dep_stn, dic[@"dep_stn"], @"");
    XCTAssertEqualObjects(condition.arr_stn, dic[@"arr_stn"], @"");
    
    
}

@end
