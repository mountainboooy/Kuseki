//
//  KUDifferencesManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUResponse.h"
#import "KUNotificationTarget.h"

@interface KUDifferencesManager : NSObject

@property (nonatomic,strong) NSMutableArray *differences;

+ (KUDifferencesManager*)sharedManager;

//ふたつを比べて、空席情報の差異をKUDifferenceとして配列に追加
- (void)compareResponse:(KUResponse*)response withTarget:(KUNotificationTarget*)target;

@end
