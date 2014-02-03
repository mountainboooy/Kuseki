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
    
    _name = [self validateTrainName:dic[@"name"]];
    _dep_time = dic[@"dep_time"];
    _arr_time = dic[@"arr_time"];
    _seat_ec_ns = [self seatValueForString:dic[@"seat_ec_ns"]];
    _seat_ec_s = [self seatValueForString:dic[@"seat_ec_s"]];
    _seat_gr_ns = [self seatValueForString:dic[@"seat_gr_ns"]];
    _seat_gr_s = [self seatValueForString:dic[@"seat_gr_s"]];
    _identifier = [self identifierOfNotificationList];
    
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


- (void)insertToNotificationList
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client insertResponse:self];
}

- (void)deleteFromNotificationList
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client deleteResponse:self];
}

/*
- (void)update
{
    KUDBClient *client = [KUDBClient sharedClient];
    [client updateResponse:self];
}
*/


- (NSString*)identifierOfNotificationList
{
    KUDBClient *client = [KUDBClient sharedClient];
    NSArray *saved_responses = [client selectAllResponses];
    NSLog(@"arrya.count:%d",saved_responses.count);
    
    for (KUResponse * saved_response in saved_responses) {
        if ([saved_response.name isEqualToString:self.name] &&
            [saved_response.dep_time isEqualToString:self.dep_time] &&
            [saved_response.arr_time isEqualToString:self.arr_time]) {
            return saved_response.identifier;
        }
    }
    return nil;
}


//列車名を最適化
- (NSString*)validateTrainName:(NSString*)name
{
    NSString *validatedName;
    
    //空白を無くす
    validatedName = [name stringByReplacingOccurrencesOfString:@"　" withString:@" "];
    
    //<全席禁煙>も省く
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"＜全席禁煙＞" withString:@""];
    
    //数字は半角に
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"０" withString:@"0"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"１" withString:@"1"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"２" withString:@"2"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"３" withString:@"3"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"４" withString:@"4"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"５" withString:@"5"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"６" withString:@"6"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"７" withString:@"7"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"８" withString:@"8"];
    validatedName = [validatedName stringByReplacingOccurrencesOfString:@"９" withString:@"9"];
    
    
    
    
    return validatedName;
 
}




@end
