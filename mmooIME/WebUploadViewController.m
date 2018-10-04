//  WebUploadViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/27.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebUploadViewController.h"
#import "WebCommon.h"
#import "StringCommon.h"
#import "DataKeyboard.h"
#import "DataTexts.h"

@implementation WebUploadViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
        style: UIBarButtonItemStyleBordered
        target:self 
        action:@selector(popBackTopIfDone)
    ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(targetCode==TARGET_IME){
        if([[DataKeyboard getTxtsByTabIndex:targetIdx] count]==0){
            isEmpty = YES;
        }else{
            isEmpty = NO;
            [DataKeyboard saveTmpTxts:[DataKeyboard getRawTxtsByTabIndex:targetIdx]];
            uploadKsv = [[KeyboardSubView alloc] initWithType:TYPE_WITH_TMP superVC:self];
        }
    }else if(targetCode==TARGET_TEXT){
        NSString *txt = [DataTexts getContentByIndex:targetIdx];
        if([txt length]==0){
            isEmpty = YES;
        }else{
            isEmpty = NO;
            uploadText = [[UITextView alloc] initWithFrame:CGRectMake(0,0,1,1)];
            [ac setTextView:uploadText text:[DataTexts getContentByIndex:targetIdx] type:TEXT_ROUND];
            [uploadText setEditable:NO];
        }        
    }
    itemLabelGenre = [[UILabel alloc] init];
    itemBtnGenreChange = [[UIButton alloc] init];
    itemButtons = [[UIView alloc] init];
    itemBtnOk = [[UIButton alloc] init];
    itemLblEmpty = [[UILabel alloc] init];
    itemBtnCancel = [[UIButton alloc] init];
    itemResultLabel = [[UILabel alloc] init];
    itemBtnRetry = [[UIButton alloc] init];
    
    [itemBtnGenreChange addTarget:self action:@selector(showGenre) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnOk addTarget:self action:@selector(goUpload) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnCancel addTarget:self action:@selector(popBackSimple) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnRetry addTarget:self action:@selector(goUpload) forControlEvents:UIControlEventTouchDown];
    
    if(isEmpty){
        [itemBtnOk setEnabled:NO];
        [self.view addSubview:itemLblEmpty];
    }else if(targetCode==TARGET_IME){
        [self.view addSubview:uploadKsv];
    }else if(targetCode==TARGET_TEXT){
        [self.view addSubview:uploadText];
    }else{
        [self popBackSimple];
    }
    [self.view addSubview:itemLabelGenre];
    [self.view addSubview:itemBtnGenreChange];
    [itemButtons addSubview:itemBtnOk];
    [itemButtons addSubview:itemBtnCancel];
    [self.view addSubview:itemButtons];
    gv = [[WebGenreSubView alloc] initWithATargetCode:targetCode actionCode:ACTION_UPLOAD superView:self
          ];
    gv.delegate = self;
    [ac slide:gv into:self.view];
    
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:ai];
}
-(void) setAppearance{
    NSInteger titleCode = targetCode==TARGET_TEXT ? TRNS_UT_TITLE : TRNS_UI_TITLE;
    [ac setNavTitle:[lc getTranslated:titleCode]];    
    [self setGenre];
    
    [ac setButton:itemBtnGenreChange type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CHANGE] imgName:@"icon_arrow_right.png"];
    [ac setButton:itemBtnOk type:BUTTON_TYPE_RICH title:@"OK" imgName:nil];    
    [ac setButton:itemBtnCancel type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
    [ac setLabel:itemLblEmpty type:LABEL_CAUTION text:[lc getTranslated:TRNS_U_EMPTY] font:FONT_NORMAL];
    [ac setButton:itemBtnRetry type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_UD_RETRY] imgName:nil];
    
    [gv setItemPosition];
}
-(void) setItemPosition{
    NSInteger margin = [ac isShort] ? MARGIN_SMALL : MARGIN_LARGE;
    NSInteger h = [ac isShort] ? [ac getButtonSize:BUTTON_SIZE_NORMAL]*2 : [ac getButtonSize:BUTTON_SIZE_NORMAL]*4;
    
    if(isEmpty){
        [ac setX:itemLblEmpty centerOf:self.view];
        [ac setY:itemLblEmpty yMargin:MARGIN_SUPER];
        [ac setY:itemLabelGenre under:itemLblEmpty withMargin:MARGIN_LARGE];
    }else if(targetCode==TARGET_IME){
        [uploadKsv setWholeAppearence];
        [ac setX:uploadKsv xMargin:MARGIN_NONE];
        [ac setY:uploadKsv yMargin:margin];
        [ac setY:itemLabelGenre under:uploadKsv withMargin:margin];
    }else if(targetCode==TARGET_TEXT){
        [ac resizeObject:uploadText w:[ac getW]-[ac getMargin:MARGIN_SMALL]*2 h:h];
        [ac setX:uploadText xMargin:MARGIN_SMALL];
        [ac setY:uploadText yMargin:margin];
        [ac setY:itemLabelGenre under:uploadText withMargin:margin];
    }
    
    [ac setX:itemLabelGenre xMargin:MARGIN_NORMAL];
    [ac setX:itemBtnGenreChange rightOf:itemLabelGenre withMargin:MARGIN_NORMAL];
    [ac setY:itemBtnGenreChange nextTo:itemLabelGenre];
    
    [ac setX:itemBtnOk xMargin:MARGIN_NONE];
    [ac setX:itemBtnCancel rightOf:itemBtnOk withMargin:MARGIN_LARGE];
    [ac setY:itemBtnOk yMargin:MARGIN_NONE];
    [ac setY:itemBtnCancel yMargin:MARGIN_NONE];
    [ac fitOuter:itemButtons];
    [ac setX:itemButtons centerOf:self.view];
    [ac setY:itemButtons under:itemBtnGenreChange withMargin:MARGIN_SUPER];
    [ac setX:itemResultLabel centerOf:self.view];
    [ac setY:itemResultLabel under:itemLabelGenre withMargin:margin];
    [ac setX:itemBtnRetry centerOf:self.view];
    [ac setY:itemBtnRetry under:itemResultLabel withMargin:MARGIN_NORMAL];
    
    [gv setItemPosition];
    ai.center = self.view.center;
}

#pragma mark - specific
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self popBackTopIfDone];
}
-(id) initWithTargetCode:(NSInteger)code andIndex:(NSInteger)idx{
    self = [super init];
    if(self){
        doneFlg = NO;
        targetCode = code;
        targetIdx = idx;
        genreKey = @"";
        genreStr = @"";
        
        if(targetCode==TARGET_IME){
            NSArray *allTitles = [DataKeyboard getAllTabTitles];
            targetTitle = [allTitles objectAtIndex:targetIdx];
        }else{
            targetTitle = [DataTexts getTitleByIndex:targetIdx];
        }
    }
    return self;
}
-(void) setGenre{
    if(genreStr.length==0){
        genreStr = [lc getTranslated:TRNS_U_GENRE_NONE];
    }
    [ac setLabel:itemLabelGenre type:LABEL_CONTENT text:[NSString stringWithFormat:@"%@%@", [lc getTranslated:TRNS_UD_GENRE],genreStr] font:FONT_SMALL];
    [ac setX:itemBtnGenreChange rightOf:itemLabelGenre withMargin:MARGIN_NORMAL];
}
-(void) showResult:(NSInteger)resultFlg{
    [ai stopAnimating];
    NSInteger trns = (resultFlg==RESULT_SUCCESS) ? TRNS_U_SUCCESS : TRNS_UD_FAILED;
    [ac setLabel:itemResultLabel type:LABEL_CONTENT text:[lc getTranslated:trns] font:FONT_NORMAL];
    [ac setX:itemResultLabel centerOf:self.view];
    [self.view addSubview:itemResultLabel];
    if(resultFlg==RESULT_SUCCESS){
        doneFlg = YES;
    }else{
        [ac setY:itemBtnRetry under:itemResultLabel withMargin:MARGIN_NORMAL];
        [self.view addSubview:itemBtnRetry];
    }
}
-(void) popBackSimple{
    NSArray *views = [self.navigationController childViewControllers];
    [self.navigationController popToViewController:[views objectAtIndex:1] animated:YES];
}
-(void) popBackTopIfDone{
    if(doneFlg){
        NSArray *views = [self.navigationController childViewControllers];
        [self.navigationController popToViewController:[views objectAtIndex:0] animated:YES];
        doneFlg = NO;
    }else{
        [self popBackSimple];
    }
}

#pragma mark - selectors
-(void) showGenre{
    [gv refresh];
    [ac slide:gv into:self.view];
}
-(void) goUpload{
    [itemBtnGenreChange removeFromSuperview];
    [itemBtnOk removeFromSuperview];
    [itemBtnCancel removeFromSuperview];
    [itemResultLabel removeFromSuperview];
    [itemBtnRetry removeFromSuperview];
    
    [ai startAnimating];
    
    NSMutableURLRequest *request = [WebCommon getReq:@"post"];
    request.HTTPMethod = @"POST";
    NSString *target;
    NSString *content;
    if(targetCode==TARGET_IME){
        target = @"ime";
        content = [DataKeyboard getRawTxtsByTabIndex:targetIdx];
    }else{
        target = @"text";
        content = [DataTexts getContentByIndex:targetIdx];
    }
    
    NSString *body = [NSString stringWithFormat:@"target=%@&title=%@&contents=%@&tag=%@", target,[StringCommon urlEncode:targetTitle],[StringCommon urlEncode:content],genreKey];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData dataWithLength:0];
    }else{
        [self showResult:RESULT_FAILED];
    }
}

#pragma mark - WebGenreSubView delegate
-(void) genreSelected:(NSInteger)gc inCat:(NSInteger)cc{
    WebCommon *wc = [[WebCommon alloc] initWithTargetCode:targetCode];
    genreKey = [wc getGenre:gc inCat:cc type:GENRE_TYPE_KEY];
    genreStr = [wc getGenre:gc inCat:cc type:GENRE_TYPE_STR];
    [self setGenre];
    [gv removeFromSuperview];
}
-(void) genreNotSelected{
    [gv removeFromSuperview];
}

#pragma mark - URLconnection delegate
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self showResult:RESULT_FAILED];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *resp = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    if([resp isEqual:@"OK"]){
        [self showResult:RESULT_SUCCESS];
    }else{
        [self showResult:RESULT_FAILED];
    }
}

@end