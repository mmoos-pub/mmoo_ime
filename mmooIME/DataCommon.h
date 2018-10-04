//
//  DataCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/18.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE_CREATED @"created"
#define FILE_UPDATED @"updated"

@interface DataCommon : NSObject 

+(NSString*) getPathForDir:(NSString*)dirName;
+(NSString*) getPathForFile:(NSString*)fileName inDir:(NSString*)DirName;

+(NSDictionary*) getAllFileInDir:(NSString*)dirName;
+(NSString*) getNewFileNameInDir:(NSString*)dirName;

+(NSString*) getSavedStringByFileName:(NSString*)fileName inDir:(NSString*)dirName;
+(NSArray*) getSavedArrayByFileName:(NSString*)fileName inDir:(NSString*)dirName;

+(void) saveString:(NSString*)content inDir:(NSString*)dirName withFileName:(NSString *)fileName;
+(void) saveArray:(NSArray*)content inDir:(NSString*)dirName fileName:(NSString*)fileName;
+(void) deleteDatumByFileName:(NSString *)fileName inDir:(NSString*)dirName;

@end