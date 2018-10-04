//
//  DataSettings.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/20.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "DataSettings.h"
#import "DataCommon.h"
#import "LangCommon.h"

@implementation DataSettings

+(NSString*) convertCode:(NSInteger)from{
    return [NSString stringWithFormat:@"%03zd", from];
}

+(NSInteger)getLanguage{
    NSString *code = [DataCommon getSavedStringByFileName:FILE_LANGUAGE inDir:DIR_SETTINGS];    
    if( code==nil && [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"ja"] ){
        [self setLanguage:LANG_JP];
        return LANG_JP;
    }else{
        return [code intValue];
    }
}
+(void) setLanguage:(NSInteger)langCode{
    [DataCommon saveString:[self convertCode:langCode] inDir:DIR_SETTINGS withFileName:FILE_LANGUAGE];
}

+(NSInteger)getColor{
    return [ [DataCommon getSavedStringByFileName:FILE_COLOR inDir:DIR_SETTINGS] intValue];
}
+(void)setColor: (NSInteger)colorCode{
    [DataCommon saveString:[self convertCode:colorCode] inDir:DIR_SETTINGS withFileName:FILE_COLOR];
}

+(Boolean) getPolicyFlg{
    return [[DataCommon getSavedStringByFileName:FILE_POLICY inDir:DIR_SETTINGS] isEqual:@"no more"];
}
+(void) setPolicyFlg{
    [DataCommon saveString:@"no more" inDir:DIR_SETTINGS withFileName:FILE_POLICY];
}

@end