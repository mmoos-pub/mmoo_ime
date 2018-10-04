//
//  WebDownloadViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/28.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebDownloadViewController.h"
#import "WebCommon.h"
#import "DataKeyboard.h"
#import "DataTexts.h"
#import "KeyboardSubView.h"

@implementation WebDownloadViewController
#pragma mark - ViewControllerCommon
-(void) initSubViews{
    doneFlg = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
        style: UIBarButtonItemStyleBordered
        target:self 
        action:@selector(popBackTopOrSimple)
    ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if(targetCode==TARGET_IME){ 
        contentImeView = [[KeyboardSubView alloc] initWithType:TYPE_WITH_TMP superVC:self];
    }else{
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [contentTextView setEditable:NO];
    }
    
    itemButtons = [[UIView alloc] init];
    itemBtnDownload = [[UIButton alloc] init];
    itemBtnCancel = [[UIButton alloc] init];
    [itemButtons addSubview:itemBtnDownload];
    [itemButtons addSubview:itemBtnCancel];
    [itemBtnDownload addTarget:self action:@selector(goDownload) forControlEvents:UIControlEventTouchUpInside];
    [itemBtnCancel addTarget:self action:@selector(popBackSimple) forControlEvents:UIControlEventTouchUpInside];
    
    errView = [[UIView alloc] init];
    errLabel = [[UILabel alloc] init];
    errBtn = [[UIButton alloc] init];
    [errBtn addTarget:self action:@selector(downloadData) forControlEvents:UIControlEventTouchUpInside];
    [errView addSubview:errLabel];
    [errView addSubview:errBtn];
    
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:ai];
}
-(void) setAppearance{
    NSInteger titleCode = targetCode==TARGET_TEXT ? TRNS_DT_TITLE : TRNS_DI_TITLE;
    [ac setNavTitle:[lc getTranslated:titleCode]];
    
    [ac setButton:itemBtnDownload type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_D_DOWNLOAD] imgName:nil];
    [ac setButton:itemBtnCancel type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
    
    [ac setLabel:errLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_UD_FAILED] font:FONT_NORMAL];
    [ac setButton:errBtn type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_UD_RETRY] imgName:nil];
    
    [self downloadData];
}
-(void) setItemPosition{
    [ac setX:itemBtnDownload xMargin:MARGIN_NONE];
    [ac setY:itemBtnDownload yMargin:MARGIN_NONE];
    [ac setX:itemBtnCancel rightOf:itemBtnDownload withMargin:MARGIN_LARGE];
    [ac setY:itemBtnCancel nextTo:itemBtnDownload];
    [ac fitOuter:itemButtons];
    [ac setX:itemButtons centerOf:self.view];
    [ac setY:itemButtons yMargin:MARGIN_LARGE];
    
    if(targetCode==TARGET_IME){
        [contentImeView setWholeAppearence];
        [ac setX:contentImeView centerOf:self.view];
        [ac setY:contentImeView under:itemButtons withMargin:MARGIN_SUPER];
    }else{
        CGFloat y = itemButtons.frame.origin.y + itemButtons.frame.size.height + [ac getMargin:MARGIN_LARGE];
        [contentTextView setFrame:CGRectMake(
            [ac getMargin:MARGIN_NORMAL],
            y,
            [ac getW] - [ac getMargin:MARGIN_NORMAL]*2,
            [ac getH] - y - [ac getMargin:MARGIN_SUPER]
        )];
    }
    
    [ac setY:errLabel yMargin:MARGIN_LARGE];
    [ac setY:errBtn under:errLabel withMargin:MARGIN_LARGE];    
    [ac setSubView:errView type:SUBVIEW_ROUND xPadding:MARGIN_LARGE yPadding:MARGIN_LARGE];
    [ac setY:errView yMargin:MARGIN_LARGE];
    [ac setX:errLabel centerOf:errView];
    [ac setX:errBtn centerOf:errView];
    errView.center = self.view.center;
    
    ai.center = self.view.center;
}

#pragma mark - specific
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self popBackTopOnly];
}
-(id) initWithTargetCode:(NSInteger)code title:(NSString *)ttl seq:(NSString *)seqID{
    self = [super init];
    if(self){
        doneFlg = NO;
        targetCode = code;
        title = ttl;
        seq = seqID;        
    }
    return self;
}
-(void) downloadData{
    [errView removeFromSuperview];
    
    NSMutableURLRequest *request = [WebCommon getReq:@"content"];
    request.HTTPMethod = @"POST";
    NSString *target = (targetCode==TARGET_IME) ? @"ime" : @"text";
    NSString *body = [NSString stringWithFormat:@"target=%@&seq=%@", target,seq];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        parseErrFlg = NO;
        [ai startAnimating];
        receivedData = [NSMutableData dataWithLength:0];
    }else{
        [self showErr];
    }
}

-(void) showErr{
    [ai stopAnimating];
    [self.view addSubview:errView];
}
-(void) popBackSimple{
    NSArray *views = [self.navigationController childViewControllers];
    [self.navigationController popToViewController:[views objectAtIndex:1] animated:YES];
}
-(void) popBackTopOnly{
    if(doneFlg){
        NSArray *views = [self.navigationController childViewControllers];
        [self.navigationController popToViewController:[views objectAtIndex:0] animated:YES];
        doneFlg = NO;
    }
}
-(void) popBackTopOrSimple{
    if(doneFlg){
        [self popBackTopOnly];
    }else{
        [self popBackSimple];
    }
}

#pragma mark - selectors
-(void) goDownload{
    doneFlg = YES;
    [itemButtons removeFromSuperview];
    
    if(targetCode==TARGET_IME){
        NSMutableArray *allID = [NSMutableArray arrayWithArray:[DataKeyboard getAllTabID]];
        NSString *newID = [DataKeyboard getNewTabID];
        [allID addObject:newID];
        [DataKeyboard saveAllTabID:allID];
        [DataKeyboard saveTabTitle:title withTabID:newID];
        [DataKeyboard saveTxts:[DataKeyboard getTmpTxts] withTabID:newID];
    }else if(targetCode==TARGET_TEXT){
        NSString *newID = [DataTexts getNewID];
        [DataTexts saveTextData:contentTextView.text withTextID:newID withTitle:title];
    }
    
    UILabel *lbl = [[UILabel alloc] init];
    [ac setLabel:lbl type:LABEL_CONTENT text:[lc getTranslated:TRNS_D_DONE] font:FONT_NORMAL];
    [ac setX:lbl centerOf:self.view];
    [ac setY:lbl yMargin:MARGIN_SUPER];
    [self.view addSubview:lbl];
    
    NSMutableURLRequest *request = [WebCommon getReq:@"downloaded"];
    request.HTTPMethod = @"POST";
    NSString *target = (targetCode==TARGET_IME) ? @"ime" : @"text";
    NSString *body = [NSString stringWithFormat:@"target=%@&seq=%@", target,seq];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    if(connection){}
}

#pragma mark - URLconnection delegate
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self showErr];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - XMLparser delegate
-(void) parserDidStartDocument:(NSXMLParser *)parser {
    inTag = NO;
}
-(void) parserDidEndDocument:(NSXMLParser *)parser {
    if(!parseErrFlg){
        [ai stopAnimating];
        
        if(targetCode==TARGET_IME){
            [DataKeyboard saveTmpTxts:resp];
            [contentImeView setWholeAppearence];
            [ac setX:contentImeView centerOf:self.view];
            [ac setY:contentImeView under:itemBtnCancel withMargin:MARGIN_SUPER];
            [self.view addSubview:contentImeView];
            [self setItemPosition];
        }else{
            [ac setTextView:contentTextView text:resp type:TEXT_ROUND];
            [self.view addSubview:contentTextView];
        }
        [self.view addSubview:itemButtons];
    }
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"content"]) {
        inTag = YES;
        resp = [NSMutableString string];
	}
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"content"]) {
        inTag = NO;
	}
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (inTag) {
		[resp appendString:string];
	}
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    parseErrFlg = YES;
    [self showErr];
}

@end
