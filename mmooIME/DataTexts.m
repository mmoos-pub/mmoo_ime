//
//  DataTexts.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/18.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "DataTexts.h"
#import "DataCommon.h"

@implementation DataTexts
+(NSString*) getNewID{
   return [DataCommon getNewFileNameInDir:DIR_CONTENT];
}
+(NSArray*) getSortedFileNames{
    NSDictionary *files = [DataCommon getAllFileInDir:DIR_CONTENT];
    NSMutableDictionary *forSort = [NSMutableDictionary dictionary];
    for(NSString *fileName in [files allKeys]){
        NSDictionary *fileAttr = [files objectForKey:fileName];
        NSString *update = [fileAttr objectForKey:FILE_UPDATED];
        [forSort setValue:fileName forKey:update];
    }
    NSArray *keys = [[forSort allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableArray *sorted = [NSMutableArray array];
    for(NSString *key in keys){
        [sorted insertObject:[forSort objectForKey:key] atIndex:0];
    }
    return sorted;
}
-(NSComparisonResult) compare:(NSString*)k{
    return [(NSString*)self compare:k];
}

+(NSString*) getIDbyIndex:(NSInteger)arrIndex{
    return [[self getSortedFileNames] objectAtIndex:arrIndex];
}
+(NSInteger) getFileCnt{
    return (NSInteger)[[DataCommon getAllFileInDir:DIR_CONTENT] count];
}

+(NSString*) getTitleByID:(NSString*)textID{
    return [DataCommon getSavedStringByFileName:textID inDir:DIR_TITLE];
}
+(NSString*) getContentByID:(NSString*)textID{
    return [DataCommon getSavedStringByFileName:textID inDir:DIR_CONTENT];
}
+(NSString*) getTitleByIndex:(NSInteger)arrIndex{
    return [self getTitleByID:[self getIDbyIndex:arrIndex]];
}
+(NSString*) getContentByIndex:(NSInteger)arrIndex{
    return [self getContentByID:[self getIDbyIndex:arrIndex]];
}


+(void) saveTextData:(NSString*)content withTextID:(NSString*)textID withTitle: (NSString*)title{
    [DataCommon saveString:title inDir:DIR_TITLE withFileName:textID];
    [DataCommon saveString:content inDir:DIR_CONTENT withFileName:textID];
}
+(void) deleteTextDataByID:(NSString*)textID{
    [DataCommon deleteDatumByFileName:textID inDir:DIR_TITLE];
    [DataCommon deleteDatumByFileName:textID inDir:DIR_CONTENT];
}
+(void) deleteTextDataByIndex:(NSInteger)arrIndex{
    [self deleteTextDataByID:[self getIDbyIndex:arrIndex]];
}

@end