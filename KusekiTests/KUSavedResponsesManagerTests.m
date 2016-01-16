//
//  KUSavedResponsesManagerTests.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUSearchCondition.h"
#import "KUSavedResponsesManager.h"
#import "KUFactory.h"

@interface KUSavedResponsesManagerTests : XCTestCase
<KUSavedResponsesManagerDelegate>

{
    BOOL _isFinished;
}

@end

@implementation KUSavedResponsesManagerTests

- (void)setUp
{
    [super setUp];
    _isFinished = YES;
}

- (void)tearDown
{
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (!_isFinished);
    
    [super tearDown];
}


- (void)testGetResponsesWithParamOfWestLine
{
    _isFinished = NO;
    KUFactory *sharedFactory = [KUFactory sharedFactory];
    NSDictionary *sampleParam = [sharedFactory sampleParamForWestLine];
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:sampleParam];
    
    KUSavedResponsesManager *manager =[KUSavedResponsesManager sharedManager];
    [manager getResponsesWithParam:condition completion:^{
        XCTAssertTrue(manager.responses.count>0, @"単一条件からの空席情報の取得に失敗");
        _isFinished = YES;
    
    }failure:^(NSHTTPURLResponse *res, NSError *err) {
        XCTFail(@"単一条件からの空席情報の取得に失敗");
        _isFinished = YES;
    }];
    
}


- (void)testGetResponsesWithParamOfEastLine
{
    _isFinished = NO;
    
    KUFactory *factory = [KUFactory sharedFactory];
    NSDictionary *param = [factory sampleParamForEastLine];
    
    KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:param];
    
    KUSavedResponsesManager *manager = [KUSavedResponsesManager sharedManager];
    
    [manager getResponsesWithParam:condition completion:^{
        NSLog(@"空席情報の数：%lu",(unsigned long)manager.responses.count);
        XCTAssertTrue(manager.responses.count > 0, @"空席情報の取得に失敗");
        _isFinished = YES;
        
    } failure:^(NSHTTPURLResponse *res, NSError *err) {
        if (!res && !err) {
            XCTFail(@"空席情報が0です");
            
        }else{
            XCTFail(@"bodyDataを取得できませんでした");
        }
        _isFinished = YES;
    }];
}


- (void)testGetResponsesWithConditions
{
    _isFinished = NO;

    KUFactory *factory = [KUFactory sharedFactory];
    
    NSDictionary *param1 = [factory sampleParamWithIdentifier:@"1" train:@"1" dep:@"東京" arr:@"新大阪"];
    
    NSDictionary *param2 = [factory sampleParamWithIdentifier:@"2" train:@"1" dep:@"京都" arr:@"新横浜"];
    
    NSDictionary *param3 = [factory sampleParamWithIdentifier:@"3" train:@"1" dep:@"名古屋" arr:@"東京"];
    
    KUSearchCondition *condition1 = [[KUSearchCondition alloc]initWithDictionary:param1];
    
    KUSearchCondition *condition2 = [[KUSearchCondition alloc]initWithDictionary:param2];
    
    KUSearchCondition *condition3 = [[KUSearchCondition alloc]initWithDictionary:param3];
    
    NSArray *conditions = @[condition1, condition2, condition3];
    
    
    KUSavedResponsesManager *manager = [KUSavedResponsesManager sharedManager];
    manager.delegate  = self;
    
    [manager getResponsesWithConditions:conditions];
}


- (void)savedResponseManager:(id)manager DidFinishLoadingResponses:(NSArray *)responses
{
    XCTAssertTrue(responses.count > 0, @"複数の検索条件からの空席情報取得に失敗");
    NSLog(@"responses.count:%lu",(unsigned long)responses.count);
    _isFinished = YES;
}


- (void)savedResponseManagerDidFailLoading
{
    XCTFail(@"複数の検索条件からの空席情報取得に失敗");
    _isFinished = YES;
}

    


@end
