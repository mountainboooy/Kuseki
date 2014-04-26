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
        NSLog(@"ありません");
        return;
    }
    
    if (![target isSameTrainWithResponse:response]) {
        NSLog(@"一緒じゃない");
        return;
    }
    
    //普通席禁煙
    if (response.seat_ec_ns  != target.seat_ec_ns) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_ns" previousValue:target.seat_ec_ns currentValue:response.seat_ec_ns];
        
        [self addDifference:new_diff];
        
        //targetの更新
        target.seat_ec_ns = response.seat_ec_ns;
        
    }
    
    //普通席喫煙
    if (response.seat_ec_s  != target.seat_ec_s) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_ec_s" previousValue:target.seat_ec_s currentValue:response.seat_ec_s];
        
        [self addDifference:new_diff];
        
        //targetの更新
        target.seat_ec_s = response.seat_ec_s;
    }
    
    //グリーン車禁煙
    if (response.seat_gr_ns  != target.seat_gr_ns) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_gr_ns" previousValue:target.seat_gr_ns currentValue:response.seat_gr_ns];
        
        [self addDifference:new_diff];
        
        //targetの更新
        target.seat_gr_ns = response.seat_gr_ns;
    }
    
    //グリーン車喫煙
    if (response.seat_gr_s!= target.seat_gr_s) {
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_gr_s" previousValue:target.seat_gr_s currentValue:response.seat_gr_s];
        
        [self addDifference:new_diff];
        
        //targetの更新
        target.seat_gr_s = response.seat_gr_s;
    }
    
    //グランシート禁煙
    NSLog(@"response.^^%d",response.seat_gs_ns);
    NSLog(@"target.[[%d",target.seat_gs_ns);
    if(response.seat_gs_ns != target.seat_gs_ns){
        //KUDifferenceを生成して追加
        KUDifference *new_diff;
        new_diff = [[KUDifference alloc]initWithTarget:target seat:@"seat_gs_ns" previousValue:target.seat_gs_ns currentValue:response.seat_gs_ns];
        
        [self addDifference:new_diff];
        
        //targetの更新
        target.seat_gs_ns = response.seat_gs_ns;
    }
    
    [target updateTarget];
}


- (void)addDifference:(KUDifference*)difference
{
    if (!difference) {
        return;
    }
    
    [_differences addObject:difference];
}


- (void)clearDifferences
{
    [_differences removeAllObjects];
}

@end
