//
//  WebUploadViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/27.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"
#import "WebGenreSubView.h"
#import "KeyboardSubView.h"

#define RESULT_SUCCESS 1
#define RESULT_FAILED 2

@interface WebUploadViewController : ViewControllerCommon<WebGenreSubViewDelegate>{
    NSInteger targetCode;
    NSInteger targetIdx;
    Boolean doneFlg;
    Boolean isEmpty;
    NSString *genreKey;
    NSString *genreStr;
    NSString *targetTitle;
    
    UIActivityIndicatorView  *ai;
    NSMutableData *receivedData;
    
    WebGenreSubView *gv;
    KeyboardSubView *uploadKsv;
    UITextView *uploadText;
    UILabel *itemLabelGenre;
    UIButton *itemBtnGenreChange;
    UIView *itemButtons;
    UIButton *itemBtnOk;
    UIButton *itemBtnCancel;
    UILabel *itemLblEmpty;
    UILabel *itemResultLabel;
    UIButton *itemBtnRetry;
}

-(id) initWithTargetCode:(NSInteger)code andIndex:(NSInteger)idx;
-(void) setGenre;
-(void) showGenre;
-(void) showResult:(NSInteger)resultFlg;
-(void) popBackSimple;
-(void) popBackTopIfDone;
@end