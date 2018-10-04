//
//  TextEditViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/17.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"
#import "KeyboardSubView.h"

#define KBD_CUSTOM 0
#define KBD_NORMAL 1

#define ACTION_MAIL 0
#define ACTION_SMS 1
#define ACTION_FACEBOOK 2

#define RESP_TEXT 0
#define RESP_TITLE 1

@interface TextEditViewController : ViewControllerCommon<UITextViewDelegate,KeyboardSubViewDelegate>{
    NSString *textID;
    NSInteger targetTabIdx;
    NSInteger kbd_type;
    NSInteger resp;
    NSNotification *note;

    UILabel *itemCntLabel;
    UITextView *itemContentText;
    
    KeyboardSubView *ksv;
    UIView *itemAccessoryView;
    UIButton *itemChgButton;
    UIButton *itemPasteButton;
    UIButton *itemDeleteButton;
    UIButton *itemReturnButton;
    
    UIView *itemSaveSubView;
    UIView *itemSaveTitleView;
    UIView *itemSaveButtonsView;
    UILabel *itemTitleLabel;
    UITextField *itemTitleText;
    UIButton *itemSaveButton;
    UIButton *itemCancelButton;
    
    UIView *itemCopiedSubView;
    UILabel *itemCopiedLabel;
    UIButton *itemOkButton;
    UIButton *itemBtnMail;
    UIButton *itemBtnSMS;
    UIButton *itemBtnFacebook;
}

-(id) initWithTextID:(NSString*)requestID;
-(void) setNavTitle;
-(void) showCnt;
-(void) saveCancel;
-(void) copiedOk;
-(void) hideResponder;
-(void) showResponder;
-(void) resizeContentText;

@end