//
//  KUResponseManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUSearchCondition.h"
typedef void (^KUResponseNetworkCompletion)();
typedef void (^KUResponseNetworkFailure)(NSHTTPURLResponse *res, NSError *err);

@interface KUResponseManager : NSObject
@property (nonatomic,strong) NSMutableArray *responses;
@property (nonatomic,strong) KUSearchCondition *condition;

+ (KUResponseManager*)sharedManager;

- (NSMutableArray*)setInfoWithBodyData:(NSString*)bodyData;

- (void)getResponsesWithParam:(KUSearchCondition*)condition completion:(KUResponseNetworkCompletion)completion failure:(KUResponseNetworkFailure)failure;

@end
