//
//  DataKeyboard.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/26.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIR_TABS @"ktab"
#define DIR_TXTS @"ktxt"
#define DIR_ALL @"k"
#define FILE_ALL_TABS @"alltabs"
#define DIR_TMP @"tmp"
#define FILE_TMP @"tmp"
#define FILE_TAB_IDX @"idx"
#define FILE_KEYBOARD_TYPE @"type"

@interface DataKeyboard : NSObject

+(NSString*) getNewTabID;

+(NSArray*) getAllTabID;
+(NSArray*) getAllTabTitles;
+(NSString*) getTabIDbyIndex:(NSInteger)tabIndex;
+(NSArray*) getTxtsByTabID:(NSString*)tabID;
+(NSArray*) getTxtsByTabIndex:(NSInteger)tabIndex;
+(NSString*) getRawTxtsByTabIndex:(NSInteger)tabIndex;
+(NSArray*) getTmpTxts;
+(NSInteger) getLastUsedTabIdx;
+(NSInteger) getLastUsedKeyboardType;

+(void) saveAllTabID:(NSArray*)tabIDs;
+(void) saveTabTitle:(NSString*)tabTitle withTabID:(NSString*)tabID;
+(void) saveTabTitle:(NSString *)tabTitle withTabIdx:(NSInteger)tabIdx;
+(void) saveTxts:(NSArray*)txts withTabID:(NSString*)tabID;
+(void) saveTxts:(NSArray*)txts withTabIdx:(NSInteger)tabIdx;
+(void) saveTmpTxts:(NSString*)tmp;
+(void) saveLastUsedTabIdx:(NSInteger)tabIdx;
+(void) saveLastUsedKeyboardType:(NSInteger)type;

+(void) deleteTabDataByID:(NSString*)tabID;
+(void) deleteTabDataByIndex:(NSInteger)tabIndex;

@end
