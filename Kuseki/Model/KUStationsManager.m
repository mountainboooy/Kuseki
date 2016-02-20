//
//  KUStationsManager.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/02/08.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUStationsManager.h"
static NSString *const PREVIOUS_DEPARTURE_STATION = @"PREVIOUS_DEPARTURE_STATION";
static NSString *const PREVIOUS_DESTINATION_STATION = @"PREVIOUS_DESTINATION_STATION";


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

+ (void)savePreviousDepartureStation:(NSString *)station {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:station forKey:PREVIOUS_DEPARTURE_STATION];
    [ud synchronize];
}

+ (void)savePreviousDestinationStation:(NSString *)station {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:station forKey:PREVIOUS_DESTINATION_STATION];
    [ud synchronize];
}

+ (NSString *)previousDepartureStation {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *previousDepartuerStation = [ud stringForKey:PREVIOUS_DEPARTURE_STATION];
    return previousDepartuerStation ? previousDepartuerStation : @"東京";
}

+ (NSString *)previousDestinationStation {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *previousDestinationStation = [ud stringForKey:PREVIOUS_DESTINATION_STATION];
    return previousDestinationStation ? previousDestinationStation : @"新大阪";
}

@end
