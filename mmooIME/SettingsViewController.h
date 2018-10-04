//
//  SettingsViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/22.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"

@interface SettingsViewController : ViewControllerCommon{
    UILabel *itemLabelLang;
    UILabel *itemLabelClr;
    UISegmentedControl *itemSegLang;
    UISegmentedControl *itemSegClr;
    
    UIButton *itemBtnPolicy;
    UIView *policyView;
    UILabel *policyTitleLabel;
    UITextView *policyContentText;
    UIButton *policyCloseBtn;
    
    UIButton *itemBtnMail;
    UIView *mailView;
    UITextView *mailText;
    UIButton *mailOkBtn;
    UIButton *mailCancelBtn;
}

-(void) setAppearance;
-(void) setItemPosition;

@end
