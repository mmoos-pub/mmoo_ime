//
//  KeyboardSubView.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/02/09.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppearanceCommon.h"

#define TYPE_AS_IME 0
#define TYPE_TO_EDIT 1
#define TYPE_WITH_TMP 2

#define TARGET_TAB 0
#define TARGET_TXT 1

@protocol KeyboardSubViewDelegate <NSObject>
-(void) tabSelected:(UIButton*)sender;
-(void) txtSelected:(UIButton*)sender;
@end

@interface KeyboardSubView : UIView{
    AppearanceCommon *ac;
    
    NSMutableArray *tabButtons;
    NSMutableArray *tabRows;
    NSMutableArray *txtButtons;
    NSMutableArray *txtRows;
    
    UIView *tabs;
    UIButton *tabLeft;
    UIButton *tabRight;
    UIView *txts;
    UIPageControl *paging;    
}

@property (unsafe_unretained, nonatomic) id <KeyboardSubViewDelegate> delegate;
@property (assign) NSInteger tabPage;
@property (assign) NSInteger tabIdx;
@property (assign) NSInteger txtPage;
@property (assign) NSInteger subViewType;

-(id) initWithType:(NSInteger)type superVC:(UIViewController*)vc;
-(NSInteger) setTab:(NSInteger)idx;

-(void) setTabButtons;
-(void) setTxtButtons;

-(void) setTabAppearence;
-(void) setTxtAppearence;
-(void) setWholeAppearence;

-(void) setHighLightTab:(NSInteger)idx;
-(void) removeHighLightTab:(NSInteger)idx;
-(void) setHighLightTxt:(NSInteger)idx;
-(void) removeHighLightTxt:(NSInteger)idx;
-(CGFloat) getTabRowW;

@end