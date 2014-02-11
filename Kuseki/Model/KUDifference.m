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

@end
