//
//  KUSavedResponsesManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUSearchCondition.h"
typedef void (^KUResponseNetworkCompletion)();
typedef void (^KUResponseNetworkFailure)(NSHTTPURLResponse *res, NSError *err);
@protocol KUSavedResponsesManagerDelegate;

@interface KUSavedResponsesManager : NSObject

@property (nonatomic,strong) NSMutableArray *responses;
@property (nonatomic,weak) id delegate;

+ (KUSavedResponsesManager*)sharedManager;

- (void)getResponsesWithConditions:(NSArray*)conditions;
- (void)getResponsesWithParam:(KUSearchCondition*)condition completion:(KUResponseNetworkCompletion)completion failure:(KUResponseNetworkFailure)failure;

@end


@protocol KUSavedResponsesManagerDelegate <NSObject>
- (void)savedResponseManager:(id)manager DidFinishLoadingResponses:(NSArray*)responses;
- (void)savedResponseManagerDidFailLoading;
@end