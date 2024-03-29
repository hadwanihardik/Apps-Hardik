//
//  api_Database.m
//  APITesting
//
//  Created by Taimur Mushtaq on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "api_Database.h"

@implementation api_Database

@synthesize  databasePath, databaseName, dataArray;

+(NSString *) getDatabasePath:(NSString *)dbName
{
    // Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:dbName];
}

+(void)checkAndCreateDB:(NSString *)dbName dbPath:(NSString *)dbPath
{
    BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:dbPath];
	
	if(success) return;
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
	
	[fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
	
}

+(NSMutableArray *) selectDataFromDatabase:(NSString *)dbname query:(NSString *)query
{
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
   // NSLog(@"%@", query);
    //NSMutableArray *subArray = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
    NSLog(@"path :%@", dbPath);
    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
	const char *sqlStatement;
    int columnCounter=0;
	// Open the database from the users filessytem
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                for(int i=0;i<columnCounter;i++)
                {
                    //NSString * test = @"Test";
                    
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
                [mainArray addObject:subDic];
                subDic = nil;
                subDic = [[NSMutableDictionary alloc] init];
                
			}
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return mainArray;
    
}

#pragma ALL DB METHODS FOR PART SECTION - by Tushar Navadiya

+(NSMutableDictionary *) selectSingleDataFromDatabase:(NSString *)dbname query:(NSString *)query
{
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    NSLog(@"%@", query);
    //NSMutableArray *subArray = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
    
    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
	const char *sqlStatement;
    int columnCounter=0;
	// Open the database from the users filessytem
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                for(int i=0;i<columnCounter;i++)
                {
                    //NSString * test = @"Test";
                    
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
			}
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return subDic;
    
}

#pragma END by Tushar Navadiya

+(BOOL)genericQueryforDatabase:(NSString *)dbname query:(NSString *)query
{
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
    
    BOOL resultCheck = false;
    
    sqlite3 *database;
    
	const char *sqlStatement;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
		
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            if(sqlite3_step(compiledStatement) == SQLITE_OK) 
            {
                resultCheck = false;
                
			}else
                
            {
                resultCheck = true;
            }
        }
        
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return resultCheck;
    
}

@end
