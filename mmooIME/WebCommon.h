//
//  WebCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TARGET_IME 1
#define TARGET_TEXT 2

#define ACTION_UPLOAD 1
#define ACTION_DOWNLOAD 2

#define GENRE_TYPE_KEY 0
#define GENRE_TYPE_STR 1
#define GENRE_NONE 999

@interface WebCommon : NSObject{
    NSInteger targetCode;
}

-(id) initWithTargetCode:(NSInteger)targetCode;
-(NSInteger) getCatCnt;
-(NSInteger) getGenreCntInCat:(NSInteger)catCode;
-(NSString*) getCat:(NSInteger)catCode;
-(NSString*) getGenre:(NSInteger)genreCode inCat:(NSInteger)catCode type:(NSInteger)type;
-(NSString*) convertGenre:(NSString*)genreKey;
+(NSMutableURLRequest*) getReq:(NSString*)str;

@end
