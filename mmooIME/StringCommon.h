//
//  StringCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringCommon : NSObject

+(NSInteger) getLen:(NSString*)str;
+(NSString*) getSub:(NSString*)str to:(NSInteger)to;
+(NSString*) getSub:(NSString *)str from:(NSInteger)from;

+(NSString*) urlEncode:(NSString*)str;

+(NSInteger) getWordCnt:(NSString*)str;

@end
