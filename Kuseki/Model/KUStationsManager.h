//
//  KUStationsManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/08.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUStationsManager : NSObject

+ (NSDictionary*)stationsWithTrainId:(NSString*)trianId;

@end
