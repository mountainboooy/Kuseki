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
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO responses(month, day, hour, minute, train, dep_stn, arr_stn) VALUES(?, ?, ?, ?, ?, ?, ?)";
    
    [db open];
    [db executeUpdate:sql, condition.month, condition.day, condition.hour, condition.minute, condition.train, condition.dep_stn, condition.arr_stn];
    
    [db close];
    
}


//データ削除
- (void)deleteResponse:(KUResponse*)response{
    
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





//データ取得



@end
