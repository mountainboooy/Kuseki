//
//  KUResponse.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
enum KUSheetValue {TAKEU, KAYOKO};

@interface KUResponse : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *dep_time;
@property (nonatomic,strong) NSString *arr_time;
@property enum KUSheetValue sheet_ec_ns;
@property enum KUSheetValue sheet_ec_s;
@property enum KUSheetValue sheet_gr_ns;
@property enum KUSheetValue sheet_gr_s;

@end
