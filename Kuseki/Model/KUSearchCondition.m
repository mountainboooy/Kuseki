//
//  KUSearchCondition.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUSearchCondition.h"
#import "KUDBClient.h"
static NSString *const PREVIOUS_CONDITION = @"PREIOUSD_CONDITION";

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
    _year = dic[@"year"];
    
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

- (void)saveAsPreviousCondition {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *condition = @{
                                @"identifier":self.identifier,
                                @"month":self.month,
                                @"day":self.day,
                                @"hour":self.hour,
                                @"minute":self.minute,
                                @"train":self.train,
                                @"dep_stn":self.dep_stn,
                                @"arr_stn":self.arr_stn,
                                @"year":self.year
                                };
    [ud setObject:condition forKey:PREVIOUS_CONDITION];
    [ud synchronize];
}

+ (KUSearchCondition *)previousCondition {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *previousCondition = [ud dictionaryForKey:PREVIOUS_CONDITION];
    if (!previousCondition) {
        return [KUSearchCondition new];
    }
    return [[KUSearchCondition alloc]initWithDictionary:previousCondition];
}

- (void)deleteCondition
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteCondition:self];
}


- (void)initializeCondition
{
    _identifier = @"identifier";
    _month = @"01";
    _day = @"01";
    _hour  = @"01";
    _minute = @"01";
    _train = @"1";
    _dep_stn = @"東京";
    _arr_stn = @"新大阪";
    _year = @"0";
}


#pragma  mark -
#pragma  mark validation

- (void)setMonth:(NSString *)month
{
    if (month.length == 1) {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    _month = month;
    
    //乗車月に合わせてyearも更新
    _year = [self yearFromMonth:month];
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
    //検索条件のNSDate
    NSDateComponents *comps = [NSDateComponents new];
    comps.year = _year.intValue;
    comps.month = _month.intValue;
    comps.day = _day.intValue;
    comps.hour = _hour.intValue;
    comps.minute = _minute.intValue;
    NSDate *date = [[NSCalendar currentCalendar]dateFromComponents:comps];
    
    //現在と比較
    NSComparisonResult result = [date compare:[NSDate date]];
    
    if(result == NSOrderedAscending){//現在より以前
        return YES;
    }
    
    return NO;
}


- (NSString*)yearFromMonth:(NSString*)dep_month
{
    //現在の月より乗車付きの方が小さい場合は翌年と判断する
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:
                               NSCalendarUnitYear|
                               NSCalendarUnitMonth fromDate:[NSDate date]];
    
    if(dep_month.intValue - comps.month < 0){//翌年と判断
        return [NSString stringWithFormat:@"%ld",comps.year+1];
    
    }else{
        return [NSString stringWithFormat:@"%ld",(long)comps.year];
    }
}

@end
