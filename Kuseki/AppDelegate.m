//
//  AppDelegate.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/13.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "AppDelegate.h"
#import "KUSearchConditionManager.h"
#import "KUResponseManager.h"
#import "KUNotificationTargetsManager.h"
#import "KUNotificationTarget.h"
#import "KUSavedResponsesManager.h"
#import "KUDifferencesManager.h"
#import "KUDifference.h"
#import "Flurry.h"
#import "KUReviewMusterController.h"
#import "NSUserDefaults+ClearAllData.h"
@import GoogleMobileAds;

@interface AppDelegate () <KUSavedResponsesManagerDelegate, UIAlertViewDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", NSLocalizedString(@"testLocalization", nil));
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    // Flurry
    //[Flurry setCrashReportingEnabled:YES];
    //[Flurry startSession:@"922D54Y2HGKPS8DBTVZT"];
    
    //ReviewMusterController
    [self setUpReviewMusterController];
    
    // Initialize Google Mobile Ads SDK
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-1424580573410744~7400800536"];

    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"perfom fetch");

    // 23::00~06:00の間はアクションしない
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitHour fromDate:date];

    if (comps.hour < 06 || comps.hour > 22) {
        return;
    }

    //保存中の検索条件一覧をDBから取得
    KUSearchConditionManager *conditionManager = [KUSearchConditionManager sharedManager];

    [conditionManager deleteOldConditions];  //古い検索条件は捨てる
    [conditionManager getConditionsFromDB];

    //保存中の検索条件から新たに空席情報を取得
    KUSavedResponsesManager *savedResponseManager;
    savedResponseManager = [KUSavedResponsesManager sharedManager];
    savedResponseManager.delegate = self;
    [savedResponseManager getResponsesWithConditions:conditionManager.conditions];

    //後はdelegateメソッド上で処理

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"空席情報が変化しました");
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"空席状況が変化しました"
                                                 message:notification.alertBody
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];

    [al show];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(KUAlertCompetion)completion
{

    UIAlertView *al = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

    [al show];
}

- (void)addNotification:(NSString *)body afterSeconds:(NSTimeInterval)seconds withSound:(NSString *)soundName
{

    // 通知オブジェクトを生成してパラメータ設定
    UILocalNotification *notification = [UILocalNotification new];

    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    notification.alertBody = body;
    notification.soundName = soundName;

    // アプリケーションに渡す
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)savedResponseManagerDidFailLoading
{
}

- (void)savedResponseManager:(id)manager DidFinishLoadingResponses:(NSArray *)responses
{
    //通知対象の空席情報と、最新の空席情報で差異がある場合には再情報をKUDifferenceとして格納
    KUDifferencesManager *diffManager = [KUDifferencesManager sharedManager];
    KUNotificationTargetsManager *targetsManager = [KUNotificationTargetsManager sharedManager];

    for (KUResponse *new_response in responses) {
        for (KUNotificationTarget *target in targetsManager.targets) {
            [diffManager compareResponse:new_response withTarget:target];
        }
    }

    //それぞれの差異情報をlocal通知でお知らせ
    for (KUDifference *diff in diffManager.differences) {

        NSString *message = [diff messageForNotification];
        [self addNotification:message afterSeconds:1 withSound:@"default"];
    }

    //差異情報はクリアする
    [diffManager clearDifferences];
}

- (void)setUpReviewMusterController {
    [KUReviewMusterController setupWithAppId:@"869851973"];
    [KUReviewMusterController waitForEventWithKey:@"DID_BECOME_ACTIVE" withTimes:4];
}

@end
