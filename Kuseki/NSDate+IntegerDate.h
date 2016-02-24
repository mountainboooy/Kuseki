//
//  NSDate+IntegerDate.h
//  Kuseki
//
//  Created by 吉原建 on 1/23/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IntegerDate)

- (int)integerYear;

- (int)integerMonth;

- (int)integerDay;

- (int)integerHour;

- (int)integerMinute;

- (int)integerSecond;

+ (NSString *)stringDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
