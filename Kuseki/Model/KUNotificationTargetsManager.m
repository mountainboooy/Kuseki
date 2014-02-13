//
//  KUNotificationTargetsManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/04.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUNotificationTargetsManager.h"
#import "KUDBClient.h"
#import "KUResponseManager.h"

static KUNotificationTargetsManager *_sharedManager = nil;


@implementation KUNotificationTargetsManager


+ (KUNotificationTargetsManager*)sharedManager
{
    if(_sharedManager == nil){
        _sharedManager = [KUNotificationTargetsManager new];
        _sharedManager.targets = [NSArray new];
        [_sharedManager selectAllTargets];
        
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


- (void)selectAllTargets
{
    KUDBClient *client = [KUDBClient sharedClient];
    _targets = [client selectAllNotificationTargets];
    
}


- (void)removeAllTargets
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteAllTargets];
    
    [self selectAllTargets];
}

@end
