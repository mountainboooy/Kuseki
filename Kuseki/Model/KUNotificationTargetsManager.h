//
//  KUNotificationTargetsManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/04.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUNotificationTargetsManager : NSObject

@property (nonatomic,strong) NSArray *targets;
+ (KUNotificationTargetsManager*)sharedManager;

@end
