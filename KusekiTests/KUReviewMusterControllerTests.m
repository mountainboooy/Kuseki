//
//  KUReviewMusterControllerTests.m
//  Kuseki
//
//  Created by 吉原建 on 2016/01/25.
//  Copyright © 2016年 Takeru Yoshihara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KUReviewMusterController.h"

@interface KUReviewMusterControllerTests : XCTestCase

@end

@implementation KUReviewMusterControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWaitForEventWithKey {

    [self clearUserDefaults];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // new event
    [KUReviewMusterController setupWithAppId:@"sampleId"];
    [KUReviewMusterController waitForEventWithKey:@"firstEvent" withTimes:1];
    NSArray *events = [ud arrayForKey:@"KU_REVIEW_MUSTER_EVENTS"];
    XCTAssertEqual(events.count, 1);
    
    // second event
    [KUReviewMusterController waitForEventWithKey:@"secondEvent" withTimes:1];
    events = [ud arrayForKey:@"KU_REVIEW_MUSTER_EVENTS"];
    XCTAssertEqual(events.count, 2);
    
    // duplicate event
    [KUReviewMusterController waitForEventWithKey:@"firstEvent" withTimes:1];
    events = [ud arrayForKey:@"KU_REVIEW_MUSTER_EVENTS"];
    XCTAssertEqual(events.count, 2);
}

- (void)testFireEventWithKey {

    [self clearUserDefaults];
    [KUReviewMusterController waitForEventWithKey:@"firstEvent" withTimes:1];
    
    // first time
    [KUReviewMusterController fireEventWithKey:@"firstEvent" viewController:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *events = [ud arrayForKey:@"KU_REVIEW_MUSTER_EVENTS"];
    NSDictionary *event = events[0];
    NSNumber *currentTimes = event[@"currentTimes"];
    XCTAssertEqual(currentTimes.intValue, 1);
    
    // second time
    [KUReviewMusterController fireEventWithKey:@"firstEvent" viewController:nil];
    events = [ud arrayForKey:@"KU_REVIEW_MUSTER_EVENTS"];
    event = events[0];
    currentTimes = event[@"currentTimes"];
    XCTAssertEqual(currentTimes.intValue, 1);
}

- (void)clearUserDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removePersistentDomainForName:appDomain];
}


@end
