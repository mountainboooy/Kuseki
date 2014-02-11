//
//  KUNotificationTarget.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/04.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUNotificationTarget.h"
#import "KUDBClient.h"
#import "KUResponse.h"

@implementation KUNotificationTarget


- (id)initWithResponse:(KUResponse*)response
{
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    _name= response.name;
    _dep_time = response.dep_time;
    _arr_time = response.arr_time;
    _seat_ec_ns = response.seat_ec_ns;
    _seat_ec_s  = response.seat_ec_s;
    _seat_gr_ns = response.seat_gr_ns;
    _seat_gr_s = response.seat_gr_s;
    
    return self;
    
}


- (enum KUSheetValue)seatValueForString:(NSString*)str
{
    NSLog(@"str:%@",str);
    if ([str isEqualToString:@"○"]) {
        return SEAT_VACANT;
    }
    
    if ([str isEqualToString:@"△"]) {
        return SEAT_BIT;
    }
    
    if ([str isEqualToString:@"＊"]) {
        return SEAT_NOT_EXIST_SMOKINGSEAT;
    }
    
    if ([str isEqualToString:@"×"]) {
        return SEAT_FULL;
    }
    
    else{
        return SEAT_INVALID;
    }
}


+ (void)saveWithResponse:(KUResponse*)response condition:(KUSearchCondition*)condition
{
    if (!condition || !response) {
        return;
    }
    
    KUNotificationTarget *new_target;
    new_target = [[KUNotificationTarget alloc]initWithResponse:response];
    new_target.condition_id = condition.identifier;
    
    KUDBClient *client = [KUDBClient sharedClient];
    [client insertNotificationTarget:new_target];
    
}


+ (void)removeWithResonse:(KUResponse*)response condition:(KUSearchCondition*)condition;
{
    KUDBClient *client = [KUDBClient sharedClient];
    
    NSArray *savedTargets = [client selectAllNotificationTargets];
    for (KUNotificationTarget *savedTarget in savedTargets) {
        if ([response.name isEqualToString:savedTarget.name] && [condition.identifier isEqualToString:savedTarget.condition_id]) {
            [client deleteNotificationTarget:savedTarget];
        }
    }
}


+ (void)update
{
    //あとで
}


//通知ターゲット(自身）と取得したresponseが同じものかチェックするメソッド
- (BOOL)isSameTrainWithResponse:(KUResponse *)response
{
    NSLog(@"res_name:%@",response.name);
    NSLog(@"res_dep:%@",response.dep_time);
    NSLog(@"res_arr:%@",response.arr_time);
    
    if ([response.name isEqualToString:_name] &&
         [response.dep_time isEqualToString:_dep_time] &&
        [response.arr_time isEqualToString:_arr_time]) {
        return YES;
    }
    
    return NO;
}



@end
