//
//  KUSearchConditionManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/30.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUSearchConditionManager : NSObject

@property (nonatomic,strong) NSArray *conditions;
+ (KUSearchConditionManager*)sharedManager;
- (void)getConditionsFromDB;
- (void)deleteOldConditions;
- (void)deleteAllConditions;
- (void)deleteAllConditions;
@end
