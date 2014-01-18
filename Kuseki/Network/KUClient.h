//
//  KUClient.h
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^KUNetworkCompletion)();
typedef void(^KUNetworkFailure)();

@interface KUClient : NSObject

- (void)getSheetInfoWithParam:(NSDictionary*)param completion:(KUNetworkCompletion)completion failure:(KUNetworkFailure)failure;

- (NSString*)stringParamFromDictionary:(NSDictionary*)dic_param;


@end
