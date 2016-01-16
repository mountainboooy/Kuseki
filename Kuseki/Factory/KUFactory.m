//
//  KUFactory.m
//  Kuseki
//
//  Created by 吉原建 on 1/14/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import "KUFactory.h"
static KUFactory *_sharedFactory = nil;

@implementation KUFactory

+ (KUFactory *)sharedFactory{
    if (_sharedFactory == nil){
        _sharedFactory= [KUFactory new];
        
    }
    return _sharedFactory;
}

+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_sharedFactory == nil) {
            _sharedFactory = [super allocWithZone:zone];
            return _sharedFactory;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

// sapmle date after 10 seconds from now
- (NSDateComponents *)sampleDateComponents {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    [comps setDay:(comps.day + 1)];
    [comps setHour:15];
    [comps setMinute:0];
    [comps setSecond:0];
    
    return comps;
}

- (NSDictionary *)sampleParamForEastLine {
    NSDateComponents *comps = [self sampleDateComponents];
    
    NSDictionary *param = @{
                            @"year":[NSString stringWithFormat:@"%ld", (long)comps.year],
                            @"month":[NSString stringWithFormat:@"%ld", (long)comps.month],
                            @"day":[NSString stringWithFormat:@"%ld",(long)comps.day],
                            @"hour":[NSString stringWithFormat:@"%ld", (long)comps.hour],
                            @"minute":[NSString stringWithFormat:@"%ld", (long)comps.minute],
                            @"train":@"3",
                            @"dep_stn":@"東京",
                            @"arr_stn":@"上野"
                            };
    return param;
}

- (NSDictionary *)sampleParamForWestLine {
    NSDateComponents *comps = [self sampleDateComponents];
    
    NSDictionary *param = @{
                                @"year":[NSString stringWithFormat:@"%ld", (long)comps.year],
                                @"month":[NSString stringWithFormat:@"%ld", (long)comps.month],
                                @"day":[NSString stringWithFormat:@"%ld",(long)comps.day],
                                @"hour":[NSString stringWithFormat:@"%ld", (long)comps.hour],
                                @"minute":[NSString stringWithFormat:@"%ld", (long)comps.minute],
                                @"train":@"1",
                                @"dep_stn":@"東京",
                                @"arr_stn":@"新大阪"
                                };
    return param;
}

- (NSDictionary*)sampleParamWithIdentifier:(NSString *)identifier train:(NSString *)train dep:(NSString *)dep arr:(NSString *)arr{
    NSDateComponents *comps = [self sampleDateComponents];
    
    NSDictionary *param = @{
                            @"year":[NSString stringWithFormat:@"%ld", (long)comps.year],
                            @"month":[NSString stringWithFormat:@"%ld", (long)comps.month],
                            @"day":[NSString stringWithFormat:@"%ld",(long)comps.day],
                            @"hour":[NSString stringWithFormat:@"%ld", (long)comps.hour],
                            @"minute":[NSString stringWithFormat:@"%ld", (long)comps.minute],
                            @"train":train,
                            @"dep_stn":dep,
                            @"arr_stn":arr
                            };
    
    return  param;
}

@end
