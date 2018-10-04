//
//  ColorCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/22.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "ColorCommon.h"
#import "AppearanceCommon.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorCommon

+(UIColor*) getColorFor:(NSInteger)forCode withColorCode:(NSInteger)colorCode{
    CGFloat r,g,b, rLight,gLight,bLight, rMiddle,gMiddle,bMiddle, rDark,gDark,bDark;
    switch (colorCode) {
        case CLR_ORANGE:
            rLight = 255; gLight = 231; bLight = 186;
            rMiddle = 255; gMiddle = 165; bMiddle = 79;
            rDark = 205; gDark = 102; bDark = 29;     
        break;
        case CLR_GREEN:
            rLight = 193; gLight = 255; bLight = 193;
            rMiddle = 50; gMiddle = 205; bMiddle = 50;
            rDark = 0; gDark = 139; bDark = 69;
        break;
        case CLR_BLUE:
            rLight = 175; gLight = 238; bLight = 238;
            rMiddle = 51; gMiddle = 102; bMiddle = 255;
            rDark = 39; gDark = 64; bDark = 139;
        break;
        case CLR_BLACK:
            rLight = 235; gLight = 235; bLight = 235;
            rMiddle = 50; gMiddle = 50; bMiddle = 50;
            rDark = 32; gDark = 32; bDark = 32;
        break;
        case CLR_PINK:
            rLight = 255; gLight = 225; bLight = 255;
            rMiddle = 238; gMiddle = 130; bMiddle = 238;
            rDark = 205; gDark = 41; bDark = 144;
        break;
        default:
            rLight = 230; gLight = 230; bLight = 250;
            rMiddle = 153; gMiddle = 51; bMiddle = 255;
            rDark = 102; gDark = 0; bDark = 153;
        break;
    }
    switch (forCode) {
        case CLR_FOR_BG_LIGHT:
            r=rLight; g=gLight; b=gLight;
        break;
        case CLR_FOR_BUTTON:
            r=rMiddle; g=gMiddle; b=bMiddle;
        break;
        case CLR_FOR_SEG:
            r=rMiddle*1.16; g=gMiddle*1.16; b=bMiddle*1.16;
        break;
        case CLR_FOR_NAV:
            r=rDark*1.36; g=gDark*1.36; b=bDark*1.36;
        break;
        case CLR_FOR_TAB:
            r=rDark; g=gDark; b=bDark;
        break;
        case CLR_FOR_BG_DARK:
            r=rDark*1.24; g=gDark*1.24; b=bDark*1.24;
        break;
        default:
            r=rDark; g=gDark; b=bDark;
        break;
    }
    
    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0];
}

+(NSArray*)getAllColor{
    NSMutableArray *colors = [NSMutableArray array];
    CGFloat x = [[[AppearanceCommon alloc] init] getButtonSize:BUTTON_SIZE_NORMAL];
    for(NSInteger i=0; i<6; i++){
        UIView *clrView = [ [UIView alloc] initWithFrame:CGRectMake(x/5, x/5, x*3/5, x*3/5)];
        clrView.backgroundColor = [self getColorFor:CLR_FOR_CONTENT withColorCode:i];
        UIGraphicsBeginImageContext(clrView.frame.size);
        [clrView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *clrImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [colors insertObject:clrImg atIndex:i];
    }
    return colors;
}
+(NSArray*) getAllUIColor{
    NSMutableArray *colors = [NSMutableArray array];
    for(NSInteger i=0; i<6; i++){
        UIColor *clr = [self getColorFor:CLR_FOR_CONTENT withColorCode:i];
        [colors insertObject:clr atIndex:i];
    }
    return colors;
}
@end
