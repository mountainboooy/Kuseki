//
//  KUResponseManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUResponseManager.h"
#import "KUResponse.h"

static KUResponseManager *_sharedManager = nil;
@implementation KUResponseManager


+ (KUResponseManager*)sharedManager
{
    if(_sharedManager == nil){
        _sharedManager = [KUResponseManager new];
        _sharedManager.responses = [NSMutableArray new];
        
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


- (void)addResponse:(KUResponse*)response
{
    if(!response){
        return;
    }
    
    [_responses addObject:response];

}







@end
