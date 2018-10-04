//
//  KeyboardSubView.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/02/09.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "KeyboardSubView.h"
#import "DataKeyboard.h"

@implementation KeyboardSubView
@synthesize delegate = _delegate;
@synthesize tabPage;
@synthesize tabIdx;
@synthesize txtPage;
@synthesize subViewType;

-(id) initWithType:(NSInteger)type superVC:(UIViewController*)vc{
    self = [super init];
    if(self){
        ac = [[AppearanceCommon alloc] initWithViewController:vc];
        
        subViewType = type;
        tabPage = 0;
        tabIdx = 0;
        txtPage = 0;
        
        txts = [[UIView alloc] init];
        UISwipeGestureRecognizer *sgL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dragL)];  
        sgL.direction = UISwipeGestureRecognizerDirectionRight;  
        [txts addGestureRecognizer:sgL];
        UISwipeGestureRecognizer *sgR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dragR)];
        sgR.direction = UISwipeGestureRecognizerDirectionLeft;
        [txts addGestureRecognizer:sgR];
        
        paging = [[UIPageControl alloc] init];
        [paging setHidesForSinglePage:YES];
        [paging addTarget:self action:@selector(txtPageChg:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:txts];
        
        if(subViewType!=TYPE_WITH_TMP){
            tabs = [[UIView alloc] init];
            tabLeft = [[UIButton alloc] init];
            tabRight = [[UIButton alloc] init];
            [tabLeft addTarget:self action:@selector(tabLeft) forControlEvents:UIControlEventTouchUpInside];
            [tabRight addTarget:self action:@selector(tabRight) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tabs];
        }
    }
    return self;
}
-(NSInteger) setTab:(NSInteger)idx{
    NSArray *allTab = [DataKeyboard getAllTabTitles];
    if( idx < [allTab count]){
        tabIdx = idx;
    }
    return tabIdx;
}

-(void) setTabButtons{
    tabButtons = [NSMutableArray array];
    tabRows = [NSMutableArray array];
    
    NSArray *titles = [DataKeyboard getAllTabTitles];
    
    CGFloat w = [self getTabRowW];
    CGFloat x = 0.0f;
    CGFloat newInner, newX;
    NSInteger cnt = 0;
    UIButton *b;
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
    NSInteger rowCnt = 0;
    for(NSInteger i=0; i<titles.count; i++){
        NSString *title = [titles objectAtIndex:i];
        b = [[UIButton alloc] init];
        NSInteger type = (tabIdx==i) ? BUTTON_TYPE_CUSTOM : BUTTON_TYPE_DARK;
        [ac setButton:b type:type title:title imgName:nil];
        [b setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        if(b.frame.size.width > w){
            [ac resizeObject:b w:w h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        }
        b.tag = i;
        [b addTarget:self action:@selector(chgTabIdx:) forControlEvents:UIControlEventTouchUpInside];
        float bw = b.frame.size.width;
        if(x + bw > w){
            newInner = (w-x+[ac getMargin:MARGIN_SMALL]*cnt)/(cnt+1);
            newX = newInner;
            for( UIButton *moveB in row.subviews){
                [moveB setFrame:CGRectMake(newX, 0.0, moveB.frame.size.width, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
                newX += moveB.frame.size.width + newInner;
            }
            [tabRows addObject:row];
            x = 0.0;
            cnt = 1;
            row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
            rowCnt++;
        }
        [tabButtons addObject:b];
        [row addSubview:b];
        cnt ++;
        x += bw + [ac getMargin:MARGIN_SMALL];
        if(tabIdx==i){
            tabPage = rowCnt;
        }
    }
    
    newInner = (w-x+[ac getMargin:MARGIN_SMALL]*cnt)/(cnt+1);
    newX = newInner;
    for( UIButton *moveB in row.subviews){
        [moveB setFrame:CGRectMake(newX, 0.0, moveB.frame.size.width, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
        newX += moveB.frame.size.width +newInner;
    }
    [tabRows addObject:row];
}
-(void) setTxtButtons{
    txtButtons = [NSMutableArray array];
    txtRows = [NSMutableArray array];
    
    CGFloat w = [ac getW];
    CGFloat x = 0.0f;
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
    NSArray *titles;
    if(subViewType==TYPE_WITH_TMP){
        titles = [DataKeyboard getTmpTxts];
    }else{
        titles = [DataKeyboard getTxtsByTabIndex:tabIdx];
    }
    
    Boolean isEmpty;
    if(titles==nil){
        isEmpty = YES;
    }else if( [titles count]==1 && [[titles objectAtIndex:0] isEqualToString:@"null"] ){
        isEmpty = YES;
    }else{
        isEmpty = NO;
    }    
    
    if(isEmpty){
        if(subViewType==TYPE_TO_EDIT){
            UIButton *b = [[UIButton alloc] init];
            [ac setButton:b type:BUTTON_TYPE_LIGHT title:@" = = N E W = = " imgName:nil];
            b.tag = 0;
            [b addTarget:self action:@selector(chgTxtIdx:) forControlEvents:UIControlEventTouchUpInside];
            [ac setX:b centerOf:row];
            [ac setY:b yMargin:MARGIN_NONE];
            [txtButtons addObject:b];
            [row addSubview:b];
            [txtRows addObject:row];
        }else{
            UILabel *lbl = [[UILabel alloc] init];
            [ac setLabel:lbl type:LABEL_WHITE text:@"NO ITEM" font:FONT_LARGE];
            [ac setX:lbl centerOf:row];
            [ac setY:lbl yMargin:MARGIN_SUPER];
            [row addSubview:lbl];
            [txtRows addObject:row];
        }
    }else{
        for(NSInteger i=0; i<titles.count; i++){
            NSString *title = [titles objectAtIndex:i];
            UIButton *b = [[UIButton alloc] init];
            [ac setButton:b type:BUTTON_TYPE_LIGHT title:title imgName:nil];
            [b setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            if(b.frame.size.width > w){ 
                [ac resizeObject:b w:w h:b.frame.size.height];
            }
            b.tag = i;
            [b addTarget:self action:@selector(chgTxtIdx:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat bw = b.frame.size.width;
            if(x + bw > w){
                CGFloat xx = 0.0f;
                for(UIButton *bb in [row subviews]){
                    bb.frame = CGRectMake(xx, 0, bb.frame.size.width*w/x, [ac getButtonSize:BUTTON_SIZE_NORMAL]);
                    xx += bb.frame.size.width;
                }
                [txtRows addObject:row];
                x = 0.0;
                row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
            }
            [b setFrame:CGRectMake(x, 0.0, bw, [ac getButtonSize:BUTTON_SIZE_NORMAL])];
            [txtButtons addObject:b];
            [row addSubview:b];
            x += bw;
        }
        CGFloat xx = 0.0f;
        for(UIButton *bb in [row subviews]){
            bb.frame = CGRectMake(xx, 0, bb.frame.size.width*w/x, [ac getButtonSize:BUTTON_SIZE_NORMAL]);
            xx += bb.frame.size.width;
        }
        if(row.subviews.count>0){
            [txtRows addObject:row];
        }
    }
}

-(void) setTabAppearence{
    for( UIView *v in [tabs subviews] ){
        [v removeFromSuperview];
    }
    
    if( [tabRows count]>0 ){
        if([tabRows count] <= tabPage){
            tabPage = 0;
        }
        UIView *tv = [tabRows objectAtIndex:tabPage];
        [ac setButton:tabLeft type:BUTTON_TYPE_RICH title:nil imgName:@"left.png" w:[ac getButtonSize:BUTTON_SIZE_ARROW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        [tabLeft setEnabled:tabPage>0];
        [ac setButton:tabRight type:BUTTON_TYPE_RICH title:nil imgName:@"right.png" w:[ac getButtonSize:BUTTON_SIZE_ARROW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        [tabRight setEnabled:tabPage<tabRows.count-1];
    
        [tabs addSubview:tv];
        [tabs addSubview:tabLeft];
        [tabs addSubview:tabRight];
        [ac setY:tv yMargin:MARGIN_NONE];
        [ac setY:tabLeft nextTo:tv];
        [ac setY:tabRight nextTo:tv];
        [ac resizeObject:tabs w:[ac getW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        [ac setX:tabLeft xMargin:MARGIN_SMALL];
        [ac setX:tv centerOf:tabs];
        [ac setX:tabRight xRightMargin:MARGIN_SMALL of:tabs];
    }
}
-(void) setTxtAppearence{
    for( UIView *v in [txts subviews] ){
        [v removeFromSuperview];
    }
    
    NSInteger rows = [ac isShort] ? 2 : 3;
    
    paging.numberOfPages = (txtRows.count - 1) / rows + 1;
    if(paging.numberOfPages <= txtPage){
        txtPage = paging.numberOfPages-1;
    }
    paging.currentPage = txtPage;
    [ac resizeObject:paging w:[ac getW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
    [ac setX:paging xMargin:MARGIN_NONE];
    [ac setY:paging yMargin:MARGIN_NONE];
    [txts addSubview:paging];
    
    UIView *row1, *row2, *row3;
    if( txtRows.count > txtPage*rows ){
        row1 = [txtRows objectAtIndex:txtPage*rows];
        [ac setX:row1 xMargin:MARGIN_NONE];
        [ac setY:row1 under:paging withMargin:MARGIN_NONE];
        [txts addSubview:row1];
    }
    if( txtRows.count > txtPage*rows+1 ){
        row2 = [txtRows objectAtIndex:txtPage*rows+1];
        [ac setX:row2 xMargin:MARGIN_NONE];
        [ac setY:row2 under:row1 withMargin:MARGIN_NONE];
        [txts addSubview:row2];
    }
    if( ![ac isShort] && txtRows.count > txtPage*rows+2 ){
        row3 = [txtRows objectAtIndex:txtPage*rows+2];
        [ac setX:row3 xMargin:MARGIN_NONE];
        [ac setY:row3 under:row2 withMargin:MARGIN_NONE];
        [txts addSubview:row3];
    }
    
    [ac resizeObject:txts w:[ac getW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]*(rows+1)];
}
-(void) setWholeAppearence{
    [ac resetColorCode];
    [self setTxtButtons];
    [self setTxtAppearence];
    [ac resizeObject:paging w:[ac getW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
    if(subViewType!=TYPE_WITH_TMP){
        [self setTabButtons];
        [self setTabAppearence];
    }
    
    [ac setX:txts xMargin:MARGIN_NONE];
    [ac setY:txts yMargin:MARGIN_NONE];
    [ac setX:tabs xMargin:MARGIN_NONE];
    [ac setY:tabs under:txts withMargin:MARGIN_LARGE];
    [ac setSubView:self type:SUBVIEW_SQUARE xPadding:MARGIN_NONE yPadding:MARGIN_NORMAL];
}

-(void) setHighLightTab:(NSInteger)idx{
    if(idx>=0 && idx<tabButtons.count){
        UIButton *b = [tabButtons objectAtIndex:idx];
        [ac setButton:b type:BUTTON_TYPE_HIGHLIGHT title:b.titleLabel.text imgName:nil w:0 h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        if(b.frame.size.width > [self getTabRowW] ){
            [ac resizeObject:b w:[self getTabRowW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        }
    }
}
-(void) removeHighLightTab:(NSInteger)idx{
    if(idx>=0 && idx<tabButtons.count){
        UIButton *b = [tabButtons objectAtIndex:idx];
        NSInteger type = (tabIdx==idx) ? BUTTON_TYPE_CUSTOM : BUTTON_TYPE_DARK;
        [ac setButton:b type:type title:b.titleLabel.text imgName:nil w:0 h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        if(b.frame.size.width > [self getTabRowW] ){
            [ac resizeObject:b w:[self getTabRowW] h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
        }
    }
}
-(void) setHighLightTxt:(NSInteger)idx{
    if(idx>=0 && idx<txtButtons.count){
        UIButton *b = [txtButtons objectAtIndex:idx];
        b.backgroundColor = [UIColor yellowColor];
    }
}
-(void) removeHighLightTxt:(NSInteger)idx{
    if(idx>=0 && idx<txtButtons.count){
        UIButton *b = [txtButtons objectAtIndex:idx];
        b.backgroundColor = [UIColor whiteColor];
    }
}
-(CGFloat) getTabRowW{
    return [ac getW] - [ac getButtonSize:BUTTON_SIZE_ARROW]*2 - [ac getMargin:MARGIN_SMALL]*4;
}

#pragma mark - selectors
-(void) tabLeft{
    tabPage --;
    [self setTabAppearence];
}
-(void) tabRight{
    tabPage ++;
    [self setTabAppearence];
}
-(void) chgTabIdx:(UIButton*)sender{
    if(tabIdx != sender.tag){
        tabIdx = sender.tag;
        [self setTabButtons];
        [self setTabAppearence];
    }
    
    txtPage = 0;
    [self setTxtButtons];
    [self setTxtAppearence];
    
    if ([self.delegate respondsToSelector:@selector(tabSelected:)]){
        [self.delegate tabSelected:sender];
    }
}
-(void) txtPageChg:(UIPageControl*)sender{
    txtPage = paging.currentPage;
    [self setTxtAppearence];
}
-(void) dragL{
    if(txtPage > 0){
        txtPage --;
    }
    [self setTxtAppearence];
}
-(void) dragR{
    if(txtPage < paging.numberOfPages-1){
        txtPage ++;
    }
    [self setTxtAppearence];
}

-(void) chgTxtIdx:(UIButton*)sender{
    if( [self.delegate respondsToSelector:@selector(txtSelected:)]){
        [self.delegate txtSelected:sender];
    }
}
@end