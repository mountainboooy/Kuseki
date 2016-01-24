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
    NSDictionary *stations = [KUStationsManager stationsWithTrainId:@"1"];
    XCTAssertEqualObjects(stations[@"ja"][[stations[@"ja"] count] - 1], @"鹿児島中央", @"駅名の取得に失敗");
    XCTAssertEqualObjects(stations[@"en"][[stations[@"en"] count] - 1], @"Kagoshima-Chuo", @"駅名の取得に失敗");
    
    //こだま
    stations = [KUStationsManager stationsWithTrainId:@"2"];
    XCTAssertEqualObjects(stations[@"ja"][[stations[@"ja"] count] - 1], @"博多", @"駅名の取得に失敗");
    XCTAssertEqualObjects(stations[@"en"][[stations[@"en"] count] - 1], @"Hakata", @"駅名の取得に失敗");
    
    //はやぶさ・はやて・やまびこ・なすの・つばさ・こまち
    stations = [KUStationsManager stationsWithTrainId:@"3"];
    XCTAssertEqualObjects(stations[@"ja"][[stations[@"ja"]count] - 1], @"秋田", @"駅名の取得に失敗");
    XCTAssertEqualObjects(stations[@"en"][[stations[@"en"] count] - 1], @"Akita", @"駅名の取得に失敗");
    
    //とき・たにがわ・あさま
    stations = [KUStationsManager stationsWithTrainId:@"4"];
    XCTAssertEqualObjects(stations[@"ja"][[stations[@"ja"] count] - 1], @"長野", @"駅名の取得に失敗");
    XCTAssertEqualObjects(stations[@"en"][[stations[@"en"] count] - 1], @"Nagano", @"駅名の取得に失敗");
    
    //TODO在来線
    
}

- (void)testLocalizedStation {
    
    NSString *preferredlanguage = [NSLocale preferredLanguages][0];
    NSRange range = [preferredlanguage rangeOfString:@"ja"];
    if (range.location != NSNotFound) {
        XCTFail(@"英訳のテストを実行するために、シミュレータの言語を英語に設定してください");
        return;
    }
    
    //のぞみ・さくら・みずほ・つばめ
    NSString *englishName = [KUStationsManager localizedStation:@"鹿児島中央"];
    XCTAssertEqualObjects(englishName, @"Kagoshima-Chuo", @"駅名の英訳に失敗");
    
    //こだま
    englishName = [KUStationsManager localizedStation:@"博多"];
    XCTAssertEqualObjects(englishName, @"Hakata", @"駅名の英訳に失敗");
    
    //はやぶさ・はやて・やまびこ・なすの・つばさ・こまち
    englishName = [KUStationsManager localizedStation:@"秋田"];
    XCTAssertEqualObjects(englishName, @"Akita", @"駅名の英訳に失敗");
    
    //とき・たにがわ・あさま
    englishName = [KUStationsManager localizedStation:@"長野"];
    XCTAssertEqualObjects(englishName, @"Nagano", @"駅名の英訳に失敗");
}



@end
