//
//  KUReviewMusterController.m
//  Kuseki
//
//  Created by 吉原建 on 2016/01/24.
//  Copyright © 2016年 Takeru Yoshihara. All rights reserved.
//

#import "KUReviewMusterController.h"
#import "Flurry.h"

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
    NSMutableArray *events = [[ud arrayForKey:EVENTS_KEY]mutableCopy];
    if (events) {
        // there are some events already.
        for (NSDictionary *existingEvent in events) {
            // duplicate event key
            if ([existingEvent[@"eventKey"] isEqualToString:eventKey]) {
                return;
            }
        }
        // new event key
        [events addObject:event];
        
        [ud setObject:events forKey:EVENTS_KEY];
        [ud synchronize];
    
    }else {
        // it is the first time to add events.
        NSArray *defaultEvents = @[event];
        NSDictionary *defaults = @{EVENTS_KEY:defaultEvents};
        [ud registerDefaults:defaults];
    }
}

+ (void)fireEventWithKey:(NSString *)eventKey viewController:(UIViewController *)viewController  {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *events = [[ud arrayForKey:EVENTS_KEY]mutableCopy];
    for (NSDictionary *event in events) {
        if ([event[@"eventKey"] isEqualToString:eventKey]) {
            NSNumber *currentTimes = event[@"currentTimes"];
            NSNumber *times = event[@"times"];
            
            if (currentTimes.intValue == times.intValue) {
                // already shown alert
                return;
            }
            
            currentTimes = [NSNumber numberWithInteger:currentTimes.intValue + 1];
            NSDictionary *updatedEvent = @{ @"times":times,
                       @"currentTimes":currentTimes,
                       @"eventKey":eventKey
                       };
            [events replaceObjectAtIndex:[events indexOfObject:event] withObject:updatedEvent];
            [ud setObject:events forKey:EVENTS_KEY];
            [ud synchronize];
            
            if (currentTimes.intValue == times.intValue) {
                [self showMusterAlert:viewController];
            }
        }
    }
}

+ (void)showMusterAlert:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"reivewMusterTitle", nil) message:NSLocalizedString(@"reviewMusterBody", nil)   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"reviewMusterAccept", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self moveToReviewPage];
        [Flurry logEvent:@"didShowMusterAlert" withParameters:@{@"didMoveToReviewPage":@"YES"}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"reviewMusterDecline", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Flurry logEvent:@"didShowMusterAlert" withParameters:@{@"didMoveToReviewPage":@"NO"}];
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)moveToReviewPage {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *appId = [ud stringForKey:APP_ID_KEY];
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
