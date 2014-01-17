//
//  KUSearchParamManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.


#import <Foundation/Foundation.h>

@interface KUSearchParamManager : NSObject

@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *hour;
@property (nonatomic,strong) NSString *minute;
@property (nonatomic,strong) NSString *train;
@property (nonatomic,strong) NSString *dep_stn;
@property (nonatomic,strong) NSString *arr_stn;

+ (KUSearchParamManager*)sharedManager;
- (void)initializeParamas;

@end
