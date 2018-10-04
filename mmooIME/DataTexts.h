//
//  DataTexts.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/18.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIR_TITLE @"tt"
#define DIR_CONTENT @"tc"

@interface DataTexts : NSObject

+(NSString*) getNewID;
+(NSArray*) getSortedFileNames;
+(NSString*) getIDbyIndex:(NSInteger)arrIndex;
+(NSInteger) getFileCnt;

+(NSString*) getTitleByID:(NSString*)textID;
+(NSString*) getContentByID:(NSString*)textID;
+(NSString*) getTitleByIndex:(NSInteger)arrIndex;
+(NSString*) getContentByIndex:(NSInteger)arrIndex;

+(void) saveTextData:(NSString*)content withTextID:(NSString*)textID withTitle: (NSString*)title;
+(void) deleteTextDataByID:(NSString*)textID;
+(void) deleteTextDataByIndex:(NSInteger)arrIndex;

@end
