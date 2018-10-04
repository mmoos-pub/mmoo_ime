//
//  LangCommon.h
//  MmooKeyboardHyper
//
//  Created by 透子 桃井 on 12/01/28.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LANG_EN 0
#define LANG_JP 1

#define TRNS_YES 11
#define TRNS_NO 12
#define TRNS_SAVE 13
#define TRNS_EDIT 14
#define TRNS_DELETE 15
#define TRNS_CANCEL 16
#define TRNS_CHANGE 17

#define TRNS_COPY_TO_CLIPBOARD 21
#define TRNS_COPIED 22

#define TRNS_TXT_LIST_NAV_TITLE 31
#define TRNS_TXT_NO_TITLE 32
#define TRNS_TXT_NEW_TITLE 33
#define TRNS_TXT_TITLE 34
#define TRNS_TXT_TITLE_PLACEFOLDER 35
#define TRNS_TXT_SAVE 36

#define TRNS_SETTINGS_NAV_TITLE 41
#define TRNS_SETTINGS_LABEL_LANG 42
#define TRNS_SETTINGS_LABEL_CLR 43

#define TRNS_KBD_TITLE 51
#define TRNS_KBD_INSERT_LEFT 52
#define TRNS_KBD_INSERT_RIGHT 53
#define TRNS_KBD_MOVE_LEFT 54
#define TRNS_KBD_MOVE_RIGHT 55
#define TRNS_KBD_CANCEL 56
#define TRNS_KBD_SURE 57

#define TRNS_WEB_TITLE 61
#define TRNS_WEB_UPLOAD_IME 62
#define TRNS_WEB_UPLOAD_TEXT 63
#define TRNS_WEB_DOWNLOAD_IME 64
#define TRNS_WEB_DOWNLOAD_TEXT 65

#define TRNS_POLICY_TITLE 71
#define TRNS_POLICY_CONTENT 72
#define TRNS_POLICY_AGREE 73
#define TRNS_POLICY_DONT 74
#define TRNS_POLICY_NEVER_SHOW 75

#define TRNS_MAIL 81
#define TRNS_MAIL_TEXT 82
#define TRNS_MAIL_SEND 83

#define TRNS_UI_TITLE 101
#define TRNS_UT_TITLE 102
#define TRNS_DI_TITLE 103
#define TRNS_DT_TITLE 104
#define TRNS_UD_GENRE 111
#define TRNS_UD_FAILED 112
#define TRNS_UD_RETRY 113
#define TRNS_D_GENRE_ALL 121
#define TRNS_D_SORT 122
#define TRNS_D_SORT_DATE 123
#define TRNS_D_SORT_POP 124
#define TRNS_D_NO_ITEM 125
#define TRNS_D_DOWNLOAD 126
#define TRNS_D_DONE 127
#define TRNS_D_MORE 128
#define TRNS_U_SELECT 131
#define TRNS_U_NO_ITEM 132
#define TRNS_U_GENRE_SELECT 133
#define TRNS_U_GENRE_NONE 134
#define TRNS_U_SUCCESS 135
#define TRNS_U_EMPTY 136

@interface LangCommon : NSObject{
    NSInteger langCode;
}

+(NSArray*) getAllLanguage;
-(NSString*) getTranslated:(NSInteger)textCode;
-(NSInteger) getLangCode;

@end
