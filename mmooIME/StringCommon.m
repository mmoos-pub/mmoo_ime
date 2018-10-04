//
//  StringCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "StringCommon.h"

@implementation StringCommon

+(NSInteger) getLen:(NSString*)str{
    NSInteger count = 0;
    for(NSInteger i=0; i<str.length; i++){
        unichar c = [str characterAtIndex:i];
        
        if (0xD83C == c) {
            unichar c1 = [str characterAtIndex:i+1];
            if ((0xDDE6 <= c1) && (c1 <= 0xDDFF)) {
                unichar c2 = [str characterAtIndex:i+2];
                if (0xD83C == c2) {
                    unichar c3 = [str characterAtIndex:i+3];
                    if ((0xDDE6 <= c3) && (c3 <= 0xDDFF)) { 
                        // 国旗
                        i += 3;
                        ++count;
                        continue;
                    }
                }
            }
            i++;
            ++count;
        }else if (0xD800 <= c && c <= 0xDBFF) { 
            // 上位サロゲート
            i++;
            ++count;
        }else if (0xDC00 <= c && c <= 0xDFFF) { 
            // 下位サロゲートなので念のため無視
        }else if (0x20E3 == c) {
            // 囲みなので無視・・・
        }else {
            ++count;
        }
    }
    return count;
}

+(NSString*) getSub:(NSString*)str to:(NSInteger)to{
    to--;
    NSString *sub = @"";
    NSString *nextLetter;
    
    for(NSInteger i=0; i<str.length; i++){
        unichar c = [str characterAtIndex:i];
        if (0xD83C == c) {
            unichar c1 = [str characterAtIndex:i+1];
            if ((0xDDE6 <= c1) && (c1 <= 0xDDFF)) {
                unichar c2 = [str characterAtIndex:i+2];
                if (0xD83C == c2) {
                    unichar c3 = [str characterAtIndex:i+3];
                    if ((0xDDE6 <= c3) && (c3 <= 0xDDFF)) { 
                        // 国旗
                        i += 3;
                        if(i>=to){ return sub; }
                        unichar chr[4] = {c,c1,c2,c3};
                        nextLetter = [NSString stringWithCharacters:chr length:4];
                        sub = [sub stringByAppendingString:nextLetter];
                        continue;
                    }
                }
            }
            i++;
            if(i>=to){ return sub; }
            unichar chr[2] = {c,c1};
            nextLetter = [NSString stringWithCharacters:chr length:2];
            sub = [sub stringByAppendingString:nextLetter];
        }else if (0xD800 <= c && c <= 0xDBFF) {
            // 上位サロゲート
            unichar c1 = [str characterAtIndex:i+1];
            i++;
            if(i>=to){ return sub; }
            unichar chr[2] = {c,c1};
            nextLetter = [NSString stringWithCharacters:chr length:2];
            sub = [sub stringByAppendingString:nextLetter];
        }else if (0xDC00 <= c && c <= 0xDFFF) { 
            // 下位サロゲートなので念のため無視
        }else if (0x20E3 == c) {
            // 囲みなので無視・・・
        }else {
            if(i>=to){ return sub; }
            unichar chr[1] = {c};
            nextLetter = [NSString stringWithCharacters:chr length:1];
            sub = [sub stringByAppendingString:nextLetter];
        }
    }
    return sub;
}
+(NSString*) getSub:(NSString *)str from:(NSInteger)from{
    NSString *sub = @"";
    NSString *nextLetter;
    
    for(NSInteger i=0; i<str.length; i++){
        unichar c = [str characterAtIndex:i];
        
        if (0xD83C == c) {
            unichar c1 = [str characterAtIndex:i+1];
            if ((0xDDE6 <= c1) && (c1 <= 0xDDFF)) {
                unichar c2 = [str characterAtIndex:i+2];
                if (0xD83C == c2) {
                    unichar c3 = [str characterAtIndex:i+3];
                    if ((0xDDE6 <= c3) && (c3 <= 0xDDFF)) { 
                        // 国旗
                        if(i>=from){
                            unichar chr[4] = {c,c1,c2,c3};
                            nextLetter = [NSString stringWithCharacters:chr length:4];
                            sub = [sub stringByAppendingString:nextLetter];
                        }
                        i += 3;
                        continue;
                    }
                }
            }
            if(i>=from){ 
                unichar chr[2] = {c,c1};
                nextLetter = [NSString stringWithCharacters:chr length:2];
                sub = [sub stringByAppendingString:nextLetter];
            }
            i++;
        }else if (0xD800 <= c && c <= 0xDBFF) { 
            // 上位サロゲート
            if(i>=from){
                unichar c1 = [str characterAtIndex:i+1];
                unichar chr[2] = {c,c1};
                nextLetter = [NSString stringWithCharacters:chr length:2];
                sub = [sub stringByAppendingString:nextLetter];
            }
            i++;
        }else if (0xDC00 <= c && c <= 0xDFFF) { 
            // 下位サロゲートなので念のため無視
        }else if (0x20E3 == c) {
            // 囲みなので無視・・・
        }else {
            if(i>=from){ 
                unichar chr[1] = {c};
                nextLetter = [NSString stringWithCharacters:chr length:1];
                sub = [sub stringByAppendingString:nextLetter];
            }
        }
    }
    return sub;
}

+(NSString*) urlEncode:(NSString *)str{
    return  (__bridge_transfer NSString * ) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]~", kCFStringEncodingUTF8);
}

+(NSInteger) getWordCnt:(NSString*)str{
    NSInteger cnt = 0;
    NSString *chk = [NSString stringWithString:str];
    BOOL prevContent = NO;
    
    while(chk.length>0){        
        if( [[self getSub:chk to:2] isEqualToString:@" "] ){
            prevContent = NO;
        }else if( [[self getSub:chk to:2] isEqualToString:@"\n"] ){
            prevContent = NO;
        }else{
            if( !prevContent ){
                cnt++;
            }
            prevContent = YES;
        }
        chk = [self getSub:chk from:1];
    }
    return cnt;
}
@end
