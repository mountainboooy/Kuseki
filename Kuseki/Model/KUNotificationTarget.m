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


- (id)initWithResponse:(KUResponse*)response dep_stn:(NSString*)dep_stn arr_stn:(NSString*)arr_stn
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
    _seat_gs_ns = response.seat_gs_ns;
    _dep_stn  = dep_stn;
    _arr_stn = arr_stn;
    _month = response.month;
    _day = response.day;
    
    
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
    new_target = [[KUNotificationTarget alloc]initWithResponse:response dep_stn:condition.dep_stn arr_stn:condition.arr_stn];
    new_target.condition_id = condition.identifier;
    
    KUDBClient *client = [KUDBClient sharedClient];
    [client insertNotificationTarget:new_target];
    
}


//検索条件が該当する通知設定を全て削除
+ (void)removeWithCondition:(KUSearchCondition*)condition
{
    if (!condition) {
        return;
    }
    
    KUDBClient *client = [KUDBClient sharedClient];
    NSArray *savedTargets = [client selectAllNotificationTargets];
    
    for (KUNotificationTarget *savedTarget in savedTargets) {
        if ([savedTarget.condition_id isEqualToString:condition.identifier]) {
            [client deleteNotificationTarget:savedTarget];
        }
    }
}


//特定の通知設定を削除
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



//通知ターゲット(自身）と取得したresponseが同じものかチェックするメソッド
- (BOOL)isSameTrainWithResponse:(KUResponse *)response
{
    if ([response.name isEqualToString:_name] &&
         [response.dep_time isEqualToString:_dep_time] &&
        [response.arr_time isEqualToString:_arr_time] &&
        [response.month isEqualToString:_month] &&
        [response.day isEqualToString:_day]) {
        return YES;
    }
    
    return NO;
}


- (void)updateTarget
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client updateNotificationTarget:self];
}



@end
