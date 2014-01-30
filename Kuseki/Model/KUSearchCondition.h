//
//  KUSearchCondition.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUSearchParamManager.h"

@interface KUSearchCondition : NSObject

@property (nonatomic,strong) NSString *identifier;
@property (nonatomic,strong) NSString *month;
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *hour;
@property (nonatomic,strong) NSString *minute;
@property (nonatomic,strong) NSString *train;
@property (nonatomic,strong) NSString *dep_stn;
@property (nonatomic,strong) NSString *arr_stn;


- (id)initWithDictionary:(NSDictionary*)dic;
- (void)postCondition;
- (void)deleteCondition;

@end
