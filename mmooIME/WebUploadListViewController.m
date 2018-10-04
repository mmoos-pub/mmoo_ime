//
//  WebUploadListViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebUploadListViewController.h"
#import "WebUploadViewController.h"
#import "DataKeyboard.h"
#import "DataTexts.h"

@implementation WebUploadListViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    UIBarButtonItem *leftButton = [
          [UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
          style: UIBarButtonItemStyleBordered
          target:self 
          action:@selector(popBack)
    ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    itemLabelNoItem = [[UILabel alloc] init];
    itemLabelPlease = [[UILabel alloc] init];
    
    tv = [[UITableView alloc] init];
    [tv setDelegate:self];
    [tv setDataSource:self];
    tvBack = [[UIView alloc] init];
    [tvBack addSubview:tv];
}
-(void) setAppearance{
    NSInteger titleCode = targetCode==TARGET_TEXT ? TRNS_UT_TITLE : TRNS_UI_TITLE;
    [ac setNavTitle:[lc getTranslated:titleCode]];
    
    if(targetCode==TARGET_IME){
        NSArray *tabs = [DataKeyboard getAllTabTitles];
        NSMutableArray *toCopy = [NSMutableArray array];
        NSString *str;
        for(NSInteger i=0; i<[tabs count]; i++){
            str = [tabs objectAtIndex:i];
            if( [str length]==0 ){
                str = [lc getTranslated:TRNS_TXT_NO_TITLE];
            }
            [toCopy addObject:str];
        }
        titles = toCopy;
    }else if(targetCode==TARGET_TEXT){
        NSArray *fileNames = [DataTexts getSortedFileNames];
        NSMutableArray *toCopy = [NSMutableArray array];
        NSString *str;
        for(NSInteger i=0; i<[fileNames count]; i++){
            str = [DataTexts getTitleByID:[fileNames objectAtIndex:i]];
            if( [str length]==0 ){
                str = [lc getTranslated:TRNS_TXT_NO_TITLE];
            }
            [toCopy addObject:str];
        }
        titles = toCopy;
    }else{
        titles = [NSArray array];
    }
    if( [titles count]>0 ){
        [self.view addSubview:itemLabelPlease];
        [ac setLabel:itemLabelPlease type:LABEL_CONTENT text:[lc getTranslated:TRNS_U_SELECT] font:FONT_NORMAL];
        [tv reloadData];
        [self.view addSubview:tvBack];
    }else{
        [self.view addSubview:itemLabelNoItem];
        [ac setLabel:itemLabelNoItem type:LABEL_CONTENT text:[lc getTranslated:TRNS_U_NO_ITEM] font:FONT_LARGE];
    }}
-(void) setItemPosition{
    [ac setX:itemLabelNoItem centerOf:self.view];
    [ac setX:itemLabelPlease xMargin:MARGIN_NORMAL];
    [ac setY:itemLabelNoItem yMargin:MARGIN_SUPER];
    [ac setY:itemLabelPlease yMargin:MARGIN_NORMAL];
    
    CGFloat maxH = [ac getH] - itemLabelPlease.frame.origin.y - itemLabelPlease.frame.size.height - [ac getMargin:MARGIN_NORMAL] - [ac getMargin:MARGIN_SMALL];
    CGFloat minH = [ac getTableCellH:TABLE_NARROW] * [titles count];
    CGFloat h;
    NSInteger padding;
    if(minH < maxH){
        h = minH;
        padding = MARGIN_SMALL;
    }else{
        h = maxH;
        padding = MARGIN_NONE;
    }
    [ac resizeObject:tv w:[ac getW]-[ac getMargin:MARGIN_SUPER]*2 h:h];
    [ac changeX:tv x:[ac getMargin:MARGIN_SMALL]/2];
    [ac changeY:tv y:[ac getMargin:MARGIN_SMALL]/2];
    [ac setLucentBg:tvBack type:BG_DARK];
    [ac resizeObject:tvBack w:[ac getW]-[ac getMargin:MARGIN_SUPER]*2+[ac getMargin:MARGIN_SMALL] h:h+[ac getMargin:MARGIN_SMALL]];
    [ac setY:tvBack yMargin:MARGIN_NORMAL];
    [ac setX:tvBack centerOf:self.view];
    [ac setY:tvBack under:itemLabelPlease withMargin:MARGIN_NORMAL];
}

#pragma mark - specific
-(id) initWithTargetCode:(NSInteger)code{
    self = [super init];
    if(self){
        targetCode = code;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated]; 
    
    [itemLabelNoItem removeFromSuperview];
    [itemLabelPlease removeFromSuperview];
    [tvBack removeFromSuperview];
}

#pragma mark - selectors
-(void) popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view datasource,delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titles count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ac getTableCellH:TABLE_NARROW];
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [ac setLabel:cell.textLabel type:LABEL_CONTENT text:[titles objectAtIndex:indexPath.row] font:FONT_NORMAL];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebUploadViewController *wul = [[WebUploadViewController alloc] initWithTargetCode:targetCode andIndex:(NSInteger)indexPath.row];
    [self.navigationController pushViewController:wul animated:YES];
}

@end
