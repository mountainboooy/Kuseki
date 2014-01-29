//
//  KUResponse.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
enum KUSheetValue {SEAT_VACANT, SEAT_BIT, SEAT_FULL, SEAT_INVALID, SEAT_NOT_EXIST_SMOKINGSEAT };

@interface KUResponse : NSObject

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *dep_time;
@property (nonatomic,strong) NSString *arr_time;
@property enum KUSheetValue seat_ec_ns;
@property enum KUSheetValue seat_ec_s;
@property enum KUSheetValue seat_gr_ns;
@property enum KUSheetValue seat_gr_s;

- (id)initWithDictionary:(NSDictionary*)dic;

@end
