//
//  KUDifference.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUDifference.h"

@implementation KUDifference

- (id)initWithSeat:(NSString *)seat previousValue:(enum KUSheetValue)previousValue currentValue:(enum KUSheetValue)currentValue
{
    self = [super init];
    
    if (!self ) {
        return nil;
    }
    
    _seat = seat;
    _previousValue = previousValue;
    _currentValue = currentValue;
    
    return self;
    
}

@end
