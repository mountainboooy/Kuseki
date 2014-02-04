//
//  KUNotificationTarget.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/04.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUNotificationTarget.h"
#import "KUDBClient.h"
#import "KUResponse.h

@implementation KUNotificationTarget


- (id)initWithResponse:(KUResponse*)response
{
    self = [super init];
    
    if(!self){
        return nil;
    }
    
    _name= response.name;
    _dep_time = response.dep_time;
    _arr_time = response.arr_time;
    _seat_ec_ns = response.seat_ec_ns;
    _seat_ec_s  = response.seat_ec_s;
    _seat_gr_ns = response.seat_gr_ns;
    _seat_gr_s = response.seat_gr_s;
    
    return self;
    
}


- (enum KUSheetValue)seatValueForString:(NSString*)str
{
    NSLog(@"str:%@",str);
    if ([str isEqualToString:@"○"]) {
        return SEAT_VACANT;
    }
    
    if ([str isEqualToString:@"△"]) {
        return SEAT_BIT;
    }
    
    if ([str isEqualToString:@"＊"]) {
        return SEAT_NOT_EXIST_SMOKINGSEAT;
    }
    
    if ([str isEqualToString:@"×"]) {
        return SEAT_FULL;
    }
    
    else{
        return SEAT_INVALID;
    }
}


+ (void)saveWithResponse:(KUResponse*)response condition:(KUSearchCondition*)condition
{
    if (!condition || !response) {
        return;
    }
    
    KUNotificationTarget *new_target;
    new_target = [[KUNotificationTarget alloc]initWithResponse:response];
    new_target.condition_id = condition.identifier;
    
    KUDBClient *client = [KUDBClient sharedClient];
    [client insertNotificationTarget:new_target];
    
}


+ (void)removeWithResonse:(KUResponse*)response condition:(KUSearchCondition*)condition;
{
    KUDBClient *client = [KUDBClient sharedClient];
    
    NSArray *savedTargets = [client selectAllNotificationTargets];
    for (KUNotificationTarget *savedTarget in savedTargets) {
        if ([response.name isEqualToString:savedTarget.name] && [condition.identifier isEqualToString:savedTarget.condition_id]) {
            [client deleteNotificationTarget:savedTarget];
        }
    }
}


+ (void)update
{
    //あとで
}



- (void)getNewResponses
{
    
    //condition
    KUSearchCondition *targetCondition;
    NSArray *savedConditions = [[KUDBClient sharedClient]selectAllConditions];
    
    //対応する検索条件をDBから取得
    for (KUSearchCondition *savedCondition in savedConditions) {
        if ([savedCondition.identifier isEqualToString:_condition_id]) {
            targetCondition  = savedCondition;
        }
    }
    
    
    
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
        
        [self setInfoWithBodyData:dataString];
        if (completion) {
            completion();
        }
        
    } failure:^(NSHTTPURLResponse *res, NSError *error) {
        if (failure) {
            failure();
        }
        
    }];
}




- (NSArray*)setInfoWithBodyData:(NSString*)bodyData
{
    //TODO:ここでのエラーハンドリングが重要
    
    NSError *err = nil;
    HTMLParser *parser = [[HTMLParser alloc]initWithString:bodyData error:&err];
    
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
            
            if (tdNodes.count == 7) {
                
                //モデルクラス作成
                NSDictionary *response = @{@"name":[tdNodes[0] contents],
                                           @"dep_time":[tdNodes[1] contents],
                                           @"arr_time":[tdNodes[2] contents],
                                           @"seat_ec_ns":[tdNodes[3] contents],
                                           @"seat_ec_s":[tdNodes[4] contents],
                                           @"seat_gr_ns":[tdNodes[5] contents],
                                           @"seat_gr_s":[tdNodes[6] contents]
                                           };
                
                KUResponse *new_response = [[KUResponse alloc]initWithDictionary:response];
                [self addResponse:new_response];
            }
        }
    }
    
    return [NSArray array];
    
}





@end
