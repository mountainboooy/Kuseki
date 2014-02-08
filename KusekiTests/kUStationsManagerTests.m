//
//  kUStationsManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/08.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUStationsManager.h"

@interface kUStationsManagerTests : XCTestCase

@end

@implementation kUStationsManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testStationsWithTrainId
{
    //のぞみ・さくら・みずほ・つばめ
    NSArray *stations = [KUStationsManager stationsWithTrainId:@"1"];
    XCTAssertEqualObjects(stations[stations.count-1], @"鹿児島中央", @"駅名の取得に失敗");
    
    //こだま
    stations = [KUStationsManager stationsWithTrainId:@"2"];
    XCTAssertEqualObjects(stations[stations.count-1], @"博多", @"駅名の取得に失敗");
    
    //はやぶさ・はやて・やまびこ・なすの・つばさ・こまち
    stations = [KUStationsManager stationsWithTrainId:@"3"];
    XCTAssertEqualObjects(stations[stations.count-1], @"秋田", @"駅名の取得に失敗");
    
    //とき・たにがわ・あさま
    stations = [KUStationsManager stationsWithTrainId:@"4"];
    XCTAssertEqualObjects(stations[stations.count-1], @"長野", @"駅名の取得に失敗");
    
    //在来線
    
}



@end
