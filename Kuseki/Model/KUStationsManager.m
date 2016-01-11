//
//  KUStationsManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/08.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUStationsManager.h"

@implementation KUStationsManager


+ (NSDictionary*)stationsWithTrainId:(NSString*)trainId
{
    if (!trainId) {
        return nil;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"StationsList" ofType:@"plist"];
    NSDictionary *dic_stations = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *key = [NSString stringWithFormat:@"station_id_%@",trainId];
    
    return dic_stations[key];
}

@end
