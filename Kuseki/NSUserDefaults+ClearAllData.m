//
//  NSUserDefaults+ClearAllData.m
//  Kuseki
//
//  Created by 吉原建 on 2016/01/27.
//  Copyright © 2016年 Takeru Yoshihara. All rights reserved.
//

#import "NSUserDefaults+ClearAllData.h"

@implementation NSUserDefaults (ClearAllData)

+ (void)clearAllData {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *ud = [self standardUserDefaults];
    [ud removePersistentDomainForName:appDomain];
}

@end
