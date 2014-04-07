//
//  KUSearchConditionManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/30.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUSearchConditionManager.h"
#import "KUDBClient.h"


static KUSearchConditionManager *_sharedManager = nil;
@implementation KUSearchConditionManager

+ (KUSearchConditionManager*)sharedManager
{
    if (_sharedManager == nil) {
        _sharedManager = [KUSearchConditionManager new];
        _sharedManager.conditions = [NSMutableArray array];
        
    }
    
    return _sharedManager;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone*)zone{
    
    return self;
}


- (void)getConditionsFromDB
{
    KUDBClient *client = [KUDBClient sharedClient];
    _conditions = [client selectAllConditions];
    
}


- (void)deleteAllConditions
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteAllConditions];
}

- (void)deleteOldConditions
{
    [self getConditionsFromDB];
    
    for(KUSearchCondition *condition in _conditions)
    {
        if([condition isTooOld]){
            NSLog(@"古い");
            [condition deleteCondition];
        }
    }
    
    //保持する検索条件を更新
    [self getConditionsFromDB];
}


@end
