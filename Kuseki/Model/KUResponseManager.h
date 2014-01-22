//
//  KUResponseManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUSearchParamManager.h"
typedef void (^KUResponseNetworkCompletion)();
typedef void (^KUResponseNetworkFailure)();

@interface KUResponseManager : NSObject
@property (nonatomic,strong) NSMutableArray *responses;

+ (KUResponseManager*)sharedManager;

- (NSArray*)setInfoWithBodyData:(NSString*)bodyData;

- (void)getResponsesWithParam:(KUSearchParamManager*)paramManager completion:(KUResponseNetworkCompletion)completion failure:(KUResponseNetworkFailure)failure;

@end
