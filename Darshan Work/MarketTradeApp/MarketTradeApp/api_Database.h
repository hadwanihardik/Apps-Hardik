//
//  api_Database.h
//  APITesting
//
//  Created by Taimur Mushtaq on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface api_Database : NSObject
{
    NSString *databasePath;
    NSString *databaseName;
    NSArray  *dataArray;
}

@property(nonatomic,retain) NSString *databasePath;
@property(nonatomic,retain) NSString *databaseName;
@property(nonatomic,retain) NSArray *dataArray;


//for Database

+(NSString *) getDatabasePath:(NSString *)dbName; 

+(void)checkAndCreateDB:(NSString *)dbName dbPath:(NSString *)dbPath;

+(NSMutableArray *) selectDataFromDatabase:(NSString *)dbname query:(NSString *)query;

+(BOOL)genericQueryforDatabase:(NSString *)dbname query:(NSString *)query;

#pragma ALL DB METHODS FOR PART SECTION - by Tushar Navadiya

+(NSMutableDictionary *) selectSingleDataFromDatabase:(NSString *)dbname query:(NSString *)query;

#pragma END by Tushar Navadiya

@end
