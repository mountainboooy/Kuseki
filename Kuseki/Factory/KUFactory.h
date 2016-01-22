//
//  KUFactory.h
//  Kuseki
//
//  Created by 吉原建 on 1/14/16.
//  Copyright © 2016 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUSearchCondition.h"

@interface KUFactory : NSObject

+ (KUFactory *)sharedFactory;
- (NSDateComponents *)sampleDateComponents;
- (NSDictionary *)sampleParamForWestLine;
- (NSDictionary *)sampleParamForEastLine;
- (NSDictionary*)sampleParamWithIdentifier:(NSString *)identifier train:(NSString *)train dep:(NSString *)dep arr:(NSString *)arr;

@end
