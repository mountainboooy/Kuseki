//
//  KUReviewMusterController.h
//  Kuseki
//
//  Created by 吉原建 on 2016/01/24.
//  Copyright © 2016年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUReviewMusterController : NSObject

+ (void)setupWithAppId:(NSString *)appId;
+ (void)waitForEventWithKey:(NSString *)eventKey withTimes:(int)times;
+ (void)fireEventWithKey:(NSString *)eventEey;


