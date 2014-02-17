//
//  KUDBClient.m
//  Kuseki
//
//  Created by Takeru Yoshihara on 2014/01/29.
//  Copyright (c) 2014年 Takeru Yoshihara. All rights reserved.
//

#import "KUDBClient.h"
#import "FMDatabase.h"

static KUDBClient *_sharedClient = nil;
@implementation KUDBClient


+ (KUDBClient*)sharedClient
{
    if (_sharedClient == nil) {
        _sharedClient = [KUDBClient new];
        
        //パス準備
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _sharedClient.dbPath = [paths[0] stringByAppendingPathComponent:@"database.db"];
        
    }
    
    return _sharedClient;
}


+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (_sharedClient == nil) {
            _sharedClient = [super allocWithZone:zone];
            return _sharedClient;
        }
    }
    return nil;
}


- (id)copyWithZone:(NSZone*)zone{
    return self;
}



//db作成
- (void)createDBFile{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
}


//テーブル削除
- (void)deleteTableWithName:(enum KUTableName)tableName
{
    NSString *name;
    if (tableName == KU_TABLE_CONDITIONS) {
        name = @"conditions";
    
    }else if (tableName == KU_TABLE_NOTIFICATION_TARGETS){
        name = @"notification_targets";
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",name];
    [db open];
    [db executeUpdate:sql];
    [db close];
}


//テーブル作成
- (void)createTableWithName:(enum KUTableName)tableName{
    
    NSString *sql;
    if (tableName == KU_TABLE_CONDITIONS) {//検索条件
        sql = @"CREATE TABLE IF NOT EXISTS conditions (id INTEGER PRIMARY KEY AUTOINCREMENT, month TEXT, day TEXT, hour TEXT, minute TEXT, train TEXT, dep_stn TEXT, arr_stn TEXT)";
        
    }else if (tableName == KU_TABLE_NOTIFICATION_TARGETS){//検索結果
        sql = @"CREATE TABLE IF NOT EXISTS notification_targets (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dep_time TEXT, arr_time TEXT, seat_ec_ns TEXT, seat_ec_s TEXT, seat_gr_ns TEXT, seat_gr_s TEXT, seat_gs_ns TEXT, condition_id TEXT, dep_stn TEXT, arr_stn TEXT, month TEXT, day TEXT )";
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    [db open];
    [db executeUpdate:sql];
    [db close];

}


//データ挿入
- (void)insertNotificationTarget:(KUNotificationTarget*)target
{
    [self createTableWithName:KU_TABLE_NOTIFICATION_TARGETS];
    
    if (!target) {
        NSException *ex = [NSException exceptionWithName:@"InsertNotificationTargetException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO notification_targets(name, dep_time, arr_time, seat_ec_ns, seat_ec_s, seat_gr_ns, seat_gr_s, seat_gs_ns, condition_id, dep_stn, arr_stn, month, day) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    //クエリ準備
    NSString *ec_ns = [NSString stringWithFormat:@"%d",target.seat_ec_ns];
    NSString *ec_s = [NSString stringWithFormat:@"%d",target.seat_ec_s];
    NSString *gr_ns = [NSString stringWithFormat:@"%d",target.seat_gr_ns];
    NSString *gr_s  = [NSString stringWithFormat:@"%d",target.seat_gr_s];
    NSString *gs_ns = [NSString stringWithFormat:@"%d",target.seat_gs_ns];
    
    
    [db open];
    [db executeUpdate:sql, target.name, target.dep_time, target.arr_time, ec_ns, ec_s, gr_ns, gr_s, gs_ns, target.condition_id , target.dep_stn, target.arr_stn, target.month, target.day];
    
    [db close];

}


- (void)insertCondition:(KUSearchCondition*)condition{
    
    [self createTableWithName:KU_TABLE_CONDITIONS];
    
    if (!condition) {
        NSException *ex = [NSException exceptionWithName:@"InsertConditionException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO conditions(month, day, hour, minute, train, dep_stn, arr_stn) VALUES(?, ?, ?, ?, ?, ?, ?)";
    
    [db open];
    [db executeUpdate:sql, condition.month, condition.day, condition.hour, condition.minute, condition.train, condition.dep_stn, condition.arr_stn];
    
    [db close];
    
}


//データ削除
- (void)deleteNotificationTarget:(KUNotificationTarget*)target{
    
    if (!target) {
        NSException *ex = [NSException exceptionWithName:@"DeleteNotificationTargetException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    //NSString *sql = @"DELETE FROM notification_targets WHERE id = ?";
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM notification_targets WHERE id = %@",target.identifier];
    NSLog(@"sql:%@",sql);
    
    [db open];
    [db executeUpdate:sql];
    [db close];
    
}


- (void)deleteCondition:(KUSearchCondition*)condition{
    
    if (!condition) {
        NSException *ex = [NSException exceptionWithName:@"DeleteConditionException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"DELETE FROM conditions WHERE id = ?";
    
    [db open];
    [db executeUpdate:sql, [NSNumber numberWithInt:[condition.identifier intValue]]];
    [db close];
    
}


//データ更新
- (void)updateNotificationtarget:(KUNotificationTarget*)target{
    
    if (!target) {
        NSException *ex = [NSException exceptionWithName:@"UpdateNotificationTargetException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"UPDATE notification_targets SET name = ?, dep_time = ?, arr_time = ?, seat_ec_ns = ?, seat_ec_s = ?, seat_gr_ns = ?, seat_gr_s = ?, seat_gs_ns = ?, condition_id = ?, dep_stn = ?, arr_stn = ?, month = ?, day = ? WHERE id = ? VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    
    [db open];
    [db executeUpdate:sql, target.name, target.dep_time, target.arr_time, target.seat_ec_ns, target.seat_ec_s, target.seat_gr_ns, target.seat_gr_s, target.seat_gs_ns, target.condition_id, target.dep_stn, target.arr_stn, target.month, target.day];
    
    
    [db close];
}



//データ取得
- (NSArray*)selectAllNotificationTargets
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM notification_targets";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    NSMutableArray *array = NSMutableArray.new;
    
    while ([results next]) {
        
        KUNotificationTarget *target = [KUNotificationTarget new];
        
        target.identifier = [NSString stringWithFormat:@"%d",[results intForColumn:@"id"]];
        target.name = [results stringForColumn:@"name"];
        target.dep_time = [results stringForColumn:@"dep_time"];
        target.arr_time = [results stringForColumn:@"arr_time"];
        target.seat_ec_ns = [results stringForColumn:@"seat_ec_ns"].intValue;
        target.seat_ec_s   = [results stringForColumn:@"seat_ec_s"].intValue;
        target.seat_gr_ns = [results stringForColumn:@"seat_gr_ns"].intValue;
        target.seat_gr_s  = [results stringForColumn:@"seat_gr_s"].intValue;
        target.seat_gs_ns = [results stringForColumn:@"seat_gs_ns"].intValue;
        target.condition_id = [results stringForColumn:@"condition_id"];
        target.dep_stn = [results stringForColumn:@"dep_stn"];
        target.arr_stn = [results stringForColumn:@"arr_stn"];
        target.month = [results stringForColumn:@"month"];
        target.day= [results stringForColumn:@"day"];
        
        [array addObject:target];
    }
    
    NSArray *reversedData = [[array reverseObjectEnumerator]allObjects];
    return reversedData;
    
    [db close];
}


- (NSArray*)selectAllConditions
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM conditions";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    NSMutableArray *array = NSMutableArray.new;
    
    while ([results next]) {
        
        NSDictionary *dic = @{@"identifier" : [NSString stringWithFormat:@"%d",[results intForColumn:@"id"]],
                              @"month"  : [results stringForColumn:@"month"],
                              @"day"    : [results stringForColumn:@"day"],
                              @"hour"   : [results stringForColumn:@"hour"],
                              @"minute" : [results stringForColumn:@"minute"],
                              @"train"  : [results stringForColumn:@"train"],
                              @"dep_stn": [results stringForColumn:@"dep_stn"],
                              @"arr_stn": [results stringForColumn:@"arr_stn"]
                              };
        
        KUSearchCondition *condition = [[KUSearchCondition alloc]initWithDictionary:dic];
        
        [array addObject:condition];
    }
    
    NSArray *reversedData = [[array reverseObjectEnumerator]allObjects];
    return reversedData;
    
    [db close];
}


- (void)deleteAllTargets
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"DELETE FROM notification_targets";
    NSLog(@"sql:%@",sql);
    
    [db open];
    [db executeUpdate:sql];
    [db close];
}




@end
