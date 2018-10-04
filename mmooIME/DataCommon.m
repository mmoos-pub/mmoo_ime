//
//  DataCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/18.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "DataCommon.h"

@implementation DataCommon
+(NSString*) getPathForDir:(NSString*)dirName{
    NSArray *arrPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path;    
    path = [arrPath objectAtIndex:0];
    path = [path stringByAppendingPathComponent:dirName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    if(![fm fileExistsAtPath:path]){
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    }
    return path;
}
+(NSString*) getPathForFile:(NSString*)fileName inDir:(NSString*)DirName{
    return [[self getPathForDir:DirName] stringByAppendingPathComponent:fileName];
}

+(NSDictionary*) getAllFileInDir:(NSString*)dirName{
    NSDirectoryEnumerator *de = [
        [NSFileManager defaultManager] 
        enumeratorAtPath:[DataCommon getPathForDir:dirName]
    ];
    NSMutableDictionary *files = [NSMutableDictionary dictionary];
    NSString *fileName;
    NSDictionary *fileAttr;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    while( fileName = [de nextObject] ){
        fileAttr = [NSDictionary dictionaryWithObjectsAndKeys:
            [df stringFromDate:[de fileAttributes].fileCreationDate] , FILE_CREATED,
            [df stringFromDate:[de fileAttributes].fileModificationDate] , FILE_UPDATED,
        nil];
        [files setValue:fileAttr forKey:fileName];
    }
    return files;
}
+(NSString*) getNewFileNameInDir:(NSString*)dirName{
    NSInteger maxID = 0;
    NSArray *fileNames = [[self getAllFileInDir:dirName] allKeys];
    for(NSString *fileName in fileNames){
        if( [fileName intValue] > maxID ){ maxID = [fileName intValue]; }
    }
    return [NSString stringWithFormat:@"%08zd",maxID+1];
}


+(NSString*) getSavedStringByFileName:(NSString*)fileName inDir:(NSString*)dirName{
    NSString *filePath = [self getPathForFile:fileName inDir:dirName];
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return [ [NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
    }else{
        return nil;
    }
}
+(NSArray*) getSavedArrayByFileName:(NSString*)fileName inDir:(NSString*)dirName{
    NSString *filePath = [self getPathForFile:fileName inDir:dirName];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ){
        return [[NSArray alloc] initWithContentsOfFile:filePath];
    }else{
        return nil;
    }
}

+(void) saveString:(NSString*)content inDir:(NSString*)dirName withFileName:(NSString *)fileName{
    NSString *filePath = [self getPathForFile:fileName inDir:dirName];
    if(content==nil){ content=@""; }
    NSData *inputData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSFileManager *fm = [ NSFileManager defaultManager ];
    if([fm fileExistsAtPath:filePath]){
        [inputData writeToFile:filePath atomically:YES];
    }else{
        [fm createFileAtPath:filePath contents:inputData attributes:nil];
    }       
}
+(void) saveArray:(NSArray*)content inDir:(NSString*)dirName fileName:(NSString*)fileName{
    NSString *filePath = [self getPathForFile:fileName inDir:dirName];
    if(content==nil){ content=[NSArray array]; }
    NSFileManager *fm = [NSFileManager defaultManager];
    if( ![fm fileExistsAtPath:filePath] ){
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    [content writeToFile:filePath atomically:YES];
}
+(void) deleteDatumByFileName:(NSString *)fileName inDir:(NSString*)dirName{
    NSString *filePath = [self getPathForFile:fileName inDir:dirName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    if([fm fileExistsAtPath:filePath]){
        [fm removeItemAtPath:filePath error:&err];
    }
}
@end
