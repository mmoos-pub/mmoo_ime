//
//  WebGenreSubView.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/26.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebGenreSubView.h"
#import "LangCommon.h"

@implementation WebGenreSubView
@synthesize delegate = _delegate;

#pragma mark - mmoo
-(id) initWithATargetCode:(NSInteger)t actionCode:(NSInteger)a superView:(UIViewController*)sv{
    self = [super init];
    if(self){
        ac = [[AppearanceCommon alloc] initWithViewController:sv];
        
        targetCode = t;
        actionCode = a;
        wc = [[WebCommon alloc] initWithTargetCode:targetCode];
        toggle = [[NSMutableArray alloc] init];
        for(NSInteger i=0; i<[wc getCatCnt]; i++){
            [toggle addObject:TOGGLE_HIDE];
        }
        selectedSection = -1;
        selectedRow = -1;
        
        cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(destroy) forControlEvents:UIControlEventTouchDown];
        [self addSubview:cancelBtn];
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) style:UITableViewStyleGrouped];
        [tv setDelegate:self];
        [tv setDataSource:self];
        [ac setLucentBg:tv type:BG_LIGHT];
        [self addSubview:tv];
    }
    return self;
}
-(void) setItemPosition{
    [ac resetColorCode];
    LangCommon *lc = [[LangCommon alloc] init];
    [allBtn removeFromSuperview];
    [plzSelectLbl removeFromSuperview];
    
    [ac setButton:cancelBtn type:BUTTON_TYPE_CUSTOM title:@"" imgName:@"icon_delete.png" w:[ac getButtonSize:BUTTON_SIZE_SMALL] h:[ac getButtonSize:BUTTON_SIZE_SMALL]];
    
    if(actionCode==ACTION_DOWNLOAD){
        allBtn = [[UIButton alloc] init];
        [allBtn addTarget:self action:@selector(genreAll) forControlEvents:UIControlEventTouchUpInside];
        [ac setButton:allBtn 
                type:BUTTON_TYPE_RICH 
                title:[lc getTranslated:TRNS_D_GENRE_ALL]
                imgName:nil
                w:0
                h:[ac getButtonSize:BUTTON_SIZE_SMALL]
        ];
        [ac setX:allBtn xMargin:MARGIN_NORMAL];
        [ac setY:allBtn yMargin:MARGIN_NORMAL];
        [self addSubview:allBtn];
    }else{
        plzSelectLbl = [[UILabel alloc] init];
        [ac setLabel:plzSelectLbl type:LABEL_WHITE text:[lc getTranslated:TRNS_U_GENRE_SELECT] font:FONT_NORMAL];
        [ac setX:plzSelectLbl xMargin:MARGIN_NORMAL];
        [ac setY:plzSelectLbl yMargin:MARGIN_NORMAL];
        [self addSubview:plzSelectLbl];
    }
    
    [ac setY:cancelBtn yMargin:MARGIN_SMALL];
    CGFloat y = [ac getMargin:MARGIN_NORMAL] + [ac getMargin:MARGIN_SMALL] + [ac getButtonSize:BUTTON_SIZE_NORMAL];
    [tv setFrame:CGRectMake(
        [ac getMargin:MARGIN_SMALL],
        y,
        [ac getW] - [ac getMargin:MARGIN_NORMAL]*2 - [ac getMargin:MARGIN_SMALL]*2,
        [ac getH] - [ac getMargin:MARGIN_SMALL]*2 - [ac getMargin:MARGIN_NORMAL] - y
    )];
    [tv reloadData];
    [ac setSubView:self type:SUBVIEW_SQUARE xPadding:MARGIN_SMALL yPadding:MARGIN_NORMAL];
    [ac setY:self yMargin:MARGIN_SMALL];
    [ac setX:cancelBtn xRightMargin:MARGIN_SMALL of:self];
}
-(void) refresh{
    [tv reloadData];
}

#pragma mark - selectors
-(void) genreAll{
    selectedSection = -1;
    selectedRow = -1;
    if ([self.delegate respondsToSelector:@selector(genreSelected: inCat:)]){
        [self.delegate genreSelected:GENRE_NONE inCat:GENRE_NONE];
    }
}
-(void) destroy{
    if( [self.delegate respondsToSelector:@selector(genreNotSelected) ] ){
        [self.delegate genreNotSelected];
    }
}
-(void) toggle:(UIButton*)sender{
    NSMutableArray *toCopy = [[NSMutableArray alloc] init];
    for(NSInteger i=0; i<toggle.count; i++){
        if( i==sender.tag && [[toggle objectAtIndex:sender.tag] isEqual:TOGGLE_SHOW] ){
            [toCopy addObject:TOGGLE_HIDE];
        }else if(i==sender.tag){
            [toCopy addObject:TOGGLE_SHOW];
        }else{
            [toCopy addObject:[toggle objectAtIndex:i]];
        }
    }
    toggle = toCopy;
    [tv reloadData];
}

#pragma mark - Table view datasource,delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [wc getCatCnt];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[toggle objectAtIndex:section] isEqual:TOGGLE_SHOW]){
        return [wc getGenreCntInCat:section];
    }else{
        return 0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[toggle objectAtIndex:indexPath.section] isEqual:TOGGLE_SHOW]){
        return [ac getTableCellH:TABLE_NARROW];
    }else{
        return 0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger margin = section==0 ? MARGIN_NORMAL : MARGIN_NONE;
    return [ac getButtonSize:BUTTON_SIZE_NORMAL]+[ac getMargin:margin];
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *btn = [[UIButton alloc] init];
    NSInteger btnType = [[toggle objectAtIndex:section] isEqual:TOGGLE_SHOW] ? BUTTON_TYPE_DARK : BUTTON_TYPE_CUSTOM;
    CGFloat padding = [ac isIpad] ? 80.0 : 20.0;
    [ac setButton:btn type:btnType title:[wc getCat:section] imgName:nil w:tableView.bounds.size.width-padding h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
    btn.tag = section;
    [btn addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchDown];
    NSInteger margin = section==0 ? MARGIN_NORMAL : MARGIN_NONE;
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [ac getButtonSize:BUTTON_SIZE_NORMAL]+[ac getMargin:margin])];
    [hv addSubview:btn];
    [ac setX:btn centerOf:hv];
    [ac setY:btn yMargin:margin];
    return hv;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [ac setLabel:cell.textLabel type:LABEL_CONTENT text:[wc getGenre:indexPath.row inCat:indexPath.section type:GENRE_TYPE_STR] font:FONT_NORMAL];
    
    if(indexPath.section==selectedSection && indexPath.row==selectedRow){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{ 
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedSection = indexPath.section;
    selectedRow = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(genreSelected: inCat:)]){
        [self.delegate genreSelected:indexPath.row inCat:indexPath.section];
    }
}

@end