//
//  WebMenuController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/24.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebMenuController.h"
#import "WebUploadListViewController.h"
#import "WebDownloadListViewController.h"
#import "DataSettings.h"

@implementation WebMenuController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    itemUiButton = [[UIButton alloc] init];
    itemUtButton = [[UIButton alloc] init];
    itemDiButton = [[UIButton alloc] init];
    itemDtButton = [[UIButton alloc] init];
    
    [((UILabel*)itemUiButton) setLineBreakMode:NSLineBreakByWordWrapping];
    [((UILabel*)itemUtButton) setLineBreakMode:NSLineBreakByWordWrapping];
    [((UILabel*)itemDiButton) setLineBreakMode:NSLineBreakByWordWrapping];
    [((UILabel*)itemDiButton) setLineBreakMode:NSLineBreakByWordWrapping];
        
    [itemUiButton addTarget:self 
       action:@selector(uploadIme) 
       forControlEvents:UIControlEventTouchUpInside];
    [itemUtButton addTarget:self 
        action:@selector(uploadText)  
        forControlEvents:UIControlEventTouchUpInside];
    [itemDiButton addTarget:self 
        action:@selector(downloadIme) 
        forControlEvents:UIControlEventTouchUpInside];
    [itemDtButton addTarget:self 
        action:@selector(downloadText) 
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:itemUiButton];
    [self.view addSubview:itemUtButton];
    [self.view addSubview:itemDiButton];
    [self.view addSubview:itemDtButton];
    
    policyView = [[UIView alloc] init];
    policyTitleLabel = [[UILabel alloc] init];
    policyContentText = [[UITextView alloc] init];
    policyAgreeButton = [[UIButton alloc] init];
    policyDontButton = [[UIButton alloc] init];
    policyAgreeAndNeverButton = [[UIButton alloc] init];
    
    policyContentText.editable = NO;
    [policyAgreeButton addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    [policyAgreeAndNeverButton addTarget:self action:@selector(neverShow) forControlEvents:UIControlEventTouchUpInside];
    [policyDontButton addTarget:self action:@selector(dont) forControlEvents:UIControlEventTouchUpInside];
    
    [policyView addSubview:policyTitleLabel];
    [policyView addSubview:policyContentText];
    [policyView addSubview:policyAgreeButton];
    [policyView addSubview:policyAgreeAndNeverButton];
    [policyView addSubview:policyDontButton];
}
-(void) setAppearance{
    [ac setNavTitle:[lc getTranslated:TRNS_WEB_TITLE]];
    [ac setLabel:policyTitleLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_POLICY_TITLE] font:FONT_NORMAL];
    [ac setTextView:policyContentText text:[lc getTranslated:TRNS_POLICY_CONTENT] type:TEXT_SQUARE];
    [ac setButton:policyAgreeButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_POLICY_AGREE] imgName:nil];
    [ac setButton:policyAgreeAndNeverButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_POLICY_NEVER_SHOW] imgName:nil];
    [ac setButton:policyDontButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_POLICY_DONT] imgName:nil];
}
-(void) setItemPosition{
    CGFloat w = [ac getW];
    CGFloat h;
    h = ([ac getH] - [ac getMargin:MARGIN_NORMAL]*5) / 4;
    
    if( h>0 ){
        [ac setButton:itemUiButton 
              type:BUTTON_TYPE_RICH
              title:[lc getTranslated:TRNS_WEB_UPLOAD_IME] 
              imgName:@"upload_keyboard.png"
              w:w*7/10
              h:h
        ];
        [ac setButton:itemUtButton
              type:BUTTON_TYPE_RICH
              title:[lc getTranslated:TRNS_WEB_UPLOAD_TEXT] 
              imgName:@"upload_text.png"
              w:w*7/10
              h:h
        ];
        [ac setButton:itemDiButton 
              type:BUTTON_TYPE_RICH
              title:[lc getTranslated:TRNS_WEB_DOWNLOAD_IME] 
              imgName:@"download_keyboard.png"
              w:w*7/10
              h:h
        ];
        [ac setButton:itemDtButton
              type:BUTTON_TYPE_RICH
              title:[lc getTranslated:TRNS_WEB_DOWNLOAD_TEXT] 
              imgName:@"download_text.png"
              w:w*7/10
              h:h
        ];
        
        [ac setX:itemUiButton xMargin:MARGIN_NORMAL];
        [ac setX:itemDiButton xMargin:MARGIN_NORMAL];
        [ac setX:itemUtButton xRightMargin:MARGIN_NORMAL of:self.view];
        [ac setX:itemDtButton xRightMargin:MARGIN_NORMAL of:self.view];
        [ac setY:itemUiButton yMargin:MARGIN_NORMAL];
        [ac setY:itemUtButton under:itemUiButton withMargin:MARGIN_NORMAL];
        [ac setY:itemDiButton under:itemUtButton withMargin:MARGIN_NORMAL];
        [ac setY:itemDtButton under:itemDiButton withMargin:MARGIN_NORMAL];
    }

    NSInteger margin = [ac isShort] ? MARGIN_SMALL : MARGIN_NORMAL;
    CGFloat extra = [ac isSlim] ? [ac getButtonSize:BUTTON_SIZE_NORMAL]+[ac getMargin:MARGIN_NORMAL] : 0;
    [ac resizeObject:policyContentText 
        w:[ac getW] - [ac getMargin:MARGIN_SMALL]*2 - [ac getMargin:MARGIN_NORMAL]*2 
        h:[ac getH] - policyTitleLabel.frame.size.height - [ac getButtonSize:BUTTON_SIZE_NORMAL]*2 - [ac getMargin:MARGIN_SMALL]*3 - [ac getMargin:margin]*4 - extra
    ];
    [ac setY:policyTitleLabel yMargin:margin];
    [ac setY:policyContentText under:policyTitleLabel withMargin:MARGIN_SMALL];
    [ac setY:policyAgreeButton under:policyContentText withMargin:margin];
    [ac setY:policyAgreeAndNeverButton under:policyAgreeButton withMargin:margin];
    if( [ac isSlim] ){
        [ac setY:policyDontButton under:policyAgreeAndNeverButton withMargin:MARGIN_NORMAL];
    }else{
        [ac setY:policyDontButton nextTo:policyAgreeButton];
    }
    [ac setSubView:policyView type:SUBVIEW_SQUARE xPadding:MARGIN_NORMAL yPadding:margin];
    [ac setY:policyView yMargin:MARGIN_SMALL];
    [ac setX:policyTitleLabel centerOf:policyView];
    [ac setX:policyContentText centerOf:policyView];
    [ac setX:policyAgreeButton xMargin:MARGIN_NORMAL];
    [ac setX:policyAgreeAndNeverButton xMargin:MARGIN_NORMAL];
    if( [ac isSlim] ){
        [ac setX:policyDontButton xMargin:MARGIN_NORMAL];
    }else{
        [ac setX:policyDontButton xRightMargin:MARGIN_NORMAL of:policyView];
    }
}

#pragma mark - specific
-(void) showPolicyAction:(NSInteger)a target:(NSInteger)t{
    actionCode = a;
    targetCode = t;
    if( [DataSettings getPolicyFlg]==NO ){
        [ac fade:policyView into:self.view];
    }else{
        [self goAct];
    }
}
-(void) neverShow{
    [DataSettings setPolicyFlg];
    [policyView removeFromSuperview];
    [self goAct];
}
-(void) goAct{
    UIViewController *nextVC;
    if(actionCode==ACTION_UPLOAD){
        nextVC = [[WebUploadListViewController alloc] initWithTargetCode:targetCode];
    }else{
        nextVC = [[WebDownloadListViewController alloc] initWithTargetCode:targetCode];
    }
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - selectors
-(void) uploadIme{
    [self showPolicyAction:ACTION_UPLOAD target:TARGET_IME];
}
-(void) uploadText{
    [self showPolicyAction:ACTION_UPLOAD target:TARGET_TEXT];
}
-(void) downloadIme{
    [self showPolicyAction:ACTION_DOWNLOAD target:TARGET_IME];
}
-(void) downloadText{
    [self showPolicyAction:ACTION_DOWNLOAD target:TARGET_TEXT];
}

-(void) agree{
    [policyView removeFromSuperview];
    [self goAct];
}
-(void) dont{
    [policyView removeFromSuperview];
}

@end