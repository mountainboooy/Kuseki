//
//  KUDBClient.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUNotificationTarget.h"
#import "KUSearchCondition.h"

enum KUTableName {KU_TABLE_NOTIFICATION_TARGETS, KU_TABLE_CONDITIONS };


@interface KUDBClient : NSObject

@property (nonatomic,strong) NSString *dbPath;

+ (KUDBClient*)sharedClient;


- (void)deleteTableWithName:(enum KUTableName)tableName;
- (void)createTableWithName:(enum KUTableName)tableName;

- (void)insertNotificationTarget:(KUNotificationTarget*)target;
- (void)insertCondition:(KUSearchCondition*)condition;

- (void)deleteNotificationTarget:(KUNotificationTarget*)target;
- (void)deleteCondition:(KUSearchCondition*)condition;

- (void)updateNotificationTarget:(KUNotificationTarget*)target;

- (NSArray*)selectAllNotificationTargets;
- (NSArray*)selectAllConditions;

- (void)deleteAllTargets;
- (void)deleteAllConditions;


@end
