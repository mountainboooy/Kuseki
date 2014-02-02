//
//  AppDelegate.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/13.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
@end
