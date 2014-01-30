//
//  KUResponse.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/17.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUResponse.h"
#import "KUDBClient.h"

@implementation KUResponse

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = dic[@"name"];
    _dep_time = dic[@"dep_time"];
    _arr_time = dic[@"arr_time"];
    _seat_ec_ns = [self seatValueForString:dic[@"seat_ec_ns"]];
    _seat_ec_s = [self seatValueForString:dic[@"seat_ec_s"]];
    _seat_gr_ns = [self seatValueForString:dic[@"seat_gr_ns"]];
    _seat_gr_s = [self seatValueForString:dic[@"seat_gr_s"]];
    
    return self;
    
}


- (enum KUSheetValue)seatValueForString:(NSString*)str
{
    if ([str isEqualToString:@"○"]) {
        return SEAT_VACANT;
    }
    
    if ([str isEqualToString:@"△"]) {
        return SEAT_BIT;
    }
    
    if ([str isEqualToString:@"*"]) {
        return SEAT_NOT_EXIST_SMOKINGSEAT;
    }
    
    if ([str isEqualToString:@"×"]) {
        return SEAT_FULL;
    }
    
    else{
        return SEAT_INVALID;
    }
}


- (void)post
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client insertResponse:self];
}

- (void)delete
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteResponse:self];
}

- (void)update
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client updateResponse:self];
}

@end
