//
//  KUNotificationTarget.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/04.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUResponse.h"
#import "KUSearchCondition.h"


@interface KUNotificationTarget : NSObject

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *dep_time;
@property (nonatomic,strong) NSString *arr_time;
@property enum KUSheetValue seat_ec_ns;
@property enum KUSheetValue seat_ec_s;
@property enum KUSheetValue seat_gr_ns;
@property enum KUSheetValue seat_gr_s;
@property enum KUSheetValue seat_gs_ns;
@property (nonatomic,strong) NSString *condition_id;
@property (nonatomic,strong) NSString *dep_stn;
@property (nonatomic,strong) NSString *arr_stn;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;

+ (void)saveWithResponse:(KUResponse*)response condition:(KUSearchCondition*)condition;

+ (void)removeWithResonse:(KUResponse*)response condition:(KUSearchCondition*)condition;

+ (void)removeWithCondition:(KUSearchCondition*)condition;

- (void)updateTarget;

- (BOOL)isSameTrainWithResponse:(KUResponse*)response;
- (id)initWithResponse:(KUResponse*)response dep_stn:(NSString*)dep_stn arr_stn:(NSString*)arr_stn;
- (void)removeWithCondition:(KUSearchCondition*)condition;


@end
