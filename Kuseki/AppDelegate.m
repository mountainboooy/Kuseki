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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /*
    NSLog(@"takeru");
    
    KUSearchConditionManager *conditionManager = [KUSearchConditionManager sharedManager];
    [conditionManager getConditionsFromDB];
    
    if (conditionManager.conditions.count == 0) {
        return;
    }
    
    KUResponseManager *responseManager = [KUResponseManager sharedManager];
    */
    
    
    
    //通知用のリストを探す
    //リストに当てはまるurlから結果を取得
    //ステータスが変わったものがあれば通知
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [al show];
    
}
@end
