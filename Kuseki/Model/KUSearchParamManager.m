//
//  KUSearchParamManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUSearchParamManager.h"
static KUSearchParamManager *_sharedManager = nil;

@implementation KUSearchParamManager

+ (KUSearchParamManager*)sharedManager
{
    if (_sharedManager == nil){
        _sharedManager = [KUSearchParamManager new];
        [_sharedManager initializeParamas];
        
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


- (void)initializeParamas
{
    _month = @"01";
    _date = @"01";
    _hour  = @"01";
    _minute = @"01";
    _train = @"1";
    _dep_stn = @"東京";
    _arr_stn = @"新大阪";
}

@end
