//
//  KUSavedResponsesManager.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^KUResponseNetworkCompletion)();
typedef void (^KUResponseNetworkFailure)();


@interface KUSavedResponsesManager : NSObject

@property (nonatomic,strong) NSMutableArray *responses;

+ (KUSavedResponsesManager*)sharedManager;

- (void)getResponsesWithConditions:(NSArray*)conditions;

@end
