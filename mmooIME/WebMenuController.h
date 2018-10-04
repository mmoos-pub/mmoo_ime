//
//  WebMenuController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/24.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"

@interface WebMenuController : ViewControllerCommon{    
    NSInteger actionCode;
    NSInteger targetCode;
    
    UIButton *itemUiButton;
    UIButton *itemUtButton;
    UIButton *itemDiButton;
    UIButton *itemDtButton;
    
    UIView *policyView;
    UILabel *policyTitleLabel;
    UITextView *policyContentText;
    UIButton *policyAgreeButton;
    UIButton *policyDontButton;
    UIButton *policyAgreeAndNeverButton;    
}

-(void) showPolicyAction:(NSInteger)a target:(NSInteger)t;
-(void) neverShow;
-(void) goAct;

@end
