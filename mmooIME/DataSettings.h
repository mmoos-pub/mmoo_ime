//
//  DataSettings.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/20.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIR_SETTINGS @"s"
#define FILE_LANGUAGE @"lang"
#define FILE_COLOR @"clr"
#define FILE_POLICY @"policy"

@interface DataSettings : NSObject

+(NSString*) convertCode:(NSInteger)from;

+(NSInteger) getLanguage;
+(void) setLanguage:(NSInteger)langCode;

+(NSInteger) getColor;
+(void) setColor:(NSInteger)colorCode;

+(Boolean) getPolicyFlg;
+(void) setPolicyFlg;

@end
