//
//  KUSearchConditionTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/30.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUSearchCondition.h"
#import "NSUserDefaults+ClearAllData.h"

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


- (void)testYearFromMonth
{
    //現在の西暦年
    NSDateComponents *comps;
    comps = [[NSCalendar currentCalendar]components:
             NSCalendarUnitYear|
             NSCalendarUnitMonth fromDate:[NSDate date]];
    NSString *current_year = [NSString stringWithFormat:@"%ld",(long)comps.year];
    
    //翌年の西暦年
    NSString *next_year = [NSString stringWithFormat:@"%ld",comps.year+1];
    NSString *dep_month;
    
    KUSearchCondition *condition = [KUSearchCondition new];
    dep_month = @"1";
    
    
    //乗車月が今の月よりも少ない数字の場合、翌年の西暦年を返せるか
    if(comps.month != 1){
    XCTAssertEqualObjects([condition yearFromMonth:dep_month], next_year, @"西暦年の算出に失敗しました");
    }else {
        XCTAssertEqualObjects([condition yearFromMonth:dep_month], current_year, @"席暦年の算出に失敗しました");
    }
    
    //乗車月が今の月よりも大きい数字の場合は、今年の西暦年を返せるか
    dep_month = @"12";
    XCTAssertEqualObjects([condition yearFromMonth:dep_month], current_year, @"西暦年の算出に失敗しました");
}


//検索条件の日時が今より古いかどうかをチェック
- (void)testIsTooOld
{
    //1年前の検索条件を作成
    NSDateComponents *dateComp;
    dateComp = [NSDateComponents new];
    [dateComp setYear:-1];
    
    NSDate *oneYearBefore;
    oneYearBefore = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
    
    NSDateComponents *comp;
    comp = [NSDateComponents new];
    comp = [[NSCalendar currentCalendar]components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitHour|
            NSCalendarUnitMinute|
            NSCalendarUnitSecond fromDate:oneYearBefore];
    
    NSDictionary *dic = @{@"identifier" : @"111",
                          @"year"   : [NSString stringWithFormat:@"%ld",(long)comp.year],
                          @"month"  : [NSString stringWithFormat:@"%ld",(long)comp.month],
                          @"day"    : [NSString stringWithFormat:@"%ld",(long)comp.day],
                          @"hour"   : [NSString stringWithFormat:@"%ld",(long)comp.hour],
                          @"minute" : [NSString stringWithFormat:@"%ld",(long)comp.minute],
                          @"train"  : @"train",
                          @"dep_stn": @"tokyo",
                          @"arr_stn": @"hakata"
                          };
    
    KUSearchCondition *condition_dayBefore = [[KUSearchCondition alloc]initWithDictionary:dic];
    XCTAssertTrue([condition_dayBefore isTooOld], @"条件日の新旧の比較に失敗しました");

}

- (void)testPreviousCondition {
    [NSUserDefaults clearAllData];
    KUSearchCondition *condition = [KUSearchCondition new];
    condition.dep_stn = @"品川";
    [condition saveAsPreviousCondition];
    
    KUSearchCondition * previousCondition = [KUSearchCondition previousCondition];
    XCTAssertEqualObjects(previousCondition.dep_stn, @"品川", @"前回の検索結果の保存に失敗");
}


- (NSString*)yearFromMonth
{
    return @"";
}
@end
