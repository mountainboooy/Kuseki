//
//  KUDifference.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUDifference.h"

@implementation KUDifference


- (id)initWithTarget:(KUNotificationTarget*)target seat:(NSString*)seat previousValue:(enum KUSheetValue)previousValue currentValue:(enum KUSheetValue)currentValue
{
    self = [super init];
    
    if (!self ) {
        return nil;
    }
    
    _trainName = target.name;
    _dep_stn = target.dep_stn;
    _arr_stn = target.arr_stn;
    _dep_time = target.dep_time;
    _arr_time = target.arr_time;
    _seat = seat;
    _previousValue = previousValue;
    _currentValue = currentValue;
    
    return self;
}

- (NSString*)stringWithCurrentValue
{
    NSString *value;
    
    switch (_currentValue) {
        case SEAT_BIT:
            value = @"△";
            break;
            
        case SEAT_FULL:
            value = @"×";
            break;
            
        case SEAT_INVALID:
            value = @"-";
            break;
            
        case SEAT_VACANT:
            value = @"○";
            break;
            
        case SEAT_NOT_EXIST_SMOKINGSEAT:
            value = @"＊";
            break;
            
        default:
            break;
    }
    
    return value;
}

- (NSString*)stringWithPreviousValue
{
    NSString *value;
    
    switch (_previousValue) {
        case SEAT_BIT:
            value = @"△";
            break;
            
            case SEAT_FULL:
            value = @"×";
            break;
            
            case SEAT_INVALID:
            value = @"-";
            break;
            
            case SEAT_VACANT:
            value = @"○";
            break;
            
            case SEAT_NOT_EXIST_SMOKINGSEAT:
            value = @"＊";
            break;
            
        default:
            break;
    }
    
    return value;
}


- (NSString*)stringWithSeatGrade
{
    NSString *str_seat;
    
    if ([_seat isEqualToString:@"seat_ec_ns"]) {
        str_seat = @"普通車(禁煙)";
    
    }else if([_seat isEqualToString:@"seat_ec_s"]){
        str_seat = @"普通車(喫煙)";
    
    }else if([_seat isEqualToString:@"seat_gr_ns"]){
        str_seat = @"グリーン車(禁煙)";
    
    }else{
        str_seat  = @"グリーン車(喫煙)";
        
    }
    
    return str_seat;
}


- (NSString*)messageForNotification
{
    /*
    NSString *message;
    NSString *month_day = [self stringWithMonth:_month andDay:_day];
    
    message = [NSString stringWithFormat:@"%@ %@ %@%@発 %@%@着 %@ %@から%@に変化",_trainName, month_day, _dep_stn, _dep_time, _arr_stn, _arr_time, [self stringWithSeatGrade], [self stringWithPreviousValue], [self stringWithCurrentValue]];
    
    return message;
     */
    return @"takeru";
}


- (NSString*)stringWithMonth:(NSString*)month_origin andDay:(NSString*)day_origin
{
    NSString *month, *day;
    if ([month_origin hasPrefix:@"0"]) {
        month = [month_origin substringFromIndex:1];
    
    }else{ month = month_origin; }
    
    
    if ([day_origin hasPrefix:@"0"]) {
        day = [day_origin substringFromIndex:1];
    
    }else{ day = day_origin; }
    
    return [NSString stringWithFormat:@"%@/%@",month, day];
}

@end
