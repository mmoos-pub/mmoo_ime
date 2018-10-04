//
//  ColorCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/22.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLR_PURPLE 0
#define CLR_GREEN 1
#define CLR_ORANGE 2
#define CLR_BLUE 3
#define CLR_PINK 4
#define CLR_BLACK 5

#define CLR_FOR_BG_LIGHT 0
#define CLR_FOR_BG_DARK 1
#define CLR_FOR_TAB 2
#define CLR_FOR_NAV 3
#define CLR_FOR_BUTTON 4
#define CLR_FOR_SEG 5
#define CLR_FOR_CONTENT 6


@interface ColorCommon : NSObject

+(NSArray*) getAllColor;
+(NSArray*) getAllUIColor;
+(UIColor*) getColorFor:(NSInteger)forCode withColorCode:(NSInteger)colorCode;

@end
