//
//  NSDate+IntegerDate.m
//  Kuseki
//
//  Created by 吉原建 on 1/23/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import "NSDate+IntegerDate.h"

@implementation NSDate (IntegerDate)

- (int)integerYear {
    return (int)[[self components] year];
}

- (int)integerMonth {
    return (int)[[self components] month];
}

- (int)integerDay {
    return (int)[[self components] day];
}

- (int)integerHour {
    return (int)[[self components] hour];
}

- (int)integerMinute {
    return (int)[[self components] minute];
}

- (int)integerSecond {
    return (int)[[self components] second];
}

+ (NSString *)stringDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [NSDateComponents new];
    components.year = year;
    components.month = month;
    components.day = day;
    NSDate *date = [[NSCalendar currentCalendar]dateFromComponents:components];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    return [dateFormatter stringFromDate:date];
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:
                               NSCalendarUnitYear |
                               NSCalendarUnitMonth |
                               NSCalendarUnitDay |
                               NSCalendarUnitHour |
                               NSCalendarUnitMinute fromDate:self];
    return comps;
}

@end
