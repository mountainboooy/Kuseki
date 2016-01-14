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

+ (KUFactory*)sharedFactory{
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

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

- (NSDictionary*)sampleParam {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10.0];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                fromDate:date];
    
    NSDictionary *dic_param = @{
                                @"month":[NSString stringWithFormat:@"%ld", (long)comps.month],
                                @"day":[NSString stringWithFormat:@"%ld",(long)comps.day],
                                @"hour":[NSString stringWithFormat:@"%ld", (long)comps.hour],
                                @"minute":[NSString stringWithFormat:@"%ld", (long)comps.minute],
                                @"train":@"1",
                                @"dep_stn":@"東京",
                                @"arr_stn":@"新大阪"
                                };
    return dic_param;
}

@end
