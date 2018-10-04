//
//  WebGenreSubView.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/26.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCommon.h"
#import "AppearanceCommon.h"

#define TOGGLE_SHOW @"show"
#define TOGGLE_HIDE @"hide"

@protocol WebGenreSubViewDelegate <NSObject>
-(void) genreSelected:(NSInteger)gc inCat:(NSInteger)cc;
-(void) genreNotSelected;
@end

@interface WebGenreSubView : UIView<UITableViewDelegate, UITableViewDataSource>{
    NSInteger targetCode;
    NSInteger actionCode;
    NSMutableArray *toggle;
    NSInteger selectedSection;
    NSInteger selectedRow;

    AppearanceCommon *ac;    
    WebCommon *wc;
        
    UITableView *tv;
    UIButton *cancelBtn;
    UIButton *allBtn;
    UILabel *plzSelectLbl;
}

@property (unsafe_unretained, nonatomic) id <WebGenreSubViewDelegate> delegate;

-(id) initWithATargetCode:(NSInteger)t actionCode:(NSInteger)a superView:(UIViewController*)sv;
-(void) setItemPosition;
-(void) refresh;

@end
