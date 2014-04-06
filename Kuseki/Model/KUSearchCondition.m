//
//  KUSearchCondition.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUSearchCondition.h"
#import "KUDBClient.h"

@implementation KUSearchCondition

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _identifier = dic[@"identifier"];
    _month = dic[@"month"];
    _day = dic[@"day"];
    _hour = dic[@"hour"];
    _minute  = dic[@"minute"];
    _train = dic[@"train"];
    _dep_stn = dic[@"dep_stn"];
    _arr_stn = dic[@"arr_stn"];
    
    return self;
    
}


- (id)init{
    
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    [self initializeCondition];
    
    return self;
}


- (void)postConditionWithCompletion:(KUSearchConditionCompetion)completion failure:(KUSearchConditionFailure)failure
{
    KUDBClient *client = [KUDBClient sharedClient];
    
    [client insertCondition:self];
    //TODO クライアントからcompletion or failureをうけとる
    if (completion) {
        completion();
    }
}

- (void)deleteCondition
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteCondition:self];
}


- (void)initializeCondition
{
    _month = @"01";
    _day = @"01";
    _hour  = @"01";
    _minute = @"01";
    _train = @"1";
    _dep_stn = @"東京";
    _arr_stn = @"新大阪";
}


#pragma  mark -
#pragma  mark validation

- (void)setMonth:(NSString *)month
{
    if (month.length == 1) {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    _month = month;
}


- (void)setDay:(NSString *)day
{
    if (day.length == 1) {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    _day = day;
}


- (void)setHour:(NSString *)hour
{
    if (hour.length == 1) {
        hour = [NSString stringWithFormat:@"0%@",hour];
    }
    _hour = hour;
}

- (void)setMinute:(NSString *)minute
{
    if (minute.length == 1) {
        minute = [NSString stringWithFormat:@"0%@",minute];
    }
    _minute = minute;
}

- (BOOL)isTooOld
{
    //テーブルにyearを加えるひつようがありそうなので保留
    return NO;
}

@end
