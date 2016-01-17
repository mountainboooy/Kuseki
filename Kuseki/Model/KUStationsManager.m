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
    NSDictionary *dicStations = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *key = [NSString stringWithFormat:@"station_id_%@",trainId];
    
    return dicStations[key];
}

+ (NSString *)englishNameOfStation:(NSString *)station {
    
    if (!station) {
        return nil;
    }
    
    NSString *englishName;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StationsList" ofType:@"plist"];
    NSDictionary *dicStations = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *stationIds = dicStations.allKeys;
    for(NSString *stationId in stationIds) {
        NSDictionary *stations = dicStations[stationId];
        for(NSString *japaneseName in stations[@"ja"]) {
            if ([japaneseName isEqualToString:station]) {
                NSInteger index = [stations[@"ja"] indexOfObject:station];
                englishName = stations[@"en"][index];
            }
        }
    }
    
    return englishName;
}

@end
