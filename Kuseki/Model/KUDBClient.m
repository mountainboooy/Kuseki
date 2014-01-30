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
    
    }else if (tableName == KU_TABLE_RESPONSES){
        name = @"responses";
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
        
    }else if (tableName == KU_TABLE_RESPONSES){//検索結果
        sql = @"CREATE TABLE IF NOT EXISTS responses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dep_time TEXT, arr_time TEXT, seat_ec_ns TEXT, seat_ec_s TEXT, seat_gr_ns TEXT, seat_gr_s TEXT )";
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    [db open];
    [db executeUpdate:sql];
    [db close];

}


//データ挿入
- (void)insertResponse:(KUResponse*)response
{
    if (!response) {
        NSException *ex = [NSException exceptionWithName:@"InsertResponseException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO responses(name, dep_time, arr_time, seat_ec_ns, seat_ec_s, seat_gr_ns, seat_gr_s) VALUES(?,?,?,?,?,?,?)";
    
    //クエリ準備
    NSString *ec_ns = [NSString stringWithFormat:@"%d",response.seat_ec_ns];
    NSString *ec_s = [NSString stringWithFormat:@"%d",response.seat_ec_s];
    NSString *gr_ns = [NSString stringWithFormat:@"%d",response.seat_gr_ns];
    NSString *gr_s  = [NSString stringWithFormat:@"%d",response.seat_gr_s];
    
    
    [db open];
    [db executeUpdate:sql, response.name, response.dep_time, response.arr_time,ec_ns, ec_s, gr_ns, gr_s ];
    
    [db close];

}


- (void)insertCondition:(KUSearchCondition*)condition{
    
    if (!condition) {
        return;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO responses(month, day, hour, minute, train, dep_stn, arr_stn) VALUES(?, ?, ?, ?, ?, ?, ?)";
    
    [db open];
    [db executeUpdate:sql, condition.month, condition.day, condition.hour, condition.minute, condition.train, condition.dep_stn, condition.arr_stn];
    
    [db close];
    
}


//データ削除
- (void)deleteResponse:(KUResponse*)response{
    
    if (!response) {
        NSException *ex = [NSException exceptionWithName:@"DeleteResponseException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"DELETE FROM responses WHERE id = ?";
    
    [db open];
    [db executeUpdate:sql, [NSNumber numberWithInt:[response.identifier intValue]]];
    [db close];
    
}


- (void)deleteCondition:(KUSearchCondition*)condition{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"DELETE FROM conditions WHERE id = ?";
    
    [db open];
    [db executeUpdate:sql, [NSNumber numberWithInt:[condition.identifier intValue]]];
    [db close];
    
}


//データ更新
- (void)updateResponse:(KUResponse*)response{
    
    if (!response) {
        NSException *ex = [NSException exceptionWithName:@"UpdateResponseException" reason:nil userInfo:nil];
        
        [ex raise];
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"UPDATE responses SET name = ?, dep_time = ?, arr_time = ?, seat_ec_ns = ?, seat_ec_s = ?, seat_gr_ns = ?, seat_gr_s = ? WHERE id = ? VALUES(?,?,?,?,?,?,?,?)";
    [db open];
    [db executeUpdate:sql, response.name, response.dep_time, response.arr_time, response.seat_ec_ns, response.seat_ec_s, response.seat_gr_ns, response.seat_gr_s];
    
    
    [db close];
}



//データ取得
- (NSArray*)selectAllResponses
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM responses";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    NSMutableArray *array = NSMutableArray.new;
    
    while ([results next]) {
        
        KUResponse *response = [KUResponse new];
        
        response.identifier = [NSString stringWithFormat:@"%d",[results intForColumn:@"id"]];
        response.name = [results stringForColumn:@"name"];
        response.dep_time = [results stringForColumn:@"dep_time"];
        response.arr_time = [results stringForColumn:@"arr_time"];
        response.seat_ec_ns = [results stringForColumn:@"seat_ec_ns"].intValue;
        response.seat_ec_s   = [results stringForColumn:@"seat_ec_s"].intValue;
        response.seat_gr_ns = [results stringForColumn:@"seat_gr_ns"].intValue;
        response.seat_gr_s  = [results stringForColumn:@"seat_gr_s"].intValue;
        
        [array addObject:response];
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



@end
