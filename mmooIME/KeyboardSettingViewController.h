//
//  KeyboardSettingViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/29.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"
#import "KeyboardSubView.h"

#define ACTION_DELETE 1
#define ACTION_EDIT 2
#define ACTION_INSERT_LEFT 3
#define ACTION_INSERT_RIGHT 4
#define ACTION_MOVE_LEFT 5
#define ACTION_MOVE_RIGHT 6
#define ACTION_CANCEL 7

@interface KeyboardSettingViewController:ViewControllerCommon<KeyboardSubViewDelegate>{    
    NSInteger targetCode;
    NSInteger actionCode;
    NSInteger targetTabIdx;
    NSInteger targetTxtIdx;
    NSArray *tabIDs;
    
    KeyboardSubView *ksv;
    
    UIView *actionBtnView;
    UIButton *actionBtnDelete;
    UIButton *actionBtnEdit;
    UIButton *actionBtnInsertLeft;
    UIButton *actionBtnInsertRight;
    UIButton *actionBtnMoveLeft;
    UIButton *actionBtnMoveRight;
    UIButton *actionBtnCancel;
    
    UIView *itemExecuteActionView;
    UIView *itemExecuteButtonsView;
    UITextField *itemText;
    UIButton *itemOkButton;
    UIButton *itemCancelButton;
    
    UIView *itemConfirmView;
    UIView *itemConfirmButtonsView;
    UILabel *itemConfirmLabel;
    UIButton *itemYesButton;
    UIButton *itemNoButton;
}

-(void) setConfirmSub;
-(void) setActSub;
-(void) setActionBtnsSub;
-(void) actReset;

@end
