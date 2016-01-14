//
//  KUClientTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/18.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>   
#import "KUClient.h"

@interface KUClientTests : XCTestCase
{
    BOOL _isFinished;
}
@end

@implementation KUClientTests

- (void)setUp
{
    
    [super setUp];
    _isFinished  = YES;
}

- (void)tearDown
{
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (!_isFinished);
    
    [super tearDown];
}


- (void)testStringPramFromDictionary
{
    NSDictionary *dic_param = @{@"firstname":@"takeru",
                                @"lastname":@"yoshihara",
                                @"age":@"33"};
    
    KUClient *client = [KUClient new];
    NSString *str_param = [client stringParamFromDictionary:dic_param];
    
    NSRange range_firstname = [str_param rangeOfString:@"firstname=takeru&"];
    XCTAssertNotEqual(range_firstname.location, NSNotFound);
    
    NSRange range_lastname = [str_param rangeOfString:@"lastname=yoshihara&"];
    XCTAssertNotEqual(range_lastname.location, NSNotFound);
        
    NSRange range_age = [str_param rangeOfString:@"age=33&"];
    XCTAssertNotEqual(range_age.location, NSNotFound);
}


- (void)testPost
{
    _isFinished = NO;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10.0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                fromDate:date];
    
    NSDictionary *dic_param = @{
                                @"month":[NSString stringWithFormat:@"%ld", (long)comps.month],
                                @"day":[NSString stringWithFormat:@"%ld",(long)comps.day],
                                @"hour":[NSString stringWithFormat:@"%ld", (long)comps.hour],
                                @"minute":[NSString stringWithFormat:@"%ld", (long)comps.minute],
                                @"train":@"1",
                                @"dep_stn":@"東京",
                                @"arr_stn":@"新大阪"
                                };
    
    NSURL *base_url = [NSURL URLWithString:@"http://www1.jr.cyberstation.ne.jp/"];
    NSString *path = @"csws/Vacancy.do";
    
    KUClient *client = [[KUClient alloc]initWithBaseUrl:base_url];
    
    [client postPath:path param:dic_param completion:^(NSString *dataString) {
        _isFinished = YES;
        
    
    } failure:^(NSHTTPURLResponse *res, NSError *error) {
        XCTAssertEqual(res.statusCode, 200u, @"HTMLの取得に失敗");
        NSLog(@"error:%@",error.localizedDescription);
        _isFinished = YES;
        
    }];
}


@end
