//
//  WebDownloadListViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"
#import "WebGenreSubView.h"

#define SORT_DATE 0
#define SORT_POP 1

@interface WebDownloadListViewController : ViewControllerCommon<WebGenreSubViewDelegate,NSURLConnectionDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger targetCode;
    NSInteger sortCode;
    NSInteger catCode;
    NSInteger genreCode;
    
    NSInteger page;
    Boolean finalFlg;
    Boolean parseErrFlg;
    Boolean choseGenreFlg;
    
    NSMutableData *receivedData;
    NSInteger found;
    Boolean inTitleTag;
    Boolean inSeqTag;
    Boolean inGenreTag;
    NSMutableString *title;
    NSMutableString *seq;
    NSMutableString *genre;
    NSMutableArray *arrTitles;
    NSMutableArray *arrSeq;
    NSMutableArray *arrGenre;
    UIActivityIndicatorView  *ai;
    
    UILabel *itemSortLabel;
    UISegmentedControl *itemSortSeg;
    UILabel *itemGenreLabel;
    UIButton *itemGenreButton;
    UILabel *itemLabelNoData;
    UITableView *tv;
    UIView *tvBack;
    NSInteger padding;
    
    WebGenreSubView *gv;
    
    UIView *errView;
    UILabel *errLabel;
    UIButton *errBtn;
}

-(id) initWithTargetCode:(NSInteger)code;
-(CGFloat) getTvCellHeight;
-(CGFloat) getTvHeight;
-(void) setTvPosition;
-(void) setGenreCode;
-(void) setGenreLabel;
-(void) resetListTable;
-(void) setArrTitles;
-(void) updateTable;
-(void) showErr;

@end
