//
//  KUDifferencesManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUDifferencesManager.h"
#import "KUDifference.h"

static KUDifferencesManager *_sharedManager = nil;
@implementation KUDifferencesManager

+ (KUDifferencesManager*)sharedManager
{
    if (_sharedManager == nil) {
        _sharedManager = [KUDifferencesManager new];
        _sharedManager.differences = [NSMutableArray new];
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



- (void)compareResponse:(KUResponse*)response withTarget:(KUNotificationTarget*)target
{
    if (!response || !target) {
        return;
    }
    
    if (![target isSameTrainWithResponse:response]) {
        return;
    }
    
    //普通席禁煙
    if (response.seat_ec_ns  == target.seat_ec_ns) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_ns" previousValue:target.seat_ec_ns currentValue:response.seat_ec_ns];
        
        [self addDifference:new_diff];
        
    }
    
    //普通席喫煙
    if (response.seat_ec_s  != target.seat_ec_s) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_s" previousValue:target.seat_ec_s currentValue:response.seat_ec_s];
        
        [self addDifference:new_diff];
    }
    
    //グリーン車禁煙
    if (response.seat_gr_ns  != target.seat_gr_ns) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_gr_ns" previousValue:target.seat_gr_ns currentValue:response.seat_gr_ns];
        
        [self addDifference:new_diff];
    }
    
    //グリーン車喫煙
    if (response.seat_gr_s!= target.seat_gr_s) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_gr_s" previousValue:target.seat_gr_s currentValue:response.seat_gr_s];
        
        [self addDifference:new_diff];
    }
    
}


- (void)addDifference:(KUDifference*)difference
{
    if (!difference) {
        return;
    }
    
    [_differences addObject:difference];
}

@end
