//
//  KUReviewMusterController.m
//  Kuseki
//
//  Created by 吉原建 on 2016/01/24.
//  Copyright © 2016年 Takeru Yoshihara. All rights reserved.
//

#import "KUReviewMusterController.h"

@interface KUReviewMusterController()
@end

static NSString *const EVENTS_KEY = @"KU_REVIEW_MUSTER_EVENTS";
static NSString *const APP_ID_KEY = @"KU_REVIEW_MUSTER_APP_ID";
@implementation KUReviewMusterController

+ (void)setupWithAppId:(NSString *)appId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaults = @{@"KU_REVIEW_MUSTER_APP_ID":appId};;
    [ud registerDefaults:defaults];
}

+ (void)waitForEventWithKey:(NSString *)eventKey withTimes:(int)times {
    
    NSDictionary *event = @{
                            @"eventKey":eventKey,
                            @"times":[NSNumber numberWithInteger:times],
                            @"currentTimes":[NSNumber numberWithInt:0]
                            };
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *events = (NSMutableArray *)[ud arrayForKey:EVENTS_KEY];
    if (events) {
        // there are some events already.
        for (NSDictionary *existingEvent in events) {
            if ([existingEvent[@"eventKey"] isEqualToString:eventKey]) {
                return;
            }
        }
        [events addObject:event];
        [ud setObject:events forKey:EVENTS_KEY];
        [ud synchronize];
    
    }else {
        // it is the first time to add events.
        NSArray *defaultEvents = @[event];
        NSDictionary *defaults = @{APP_ID_KEY:defaultEvents};
        [ud registerDefaults:defaults];
    }
}

@end
