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

@end

@implementation KUClientTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testStringPramFromDictionary
{
    NSDictionary *dic_param = @{@"firstname":@"takeru",
                                @"lastname":@"yoshihara",
                                @"age":@"33",
                                @"city":@"osaka"};
    
    KUClient *client = [KUClient new];
    NSString *str_param = [client stringParamFromDictionary:dic_param];
    NSString *str_correct = @"age=33&lastname=yoshihara&city=osaka&firstname=takeru&";
    XCTAssertEqualObjects(str_param, str_correct, @"パラメータの作成に失敗");
    
}

@end
