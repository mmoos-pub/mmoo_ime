//
//  TextEditViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/17.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "TextEditViewController.h"
#import "StringCommon.h"
#import "DataTexts.h"
#import "DataSettings.h"
#import "DataKeyboard.h"
#import "KeyboardSubView.h"

@implementation TextEditViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    targetTabIdx = [DataKeyboard getLastUsedTabIdx];
    kbd_type = [DataKeyboard getLastUsedKeyboardType];
    resp = RESP_TEXT;
    
    UIBarButtonItem *leftButton = [
          [UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
          style: UIBarButtonItemStyleBordered
          target:self 
          action:@selector(popBack)
    ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *saveButton = [
          [UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"icon_save.png"]
          style:UIBarButtonItemStyleBordered
          target:self 
          action:@selector(showSaveSubView)    
    ];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    itemCntLabel = [[UILabel alloc] init];
    [self.view addSubview:itemCntLabel];
    
    itemContentText = [[UITextView alloc] init];
    itemContentText.delegate = self;
    [itemContentText setScrollEnabled:YES];
    [self.view addSubview:itemContentText];
    
    ksv = [[KeyboardSubView alloc] initWithType:TYPE_AS_IME superVC:self];
    ksv.delegate = self;
    
    itemSaveSubView = [[UIView alloc] init];
    itemSaveTitleView = [[UIView alloc] init];
    itemSaveButtonsView = [[UIView alloc] init];
    itemTitleLabel = [[UILabel alloc] init];
    itemTitleText = [[UITextField alloc] init];
    itemSaveButton = [[UIButton alloc] init];
    itemCancelButton = [[UIButton alloc] init];
    [itemSaveTitleView addSubview:itemTitleLabel];
    [itemSaveTitleView addSubview:itemTitleText];
    [itemSaveSubView addSubview:itemSaveTitleView];
    [itemSaveButtonsView addSubview:itemSaveButton];
    [itemSaveButtonsView addSubview:itemCancelButton];
    [itemSaveSubView addSubview:itemSaveButtonsView];
    
    itemCopiedSubView = [[UIView alloc] init];
    itemCopiedLabel = [[UILabel alloc] init];
    [itemCopiedSubView addSubview:itemCopiedLabel];
    itemOkButton = [[UIButton alloc] init];
    itemBtnMail = [[UIButton alloc] init];
    itemBtnSMS = [[UIButton alloc] init];
    itemBtnFacebook = [[UIButton alloc] init];
    [itemCopiedSubView addSubview:itemOkButton];
    [itemCopiedSubView addSubview:itemBtnMail];
    [itemCopiedSubView addSubview:itemBtnSMS];
    [itemCopiedSubView addSubview:itemBtnFacebook];
    
    itemAccessoryView = [[UIView alloc] init];
    itemContentText.inputAccessoryView = itemAccessoryView;
    itemTitleText.inputAccessoryView = itemAccessoryView;
    itemChgButton = [[UIButton alloc] init];
    [itemAccessoryView addSubview:itemChgButton];
    itemPasteButton = [[UIButton alloc] init];
    [itemAccessoryView addSubview:itemPasteButton];
    itemDeleteButton = [[UIButton alloc] init];
    [itemAccessoryView addSubview:itemDeleteButton];
    itemReturnButton = [[UIButton alloc] init];
    [itemAccessoryView addSubview:itemReturnButton];
    
    itemBtnMail.tag = ACTION_MAIL;
    itemBtnSMS.tag = ACTION_SMS;
    itemBtnFacebook.tag = ACTION_FACEBOOK;
    
    [itemPasteButton addTarget:self action:@selector(pasteToClipBoard) forControlEvents:UIControlEventTouchUpInside];
    [itemSaveButton addTarget:self action:@selector(saveTxt) forControlEvents:UIControlEventTouchUpInside];
    [itemCancelButton addTarget:self action:@selector(saveCancel) forControlEvents:UIControlEventTouchUpInside];
    [itemOkButton addTarget:self action:@selector(copiedOk) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnMail addTarget:self action:@selector(copiedThen:) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnSMS addTarget:self action:@selector(copiedThen:) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnFacebook addTarget:self action:@selector(copiedThen:) forControlEvents:UIControlEventTouchUpInside];
    [itemChgButton addTarget:self action:@selector(ksvChg) forControlEvents:UIControlEventTouchUpInside];
    [itemDeleteButton addTarget:self action:@selector(ksvBs) forControlEvents:UIControlEventTouchUpInside];
    [itemReturnButton addTarget:self action:@selector(ksvRtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void) setAppearance{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self setNavTitle];
    
    [ac setTextView:itemContentText text:[DataTexts getContentByID:textID] type:TEXT_SQUARE];
    [self showCnt];
    [ac setButton:itemChgButton type:BUTTON_TYPE_RICH title:nil imgName:@"keyboard_dark.png"];
    [ac setButton:itemPasteButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_COPY_TO_CLIPBOARD] imgName:@"68-paperclip.png"];
    [ac setButton:itemDeleteButton type:BUTTON_TYPE_RICH title:nil imgName:@"backspace.png"];
    [ac setButton:itemReturnButton type:BUTTON_TYPE_RICH title:nil imgName:@"key_enter.png"];
    
    [itemContentText becomeFirstResponder];
    if(kbd_type==KBD_CUSTOM){
        itemContentText.inputView = ksv;
    }else{
        itemContentText.inputView = nil;
    }
}
-(void) setItemPosition{
    targetTabIdx = [ksv setTab:targetTabIdx];
    [ksv setWholeAppearence];
    
    [ac setX:itemCntLabel xRightMargin:MARGIN_NORMAL of:self.view];
    [ac setY:itemCntLabel yMargin:MARGIN_SMALL];
    [ksv setWholeAppearence];
    
    [ac setX:itemChgButton xMargin:MARGIN_LARGE];
    [ac setX:itemPasteButton rightOf:itemChgButton withMargin:MARGIN_NORMAL];
    [ac setX:itemReturnButton rightOf:itemPasteButton withMargin:MARGIN_NORMAL];
    [ac setX:itemDeleteButton rightOf:itemReturnButton withMargin:MARGIN_NORMAL];
    [ac setY:itemChgButton yMargin:MARGIN_SMALL];
    [ac setY:itemPasteButton yMargin:MARGIN_SMALL];
    [ac setY:itemReturnButton yMargin:MARGIN_SMALL];
    [ac setY:itemDeleteButton yMargin:MARGIN_SMALL];
    
    [ac setSubView:itemAccessoryView type:SUBVIEW_SQUARE xPadding:MARGIN_NORMAL yPadding:MARGIN_SMALL];
    [itemAccessoryView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, itemAccessoryView.frame.size.height)];
    
    [ac setLabel:itemTitleLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_TXT_TITLE] font:FONT_NORMAL];
    [ac setTextField:itemTitleText 
         text:[DataTexts getTitleByID:textID] 
         placeHolder:[lc getTranslated:TRNS_TXT_TITLE_PLACEFOLDER]
    ];
    [ac setButton:itemSaveButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_SAVE] imgName:nil];
    [ac setButton:itemCancelButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
    
    CGFloat w = [ac getW] - [ac getMargin:MARGIN_LARGE]*2;
    CGFloat marginTopBottom, marginInBetween, marginSub;
    if([ac isShort]){
        marginTopBottom = MARGIN_NORMAL;
        marginInBetween = MARGIN_SMALL;
        marginSub = MARGIN_SMALL;
    }else{
        marginTopBottom = MARGIN_NORMAL;
        marginInBetween = MARGIN_NORMAL;
        marginSub = MARGIN_NORMAL;
    }
    
    [ac setX:itemTitleLabel xMargin:MARGIN_NONE];
    [ac setY:itemTitleLabel yMargin:MARGIN_NONE];
    [ac resizeObject:itemTitleText w:w-itemTitleLabel.frame.size.width-[ac getMargin:MARGIN_NORMAL]*3 h:itemTitleLabel.frame.size.height+2.0];
    [ac setX:itemTitleText rightOf:itemTitleLabel withMargin:MARGIN_NORMAL];
    [ac setY:itemTitleText nextTo:itemTitleLabel];
    [ac fitOuter:itemSaveTitleView];
    [ac setY:itemSaveTitleView yMargin:marginTopBottom];
    
    [ac setX:itemSaveButton xMargin:MARGIN_NONE];
    [ac setY:itemSaveButton yMargin:MARGIN_NONE];
    [ac setX:itemCancelButton rightOf:itemSaveButton withMargin:MARGIN_NORMAL];
    [ac setY:itemCancelButton nextTo:itemSaveButton];
    [ac fitOuter:itemSaveButtonsView];
    [ac setY:itemSaveButtonsView under:itemSaveTitleView withMargin:marginInBetween];
    
    [ac setSubView:itemSaveSubView type:SUBVIEW_ROUND xPadding:MARGIN_NORMAL yPadding:marginTopBottom];
    [ac setY:itemSaveSubView yMargin:marginSub];
    [ac setX:itemSaveTitleView centerOf:itemSaveSubView];
    [ac setX:itemSaveButtonsView centerOf:itemSaveSubView];
    
    [ac setLabel:itemCopiedLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_COPIED] font:FONT_NORMAL];
    [ac setButton:itemOkButton type:BUTTON_TYPE_RICH title:@"OK" imgName:nil w:[ac getW]*2/3 h:0];
    [ac setButton:itemBtnMail type:BUTTON_TYPE_RICH title:@"MAIL" imgName:nil w:[ac getW]*2/3 h:0];
    [ac setButton:itemBtnSMS type:BUTTON_TYPE_RICH title:@"SMS" imgName:nil w:[ac getW]*2/3 h:0];
    [ac setButton:itemBtnFacebook type:BUTTON_TYPE_RICH title:@"Facebook" imgName:nil w:[ac getW]*2/3 h:0];
    CGFloat yBig = [ac isShort] ? MARGIN_SMALL : MARGIN_LARGE;
    CGFloat ySmall = [ac isShort] ? MARGIN_NORMAL : MARGIN_NORMAL;
    [ac setY:itemCopiedLabel yMargin:yBig];
    [ac setY:itemOkButton under:itemCopiedLabel withMargin:yBig];
    [ac setY:itemBtnMail under:itemOkButton withMargin:ySmall];
    [ac setY:itemBtnSMS under:itemBtnMail withMargin:ySmall];
    [ac setY:itemBtnFacebook under:itemBtnSMS withMargin:ySmall];
    [ac setSubView:itemCopiedSubView type:SUBVIEW_ROUND xPadding:MARGIN_SUPER yPadding:yBig];
    [ac setX:itemCopiedLabel centerOf:itemCopiedSubView];
    [ac setX:itemOkButton centerOf:itemCopiedSubView];
    [ac setX:itemBtnMail centerOf:itemCopiedSubView];
    [ac setX:itemBtnSMS centerOf:itemCopiedSubView];
    [ac setX:itemBtnFacebook centerOf:itemCopiedSubView];
    itemCopiedSubView.center = self.view.center;
    
    [itemContentText reloadInputViews];
    [itemTitleText reloadInputViews];
    [self resizeContentText];
    [ac setY:ksv under:itemAccessoryView withMargin:MARGIN_NONE];
}

#pragma mark - specific
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [itemContentText resignFirstResponder];
    [self saveCancel];
    [itemCopiedSubView removeFromSuperview];
    [DataKeyboard saveLastUsedTabIdx:targetTabIdx];
    [DataKeyboard saveLastUsedKeyboardType:kbd_type];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
-(id) initWithTextID:(NSString*)requestID{
    self = [super init];
    if(self){
        textID = (requestID==nil) ? [DataTexts getNewID] : requestID;
    }
    return self;
}
-(void) setNavTitle{
    NSString *textTitle = [DataTexts getTitleByID:textID];
    if(textTitle==nil){
        textTitle = [lc getTranslated:TRNS_TXT_NEW_TITLE];
    }else if(textTitle.length==0){
        textTitle = [lc getTranslated:TRNS_TXT_NO_TITLE];
    }
    [ac setNavTitle:textTitle];
}
-(void) showCnt{
    NSString *str = [NSString stringWithString:itemContentText.text];
    NSString *strCnt;
    NSInteger intRawCnt = [StringCommon getLen:str];
    NSInteger intByteCnt = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if( [DataSettings getLanguage]==LANG_JP ){
        strCnt = [NSString stringWithFormat:@"文字数： %zd (ﾊﾞｲﾄ： %zd)",intRawCnt,intByteCnt];
    }else{
        NSInteger intWordCnt = [StringCommon getWordCnt:str];
        strCnt = [NSString stringWithFormat:@"word count: %zd(chars: %zd)", intWordCnt,intByteCnt];
    }
    [ac setLabel:itemCntLabel type:LABEL_CONTENT text:strCnt font:FONT_SMALL];
    [ac setX:itemCntLabel xRightMargin:MARGIN_NORMAL of:self.view];
}
-(void) saveCancel{
    [itemAccessoryView addSubview:itemPasteButton];
    [itemAccessoryView addSubview:itemReturnButton];
    resp = RESP_TEXT;
    [itemSaveSubView removeFromSuperview];
    [itemTitleText resignFirstResponder];
    [self showResponder];
}
-(void) copiedOk{
    [itemCopiedSubView removeFromSuperview];
    [self showResponder];
}
-(void) hideResponder{
    [itemContentText resignFirstResponder];
    [itemContentText setEditable:NO];
}
-(void) showResponder{
    [itemContentText becomeFirstResponder];
    [itemContentText setEditable:YES];
    [itemContentText reloadInputViews];
    [self resizeContentText];
}
-(void) resizeContentText{    
    CGFloat kbH;
    if([ac getH]>[ac getW]){
        kbH = CGRectGetHeight([[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    }else{
        kbH = CGRectGetWidth([[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]);
    }
    
    CGFloat textH = [ac getH] 
                    + [self.navigationController rotatingHeaderView].frame.size.height
                    - kbH
                    - itemCntLabel.frame.origin.y - itemCntLabel.frame.size.height - [ac getMargin:MARGIN_SMALL]*2;
    
    [ac resizeObject:itemContentText w:[ac getW]-[ac getMargin:MARGIN_NORMAL]*2 h:textH];
    [ac setX:itemContentText centerOf:self.view];
    [ac setY:itemContentText under:itemCntLabel withMargin:MARGIN_SMALL];
}

#pragma mark - selectors
-(void) popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) pasteToClipBoard{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board 
        setValue:[itemContentText text] 
        forPasteboardType:@"public.utf8-plain-text"
    ];
    [self saveCancel];
    [self hideResponder];
    [ac fade:itemCopiedSubView into:self.view];
}
-(void) copiedThen:(UIButton*)sender{
    NSString *url;
    switch (sender.tag) {
        case ACTION_MAIL:
            url = @"mailto:";
        break;
        case ACTION_SMS:
            url = @"sms:";
        break;
        case ACTION_FACEBOOK:
            url = @"fb://profile";
        break;
        default:
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [self copiedOk];
}
-(void) showSaveSubView{
    [itemPasteButton removeFromSuperview];
    [itemReturnButton removeFromSuperview];
    resp = RESP_TITLE;
    [itemCopiedSubView removeFromSuperview];
    [self hideResponder];
    [self.view addSubview:itemSaveSubView];
    [itemTitleText becomeFirstResponder];
    
    if(kbd_type==KBD_CUSTOM){
        itemTitleText.inputView = ksv;
    }else{
        itemTitleText.inputView = nil;
    }
    [itemTitleText reloadInputViews];
    [ac setY:ksv under:itemAccessoryView withMargin:MARGIN_NONE];
}
-(void) saveTxt{
    NSString *title = [itemTitleText text];
    NSString *content = [itemContentText text];
    [DataTexts saveTextData:content withTextID:textID withTitle:title];
    [self setNavTitle];
    [self saveCancel];
    [self popBack];
}
-(void) ksvChg{
    if(kbd_type==KBD_NORMAL){
        kbd_type = KBD_CUSTOM;
        itemContentText.inputView = ksv;
        itemTitleText.inputView = ksv;
    }else{
        kbd_type = KBD_NORMAL;
        itemContentText.inputView = nil;
        itemTitleText.inputView = nil;
    }
    if( resp == RESP_TITLE ){
        [itemTitleText reloadInputViews];
    }else{
        [itemContentText reloadInputViews];
    }
    [self resizeContentText];
}
-(void) ksvBs{
    NSString *firstHalf, *lastHalf;
    if( resp == RESP_TEXT ){
        NSRange r = itemContentText.selectedRange;
        if(r.length>0){
            firstHalf = [StringCommon getSub:itemContentText.text to:r.location+1];
            lastHalf = [StringCommon getSub:itemContentText.text from:r.location+r.length];
            itemContentText.text = [firstHalf stringByAppendingString:lastHalf];
            r.length = 0;
            itemContentText.selectedRange = r;
        }else if(r.location>0){
            firstHalf = [StringCommon getSub:itemContentText.text to:r.location];
            lastHalf = [StringCommon getSub:itemContentText.text from:r.location];
            itemContentText.text = [firstHalf stringByAppendingString:lastHalf];
            r.location --;
            itemContentText.selectedRange = r;
        }
        [self showCnt];
    }else if( resp == RESP_TITLE ){
        UITextRange *sr = [itemTitleText selectedTextRange];
        NSInteger start = [itemTitleText offsetFromPosition:itemTitleText.beginningOfDocument toPosition:sr.start];
        NSInteger end = [itemTitleText offsetFromPosition:itemTitleText.beginningOfDocument toPosition:sr.end];
        if(end>start){
            firstHalf = [StringCommon getSub:itemTitleText.text to:start+1];
            lastHalf = [StringCommon getSub:itemTitleText.text from:end];
            itemTitleText.text = [firstHalf stringByAppendingString:lastHalf];
            UITextPosition *newPos = [itemTitleText positionFromPosition:itemTitleText.beginningOfDocument offset:start];
            itemTitleText.selectedTextRange = [itemTitleText textRangeFromPosition:newPos toPosition:newPos];
        }else if(start>0){
            firstHalf = [StringCommon getSub:itemTitleText.text to:start];
            lastHalf = [StringCommon getSub:itemTitleText.text from:start];
            itemTitleText.text = [firstHalf stringByAppendingString:lastHalf];
            UITextPosition *newPos = [itemTitleText positionFromPosition:itemTitleText.beginningOfDocument offset:start-1];
            itemTitleText.selectedTextRange = [itemTitleText textRangeFromPosition:newPos toPosition:newPos];
        }
    }
}
-(void) ksvRtn{
    NSString *firstHalf, *lastHalf;
    NSRange r = itemContentText.selectedRange;
    if(r.length>0){
        firstHalf = [StringCommon getSub:itemContentText.text to:r.location+1];
        lastHalf = [StringCommon getSub:itemContentText.text from:r.location+r.length];
        itemContentText.text = [NSString stringWithFormat:@"%@\n%@",firstHalf,lastHalf];
        r.length = 0;
        r.location ++;
        itemContentText.selectedRange = r;
    }else{
        firstHalf = [StringCommon getSub:itemContentText.text to:r.location+1];
        lastHalf = [StringCommon getSub:itemContentText.text from:r.location];
        itemContentText.text = [NSString stringWithFormat:@"%@\n%@",firstHalf,lastHalf];
        r.location += [StringCommon getLen:@"\n"];
        itemContentText.selectedRange = r;
    }
    [self showCnt];
}

#pragma mark - notification keyboard
-(void) keyboardWillShow:(NSNotification *)notification {
    note = notification;
    [self resizeContentText];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView{
    [self showCnt];
}

#pragma mark - keybordSub delegate
-(void) tabSelected:(UIButton*)sender{
    targetTabIdx = sender.tag;
}
-(void) txtSelected:(UIButton*)sender{
    NSString *firstHalf, *lastHalf, *newStr;
    newStr = [[DataKeyboard getTxtsByTabIndex:targetTabIdx] objectAtIndex:sender.tag];
    
    if( resp == RESP_TEXT ){
        NSRange r = itemContentText.selectedRange;
        if(r.length>0){
            firstHalf = [StringCommon getSub:itemContentText.text to:r.location+1];
            lastHalf = [StringCommon getSub:itemContentText.text from:r.location+r.length];
            itemContentText.text = [[firstHalf stringByAppendingString:newStr] stringByAppendingString:lastHalf];
            r.length = 0;
            r.location += [StringCommon getLen:newStr];
            itemContentText.selectedRange = r;
        }else{
            firstHalf = [StringCommon getSub:itemContentText.text to:r.location+1];
            lastHalf = [StringCommon getSub:itemContentText.text from:r.location];          
            itemContentText.text = [[firstHalf stringByAppendingString:newStr] stringByAppendingString:lastHalf];
            r.location += [StringCommon getLen:newStr];
            itemContentText.selectedRange = r;
        }
        [self showCnt];
    }else if( resp == RESP_TITLE ){
        UITextRange *sr = [itemTitleText selectedTextRange];
        NSInteger start = [itemTitleText offsetFromPosition:itemTitleText.beginningOfDocument toPosition:sr.start];
        NSInteger end = [itemTitleText offsetFromPosition:itemTitleText.beginningOfDocument toPosition:sr.end];
        if(end>start){
            firstHalf = [StringCommon getSub:itemTitleText.text to:start+1];
            lastHalf = [StringCommon getSub:itemTitleText.text from:end];
        }else{
            firstHalf = [StringCommon getSub:itemTitleText.text to:start+1];
            lastHalf = [StringCommon getSub:itemTitleText.text from:start];
        }
        itemTitleText.text = [[firstHalf stringByAppendingString:newStr] stringByAppendingString:lastHalf];
        UITextPosition *newPos = [itemTitleText positionFromPosition:itemTitleText.beginningOfDocument offset:start+[StringCommon getLen:newStr]];
        itemTitleText.selectedTextRange = [itemTitleText textRangeFromPosition:newPos toPosition:newPos];
    }
}
@end