//
//  KUSavedResponsesManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/07.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUSavedResponsesManager.h"
#import "KUSearchCondition.h"
#import "KUClient.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "KUResponse.h"
static KUSavedResponsesManager *_sharedManager = nil;

@interface KUSavedResponsesManager()
{
    NSInteger _num_executedConditions;
    NSInteger _num_conditions;
}

@end

@implementation KUSavedResponsesManager

+ (KUSavedResponsesManager*)sharedManager
{
    if(_sharedManager == nil){
        _sharedManager = [KUSavedResponsesManager new];
        _sharedManager.responses = [NSMutableArray new];
        
    }
    
    return _sharedManager;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (_sharedManager == nil) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone*)zone{
    
    return self;
}



- (void)addResponse:(KUResponse*)response
{
    if(!response){
        return;
    }
    
    [_responses addObject:response];
}


//複数の検索条件から空席情報を取得する
- (void)getResponsesWithConditions:(NSArray*)conditions
{
    _num_executedConditions = 0;
    _num_conditions = conditions.count;
    
    for (KUSearchCondition * condition in conditions) {
        [self performSelector:@selector(delayAction:) withObject:condition afterDelay:2];
    }
}


//TODO:BlocksKit入れる
- (void)delayAction:(KUSearchCondition*)condition
{
    [self getResponsesWithParam:condition completion:^{
        _num_executedConditions += 1;
        
        if (_num_executedConditions == _num_conditions) {//全ての情報を取得完了
            [_delegate savedResponseManager:self DidFinishLoadingResponses:_responses];
        }
    }failure:^(NSHTTPURLResponse *res, NSError *err) {
        //エラーハンドリング
        [_delegate savedResponseManagerDidFailLoading];
    }];
    
}



//１件の検索条件から空席情報を取得する
- (void)getResponsesWithParam:(KUSearchCondition*)condition completion:(KUResponseNetworkCompletion)completion failure:(KUResponseNetworkFailure)failure
{
    //url
    NSURL  *base_url = [NSURL URLWithString:@"http://www1.jr.cyberstation.ne.jp/"];
    NSString *path = @"csws/Vacancy.do";
    
    //param
    NSDictionary *param = @{@"month":condition.month,
                            @"day":condition.day,
                            @"hour":condition.hour,
                            @"minute":condition.minute,
                            @"train":condition.train,
                            @"dep_stn":condition.dep_stn,
                            @"arr_stn":condition.arr_stn
                            };
    
    
    KUClient *client = [[KUClient alloc]initWithBaseUrl:base_url];
    
    [client postPath:path param:param completion:^(NSString *dataString) {
        
        _responses = [self setInfoWithBodyData:dataString condition:condition];
        
        if (_responses.count == 0) {//取得件数0の場合
            if (failure) {
                failure(nil,nil);
            }
            return;
        }
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSHTTPURLResponse *res, NSError *error) {
        if (failure) {
            failure(res, error);
        }
    }];
}




//パースして格納するまで
- (NSMutableArray*)setInfoWithBodyData:(NSString*)bodyData condition:(KUSearchCondition*)condition
{
    NSError *err = nil;
    HTMLParser *parser = [[HTMLParser alloc]initWithString:bodyData error:&err];
    NSMutableArray *array = [NSMutableArray new];
    
    if (err) {
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *tableNodes = [bodyNode findChildTags:@"table"];
    NSArray *trNodes;
    
    
    for (HTMLNode *tableNode in tableNodes) {//テーブルの中の<tr>の要素を抽出
        if ([[tableNode getAttributeNamed:@"border"]isEqualToString:@"3"]) {
            trNodes = [tableNode findChildTags:@"tr"];
        }
    }
    
    
    
    for (HTMLNode *trNode in trNodes) {
        
        if ([trNodes indexOfObject:trNode] > 1 ) {
            
            NSArray *tdNodes = [trNode findChildTags:@"td"];
            
            NSDictionary *response;
            if (tdNodes.count == 7) {//西側
                
                response = @{@"name":[tdNodes[0] contents],
                                           @"dep_time":[tdNodes[1] contents],
                                           @"arr_time":[tdNodes[2] contents],
                                           @"seat_ec_ns":[tdNodes[3] contents],
                                           @"seat_ec_s":[tdNodes[4] contents],
                                           @"seat_gr_ns":[tdNodes[5] contents],
                                           @"seat_gr_s":[tdNodes[6] contents],
                                           @"month":condition.month,
                                           @"day":condition.day
                                           };

            }else if(tdNodes.count == 6){//東側
                
                response = @{@"name":[tdNodes[0] contents],
                             @"dep_time":[tdNodes[1] contents],
                             @"arr_time":[tdNodes[2] contents],
                             @"seat_ec_ns":[tdNodes[3] contents],
                             @"seat_gr_ns":[tdNodes[4] contents],
                             @"seat_gs_ns":[tdNodes[5]contents],
                             @"month":condition.month,
                             @"day":condition.day
                             };
            }
            
            KUResponse *new_response = [[KUResponse alloc]initWithDictionary:response];
            [array addObject:new_response];
        }
    }
    
    return array;
    
}




@end
