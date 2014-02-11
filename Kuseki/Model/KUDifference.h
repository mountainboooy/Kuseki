//
//  KUDifference.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/11.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUResponse.h"

@interface KUDifference : NSObject

@property (nonatomic,strong) NSString *seat;
@property  enum KUSheetValue previousValue;
@property  enum KUSheetValue currentValue;

- (id)initWithSeat:(NSString*)seat previousValue:(enum KUSheetValue)previousValue currentValue:(enum KUSheetValue)currentValue;

@end
