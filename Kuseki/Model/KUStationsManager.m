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

+ (NSString *)localizedStation:(NSString *)station {
    
    if (!station) {
        return nil;
    }
    if ([self preferredJapanese]) {
        return station;
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

+ (BOOL)preferredJapanese {
    NSString *preferredlanguage = [NSLocale preferredLanguages][0];
    NSRange range = [preferredlanguage rangeOfString:@"ja"];
    return (range.location != NSNotFound);
}

@end
