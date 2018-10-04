//
//  DataKeyboard.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/26.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "DataKeyboard.h"
#import "DataCommon.h"

@implementation DataKeyboard

+(NSString*) getNewTabID{
    return [DataCommon getNewFileNameInDir:DIR_TABS];
}

+(NSArray*) getAllTabID{
    NSArray *savedTabID = [DataCommon getSavedArrayByFileName:FILE_ALL_TABS inDir:DIR_ALL];
    if(savedTabID==nil){
        NSString *newID1 = [self getNewTabID];
        [self saveAllTabID:[NSArray arrayWithObjects:newID1,nil]];
        [self saveTabTitle:@":)" withTabID:newID1];
        NSArray *defaultTxts1 = [NSArray arrayWithObjects:
                @":)",@":-)",@"=)",@":D",@":^D",@"xD",@";)",@":-(",@":-/",@":-o",@">:(",@":P",@"xP",                 
                @"(^-^)",@"^_^",@"(o^-^o)",@"(^▽^)",@"(*^▽^*)",@"(＠°▽°＠)",@"^0^",
                @"(´▽｀)",@"(-_-)",@"(:_;)",@"(T0T)",@"(>_<)",@"(`ロ´)",@"m(__)m",@"(._.)",
                nil];
        [self saveTxts:defaultTxts1 withTabID:newID1];
        NSString *newID2 = [self getNewTabID];
        [self saveAllTabID:[NSArray arrayWithObjects:newID1,newID2,nil]];
        [self saveTabTitle:@"frequent" withTabID:newID2];
        NSArray *defaultTxts2 = [NSArray arrayWithObjects:
                 @"how r u?",@"where r u?",@"brb",@"in no time",@"for sure",             
                 @"help!!",@"SOS",@"c ya",@"love ya",@"I love you.",@"I hate you.",
                 @"thank you",@"sorry",
                 nil];
        [self saveTxts:defaultTxts2 withTabID:newID2];
    }
    return savedTabID;
}
+(NSArray*) getAllTabTitles{
    NSMutableArray *tabTitles = [NSMutableArray array];
    for(NSString *tabID in [self getAllTabID]){
        [tabTitles addObject:[DataCommon getSavedStringByFileName:tabID inDir:DIR_TABS]];
    }
    return tabTitles;
}
+(NSString*) getTabIDbyIndex:(NSInteger)tabIndex{
    return [[self getAllTabID]objectAtIndex:tabIndex];
}
+(NSArray*) getTxtsByTabID:(NSString*)tabID{
    return [DataCommon getSavedArrayByFileName:tabID inDir:DIR_TXTS];
}
+(NSArray*) getTxtsByTabIndex:(NSInteger)tabIndex{
    return [self getTxtsByTabID:[self getTabIDbyIndex:tabIndex]];
}
+(NSString*) getRawTxtsByTabIndex:(NSInteger)tabIndex{
    return [DataCommon getSavedStringByFileName:[self getTabIDbyIndex:tabIndex] inDir:DIR_TXTS];
}
+(NSArray*) getTmpTxts{
    return [DataCommon getSavedArrayByFileName:FILE_TMP inDir:DIR_TMP];
}
+(NSInteger) getLastUsedTabIdx{
    return [[DataCommon getSavedStringByFileName:FILE_TAB_IDX inDir:DIR_TMP] intValue];
}
+(NSInteger) getLastUsedKeyboardType{
    return [[DataCommon getSavedStringByFileName:FILE_KEYBOARD_TYPE inDir:DIR_TMP] intValue];
}

+(void) saveAllTabID:(NSArray*)tabIDs{
    [DataCommon saveArray:tabIDs inDir:DIR_ALL fileName:FILE_ALL_TABS];
}
+(void) saveTabTitle:(NSString*)tabTitle withTabID:(NSString*)tabID{
    [DataCommon saveString:tabTitle inDir:DIR_TABS withFileName:tabID];
}
+(void) saveTabTitle:(NSString *)tabTitle withTabIdx:(NSInteger)tabIdx{
    [self saveTabTitle:tabTitle withTabID:[self getTabIDbyIndex:tabIdx]];
}
+(void) saveTxts:(NSArray*)txts withTabID:(NSString*)tabID{
    [DataCommon saveArray:txts inDir:DIR_TXTS fileName:tabID];
}
+(void) saveTxts:(NSArray *)txts withTabIdx:(NSInteger)tabIdx{
    [self saveTxts:txts withTabID:[self getTabIDbyIndex:tabIdx]];
}
+(void) saveTmpTxts:(NSString*)tmp{
    [DataCommon saveString:tmp inDir:DIR_TMP withFileName:FILE_TMP];
}
+(void) saveLastUsedTabIdx:(NSInteger)tabIdx{
    [DataCommon saveString:[NSString stringWithFormat:@"%zd",tabIdx] inDir:DIR_TMP withFileName:FILE_TAB_IDX];
}
+(void) saveLastUsedKeyboardType:(NSInteger)type{
    [DataCommon saveString:[NSString stringWithFormat:@"%zd",type] inDir:DIR_TMP withFileName:FILE_KEYBOARD_TYPE];
}

+(void) deleteTabDataByID:(NSString*)tabID{
    [DataCommon deleteDatumByFileName:tabID inDir:DIR_TABS];
    [DataCommon deleteDatumByFileName:tabID inDir:DIR_TXTS];
}
+(void) deleteTabDataByIndex:(NSInteger)tabIndex{
    [self deleteTabDataByID:[self getTabIDbyIndex:tabIndex]];
}

@end
