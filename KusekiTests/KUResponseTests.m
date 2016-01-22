//
//  KUResponseTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/15.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUResponse.h"

@interface KUResponseTests : XCTestCase

@end

@implementation KUResponseTests

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

- (void)testLocalizedName {
    KUResponse *response = [[KUResponse alloc]initWithDictionary:@{@"name":@"のぞみ195号"}];
    XCTAssertEqualObjects(response.localizedName, @"NOZOMI195", @"列車名のローカライズに失敗");
}



@end
