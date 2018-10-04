//
//  WebDownloadViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/28.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"
#import "KeyboardSubView.h"

@interface WebDownloadViewController : ViewControllerCommon<NSURLConnectionDelegate,NSXMLParserDelegate>{
    BOOL doneFlg;
    NSInteger targetCode;
    NSString *title;
    NSString *seq;
    
    UIActivityIndicatorView  *ai;
    NSMutableData *receivedData;
    Boolean inTag;
    NSMutableString *resp;
    Boolean parseErrFlg;
    
    UITextView *contentTextView;
    KeyboardSubView *contentImeView;
    UIView *itemButtons;
    UIButton *itemBtnDownload;
    UIButton *itemBtnCancel;
    
    UIView *errView;
    UILabel *errLabel;
    UIButton *errBtn;
}

-(id) initWithTargetCode:(NSInteger)code title:(NSString*)ttl seq:(NSString*)seqID;
-(void) downloadData;
-(void) showErr;
-(void) popBackSimple;
-(void) popBackTopOnly;
-(void) popBackTopOrSimple;

@end