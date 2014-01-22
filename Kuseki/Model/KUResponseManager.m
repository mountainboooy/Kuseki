//
//  KUResponseManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUResponseManager.h"
#import "KUResponse.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

static KUResponseManager *_sharedManager = nil;
@implementation KUResponseManager


+ (KUResponseManager*)sharedManager
{
    if(_sharedManager == nil){
        _sharedManager = [KUResponseManager new];
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


- (NSArray*)parseHTML:(NSString*)bodyData
{
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
                NSLog(@"name:%@",[tdNodes[0] contents]);
                NSLog(@"dep_time:%@",[tdNodes[1] contents]);
                NSLog(@"arr_time:%@",[tdNodes[2] contents]);
                NSLog(@"ec_ns:%@",[tdNodes[3] contents]);
                NSLog(@"ec_s:%@",[tdNodes[4] contents]);
                NSLog(@"gr_ns:%@",[tdNodes[5] contents]);
                NSLog(@"gr_s:%@",[tdNodes[6] contents]);
            }
        }
    }

    return [NSArray array];
    
    
}





@end
