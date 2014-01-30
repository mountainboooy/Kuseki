//
//  KUDBClient.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUResponse.h"
#import "KUSearchCondition.h"

enum KUTableName {KU_TABLE_RESPONSES, KU_TABLE_CONDITIONS };


@interface KUDBClient : NSObject

@property (nonatomic,strong) NSString *dbPath;

+ (KUDBClient*)sharedClient;


- (void)deleteTableWithName:(enum KUTableName)tableName;
- (void)createTableWithName:(enum KUTableName)tableName;
- (void)insertResponse:(KUResponse*)response;
- (void)insertCondition:(KUSearchCondition*)condition;
- (void)deleteResponse:(KUResponse*)response;
- (void)deleteCondition:(KUSearchCondition*)condition;
- (void)updateResponse:(KUResponse*)response;
- (NSArray*)selectAllResponses;
- (NSArray*)selectAllConditions;

@end
