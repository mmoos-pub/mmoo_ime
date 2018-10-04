//
//  SettingsViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/20.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "SettingsViewController.h"
#import "ColorCommon.h"
#import "DataSettings.h"

@implementation SettingsViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    itemLabelLang = [[UILabel alloc] init];
    itemSegLang = [[UISegmentedControl alloc] initWithItems:[LangCommon getAllLanguage]];
    [itemSegLang addTarget:self action:@selector(chgLang) forControlEvents:UIControlEventValueChanged];
    itemLabelClr = [[UILabel alloc] init];
    NSArray *allColor = [ColorCommon getAllColor];
    NSArray *allUIColor = [ColorCommon getAllUIColor];
    itemSegClr = [[UISegmentedControl alloc] initWithItems:allColor];
    [itemSegClr setBackgroundColor:[UIColor whiteColor]];
    for(NSInteger i=0; i<allColor.count; i++){
        [itemSegClr setImage:[allColor objectAtIndex:i] forSegmentAtIndex:i];
        [[[itemSegClr subviews] objectAtIndex:i] setTintColor:[allUIColor objectAtIndex:i]];
    }
    [itemSegClr addTarget:self action:@selector(chgClr) forControlEvents:UIControlEventValueChanged];
    itemBtnPolicy = [[UIButton alloc] init];
    [itemBtnPolicy addTarget:self action:@selector(readPolicy) forControlEvents:UIControlEventTouchUpInside];
    itemBtnMail = [[UIButton alloc] init];
    [itemBtnMail addTarget:self action:@selector(showMailSub) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:itemLabelLang];
    [self.view addSubview:itemLabelClr];
    [self.view addSubview:itemSegLang];
    [self.view addSubview:itemSegClr];
    [self.view addSubview:itemBtnPolicy];
    //[self.view addSubview:itemBtnMail];
    
    policyView = [[UIView alloc] init];
    policyTitleLabel = [[UILabel alloc] init];;
    policyContentText = [[UITextView alloc] init];    
    policyCloseBtn = [[UIButton alloc] init];
    policyContentText.editable = NO;
    [policyCloseBtn addTarget:self action:@selector(closePolicy) forControlEvents:UIControlEventTouchDown];
    [policyView addSubview:policyTitleLabel];
    [policyView addSubview:policyContentText];
    [policyView addSubview:policyCloseBtn];
    
    mailView = [[UIView alloc] init];
    mailText = [[UITextView alloc] init];
    mailOkBtn = [[UIButton alloc] init];
    mailCancelBtn = [[UIButton alloc] init];
    [mailOkBtn addTarget:self action:@selector(goSendMail) forControlEvents:UIControlEventTouchUpInside];
    [mailCancelBtn addTarget:self action:@selector(mailCancel) forControlEvents:UIControlEventTouchUpInside];
    [mailView addSubview:mailText];
    [mailView addSubview:mailOkBtn];
    [mailView addSubview:mailCancelBtn];
}
-(void) setAppearance{
    [ac setNavTitle:[lc getTranslated:TRNS_SETTINGS_NAV_TITLE]];
    
    [itemSegLang setSelectedSegmentIndex:[DataSettings getLanguage]];
    [itemSegClr setSelectedSegmentIndex:[DataSettings getColor]];    
    [ac setLabel:itemLabelLang type:LABEL_CONTENT text:[lc getTranslated:TRNS_SETTINGS_LABEL_LANG] font:FONT_NORMAL];
    [ac setLabel:itemLabelClr type:LABEL_CONTENT text:[lc getTranslated:TRNS_SETTINGS_LABEL_CLR] font:FONT_NORMAL];
    [ac setSeg:itemSegLang];
    for(NSInteger i=0; i<itemSegClr.numberOfSegments; i++){
        [itemSegClr setWidth:[ac getButtonSize:BUTTON_SIZE_NORMAL] forSegmentAtIndex:i];
    }
    [ac setButton:itemBtnPolicy type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_POLICY_TITLE] imgName:@"96-book.png"];
    [ac setButton:itemBtnMail type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_MAIL] imgName:@"18-envelope.png"];
    
    [ac setLabel:policyTitleLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_POLICY_TITLE] font:FONT_LARGE];
    [ac setTextView:policyContentText text:[lc getTranslated:TRNS_POLICY_CONTENT] type:TEXT_SQUARE];
    [ac setButton:policyCloseBtn type:BUTTON_TYPE_CUSTOM title:@"" imgName:@"icon_delete.png" w:[ac getButtonSize:BUTTON_SIZE_SMALL] h:[ac getButtonSize:BUTTON_SIZE_SMALL]];
    
    [ac setTextView:mailText text:[lc getTranslated:TRNS_MAIL_TEXT] type:TEXT_CLEAR];
    [ac setButton:mailOkBtn type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_MAIL_SEND] imgName:nil];
    [ac setButton:mailCancelBtn type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
}
-(void) setItemPosition{
    if([ac isSlim]){
        [ac setX:itemLabelLang xMargin:MARGIN_NORMAL];
        [ac setY:itemLabelLang yMargin:MARGIN_NORMAL];
        [ac setX:itemSegLang xMargin:MARGIN_LARGE];
        [ac setY:itemSegLang under:itemLabelLang withMargin:MARGIN_SMALL];
        [ac setX:itemLabelClr xMargin:MARGIN_NORMAL];
        [ac setY:itemLabelClr under:itemSegLang withMargin:MARGIN_NORMAL];
        [ac setX:itemSegClr xMargin:MARGIN_LARGE];
        [ac setY:itemSegClr under:itemLabelClr withMargin:MARGIN_SMALL];
        [ac setX:itemBtnPolicy xMargin:MARGIN_LARGE];
        [ac setY:itemBtnPolicy under:itemSegClr withMargin:MARGIN_SUPER];
        [ac setX:itemBtnMail xMargin:MARGIN_LARGE];
        [ac setY:itemBtnMail under:itemBtnPolicy withMargin:MARGIN_SUPER];
    }else{
        CGFloat inBetween = [ac isIpad] ? MARGIN_SUPER : MARGIN_NORMAL;
        [ac setX:itemSegLang xMargin:MARGIN_INDENT];
        [ac setY:itemSegLang yMargin:MARGIN_LARGE];
        [ac setX:itemLabelLang leftOf:itemSegLang withMargin:MARGIN_NORMAL];
        [ac setY:itemLabelLang nextTo:itemSegLang];
        [ac setX:itemSegClr xMargin:MARGIN_INDENT];
        [ac setY:itemSegClr under:itemSegLang withMargin:inBetween];
        [ac setX:itemLabelClr leftOf:itemSegClr withMargin:MARGIN_NORMAL];
        [ac setY:itemLabelClr nextTo:itemSegClr];
        [ac setX:itemBtnPolicy xMargin:MARGIN_INDENT];
        [ac setX:itemBtnMail xMargin:MARGIN_INDENT];
        [ac setY:itemBtnPolicy under:itemSegClr withMargin:inBetween];
        [ac setY:itemBtnMail under:itemBtnPolicy withMargin:inBetween];
    }
    
    [policyContentText setFrame:CGRectMake(
        0,
        0,
        [ac getW]-[ac getMargin:MARGIN_NORMAL]*2 - [ac getMargin:MARGIN_SMALL]*2,
        [ac getH]-[ac getMargin:MARGIN_NORMAL] - [ac getMargin:MARGIN_SMALL]*4 - policyTitleLabel.frame.size.height
    )];
    
    [ac setY:policyCloseBtn yMargin:MARGIN_SMALL];
    [ac setY:policyTitleLabel yMargin:MARGIN_NORMAL];
    [ac setY:policyContentText under:policyTitleLabel withMargin:MARGIN_SMALL];
    [ac setSubView:policyView type:SUBVIEW_SQUARE xPadding:MARGIN_SMALL yPadding:MARGIN_SMALL];
    [ac setY:policyView yMargin:MARGIN_SMALL];
    [ac setX:policyCloseBtn xRightMargin:MARGIN_SMALL of:policyView];
    [ac setX:policyTitleLabel centerOf:policyView];
    [ac setX:policyContentText centerOf:policyView];

    [ac resizeObject:mailText w:[ac getW]-[ac getMargin:MARGIN_NORMAL]*4 h:10];
    [ac resizeObject:mailText w:[ac getW]-[ac getMargin:MARGIN_NORMAL]*4 h:mailText.contentSize.height];
    CGFloat yMargin = [ac isShort] ? MARGIN_SMALL : MARGIN_NORMAL;
    [ac setY:mailText yMargin:yMargin];
    [ac setY:mailOkBtn under:mailText withMargin:yMargin];
    if( [ac isSlim] ){
        [ac setY:mailCancelBtn under:mailOkBtn withMargin:MARGIN_NORMAL];
    }else{
        [ac setY:mailCancelBtn nextTo:mailOkBtn];
    }
    [ac setSubView:mailView type:SUBVIEW_ROUND xPadding:MARGIN_NORMAL yPadding:yMargin];
    [ac setX:mailText centerOf:mailView];
    if( [ac isSlim] ){
        [ac setX:mailOkBtn centerOf:mailView];
        [ac setX:mailCancelBtn centerOf:mailView];
    }else{
        [ac setX:mailOkBtn xMargin:MARGIN_SUPER];
        [ac setX:mailCancelBtn xRightMargin:MARGIN_SUPER of:mailView];  
    }
      
    [mailView setCenter:self.view.center];
}

#pragma mark - specific
- (void)viewWillDisappear:(BOOL)animated{ 
    [super viewWillDisappear:animated];
    [policyView removeFromSuperview];
    [mailView removeFromSuperview];
}

#pragma mark - selectors
-(void) chgLang{
    [DataSettings setLanguage:[itemSegLang selectedSegmentIndex]];
    lc = [[LangCommon alloc] init];
    [self setAppearance];
    [self setItemPosition];
}
-(void) chgClr{
    [DataSettings setColor:[itemSegClr selectedSegmentIndex]];
    [ac resetColorCode];
    [ac setColors];
    [self setAppearance];
    [self setItemPosition];
}
-(void) readPolicy{
    [ac fade:policyView into:self.view];
}
-(void) closePolicy{
    [policyView removeFromSuperview];
}
-(void) showMailSub{
    [ac fade:mailView into:self.view];
}
-(void) goSendMail{
    [mailView removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:mmoo.akko+mmoo_ime@gmail.com?subject=mmooIME_feedback_contact"]];
}
-(void) mailCancel{
    [mailView removeFromSuperview];
}

@end