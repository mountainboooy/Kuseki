//
//  KUDifference.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUResponse.h"
#import "KUNotificationTarget.h"

@interface KUDifference : NSObject

@property (nonatomic,strong) NSString *trainName;
@property (nonatomic,strong) NSString *dep_stn;
@property (nonatomic,strong) NSString *arr_stn;
@property (nonatomic,strong) NSString *dep_time;
@property (nonatomic,strong) NSString *arr_time;

@property (nonatomic,strong) NSString *seat;
@property  enum KUSheetValue previousValue;
@property  enum KUSheetValue currentValue;

- (id)initWithTarget:(KUNotificationTarget*)target seat:(NSString*)seat previousValue:(enum KUSheetValue)previousValue currentValue:(enum KUSheetValue)currentValue;

- (NSString*)stringWithPreviousValue;
- (NSString*)stringWithCurrentValue;
- (NSString*)messageForNotification;
- (NSString*)stringWithSeatGrade;
- (NSString*)stringWithMonth:(NSString*)month andDay:(NSString*)day;

@end
