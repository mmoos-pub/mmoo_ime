//
//  WebCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebCommon.h"
#import "LangCommon.h"

@implementation WebCommon

-(id) initWithTargetCode:(NSInteger)tc{
    targetCode = tc;
    return self;
}

-(NSInteger) getCatCnt{
    if(targetCode==TARGET_IME){
        return 7;
    }else if(targetCode==TARGET_TEXT){
        return 4;
    }else{
        return 0;
    }
}
-(NSInteger) getGenreCntInCat:(NSInteger)catCode{
    if(targetCode==TARGET_IME){
        switch (catCode) {
            case 0: return 2;
            case 1: return 5;
            case 2: return 6;
            case 3: return 7; 
            case 4: return 3;
            case 5: return 3;
            case 6: return 1;
            default: return 0;
        }
    }else if(targetCode==TARGET_TEXT){
        switch (catCode) {
            case 0: return 2;
            case 1: return 6;
            case 2: return 6;
            case 3: return 1;
            default: return 0;
        }
    }else{
        return 0;
    }
}

-(NSString*) getCat:(NSInteger)catCode{
    LangCommon *lc = [[LangCommon alloc] init];
    NSInteger langCode = [lc getLangCode];
    if(targetCode==TARGET_IME){
        if(langCode == LANG_JP){
            switch (catCode) {
                case 0: return @"便利";
                case 1: return @"感情";
                case 2: return @"会話";
                case 3: return @"行動"; 
                case 4: return @"イベント";
                case 5: return @"雰囲気";
                case 6: return @"その他";
                default: return @"";
            }
        }else{
            switch (catCode) {
                case 0: return @"UTILITY";
                case 1: return @"EMOTION";
                case 2: return @"CONVERSATION";
                case 3: return @"ACTION"; 
                case 4: return @"EVENTS";
                case 5: return @"MOOD";
                case 6: return @"ELSE";
                default: return @"";
            }
        }
    }else if(targetCode==TARGET_TEXT){
        if(langCode == LANG_JP){
            switch (catCode) {
                case 0: return @"世界共通";
                case 1: return @"英語";
                case 2: return @"日本語";
                case 3: return @"その他の言語";
                default: return @"";
            }
        }else{
            switch (catCode) {
                case 0: return @"UINIVERSAL";
                case 1: return @"ENGLISH";
                case 2: return @"JAPANESE";
                case 3: return @"OTHER LANGUAGES";
                default: return @"";
            }
        }
    }else{
        return @"";
    }
}
-(NSString*) getGenre:(NSInteger)genreCode inCat:(NSInteger)catCode type:(NSInteger)type{
    NSInteger langCode = [[[LangCommon alloc] init] getLangCode];
    if(targetCode==TARGET_IME){
        if(catCode==0){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"特殊文字";
                    }else{
                        return @"symbols";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"ライン";
                    }else{
                        return @"lines";
                    }
                default:
                    return @"";
            }
        }else if(catCode==1){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"うれしい／楽しい";
                    }else{
                        return @"happy";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"悲しい";
                    }else{
                        return @"sad";
                    }
                case 2:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"怒る";
                    }else{
                        return @"angry";
                    }
                case 3:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"驚く";
                    }else{
                        return @"shocked";
                    }
                case 4:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"照れる";
                    }else{
                        return @"embarrassed";
                    }
                default: return @"";
            }
        }else if(catCode==2){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"はい";
                    }else{
                        return @"yes";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"いいえ";
                    }else{
                        return @"no";
                    }
                case 2:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"呼ぶ";
                    }else{
                        return @"hey";
                    }
                case 3:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"あいさつ";
                    }else{
                        return @"greetings";
                    }
                case 4:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"ポジティブ";
                    }else{
                        return@"cheerful";
                    }
                case 5:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"ネガティブ";
                    }else{
                        return @"depressing";
                    } 
                default: return @"";
            }
        }else if(catCode==3){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"歩く／走る";
                    }else{
                        return @"walk/run";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"眠る";
                    }else{
                        return @"sleep";
                    }
                case 2:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"投げる";
                    }else{
                        return @"throw";
                    }
                case 3:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"ツッコム";
                    }else{
                        return @"hit";
                    }
                case 4:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"タバコ";
                    }else{
                        return @"smoke";
                    }
                case 5:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return  @"静止／ゆっくり";
                    }else{
                        return @"slow/calm";
                    }
                case 6:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return  @"速い／激しい";
                    }else{
                        return @"fast/restless";
                    }
                default: return @"";
            }
        }else if(catCode==4){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"冠婚葬祭";
                    }else{
                        return @"once in life";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"誕生日";
                    }else{
                        return @"birthday";
                    }
                case 2:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"季節の行事";
                    }else{
                        return @"seasonal";
                    }
                default: return @"";
            }
        }else if(catCode==5){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"かわいい";
                    }else{
                        return @"cute";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"かっこいい";
                    }else{
                        return @"cool";
                    }
                case 2:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"おもしろい";
                    }else{
                        return @"funny";
                    }
                default: return @"";
            }
        }else{
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"その他";
                    }else{
                        return @"else";
                    }
                    
                default: return @"";
            }
        }
    }else{
        if(catCode==0){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"アスキーアート";
                    }else if(type==GENRE_TYPE_STR){
                        return @"ASCII Arts";
                    }else{
                        return @"ascii";
                    }
                case 1:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return [NSString stringWithFormat:@"その他(%@)",[self getCat:0]];
                    }else if(type==GENRE_TYPE_STR){
                        return [NSString stringWithFormat:@"else(%@)",[self getCat:0]];
                    }else{
                        return @"else_universal";
                    }
                default: return @"";
            }
        }else if(catCode==1){
            switch (genreCode) {
                case 0:
                    if(type==GENRE_TYPE_STR){
                        return @"formal letter";
                    }else{
                        return @"formal_en";
                    }
                case 1:
                    if(type==GENRE_TYPE_STR){
                        return @"seasonal";
                    }else{
                        return @"seasonal_en";
                    }
                case 2:
                    if(type==GENRE_TYPE_STR){
                        return @"quote --wise";
                    }else{
                        return @"wise_en";
                    }
                case 3:
                    if(type==GENRE_TYPE_STR){
                        return @"quote --funny";
                    }else{
                        return @"funny_en";
                    }
                case 4:
                    if(type==GENRE_TYPE_STR){
                        return @"quote --horror";
                    }else{
                        return @"horror_en";
                    }
                case 5:
                    if(type==GENRE_TYPE_STR){
                        return @"else(ENGLISH)";
                    }else{
                        return @"else_en";
                    }
                default: return @"";
            }
        }else if(catCode==2){
            switch (genreCode) {
                case 0:
                    if(type==GENRE_TYPE_STR){
                        return @"ﾌｫｰﾏﾙ書式";
                    }else{
                        return @"formal_jp";
                    }
                case 1:
                    if(type==GENRE_TYPE_STR){
                        return @"季節の挨拶";
                    }else{
                        return @"seasonal_jp";
                    }
                case 2:
                    if(type==GENRE_TYPE_STR){
                        return @"名言";
                    }else{
                        return @"wise_jp";
                    }
                case 3:
                    if(type==GENRE_TYPE_STR){
                        return @"面白いハナシ";
                    }else{
                        return @"funny_jp";
                    }
                case 4:
                    if(type==GENRE_TYPE_STR){
                        return @"怖いハナシ";
                    }else{
                        return @"horror_jp";
                    }
                case 5:
                    if(type==GENRE_TYPE_STR){
                        return @"その他(日本語)";
                    }else{
                        return @"else_jp";
                    }
                default: return @"";
            }
        }else if(catCode==3){
            switch (genreCode) {
                case 0:
                    if(langCode==LANG_JP && type==GENRE_TYPE_STR){
                        return @"なんでも";
                    }else if(type==GENRE_TYPE_STR){
                        return @"miscellaneous";
                    }else{
                        return @"other_miscellaneous";
                    }
                default: return @"";
            }
        }else{
            return @"";
        }
    }
}
-(NSString*) convertGenre:(NSString*)genreKey{
    for(NSInteger i=0; i<[self getCatCnt]; i++){
        for(NSInteger j=0; j<[self getGenreCntInCat:i]; j++){
            if( [[self getGenre:j inCat:i type:GENRE_TYPE_KEY] isEqualToString:genreKey] ){
                return [self getGenre:j inCat:i type:GENRE_TYPE_STR];
            }
        }
    }
    return @"";
}

+(NSMutableURLRequest*) getReq:(NSString*)str{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mmooime.appspot.com/%@",str]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [req setTimeoutInterval:30];
    return req;
}

@end
