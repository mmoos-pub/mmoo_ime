//
//  KeyboardSettingViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/29.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "KeyboardSettingViewController.h"
#import "DataKeyboard.h"
#import "KeyboardSubView.h"

@implementation KeyboardSettingViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    targetTabIdx = -1;
    targetTxtIdx = -1;
    
    ksv = [[KeyboardSubView alloc] initWithType:TYPE_TO_EDIT superVC:self];
    ksv.delegate = self;
    [self.view addSubview:ksv];
    
    itemExecuteActionView = [[UIView alloc] init];
    itemExecuteButtonsView = [[UIView alloc] init];
    itemText = [[UITextField alloc] init];
    itemOkButton = [[UIButton alloc] init];
    itemCancelButton = [[UIButton alloc] init];
    [itemExecuteButtonsView addSubview:itemText];
    [itemExecuteButtonsView addSubview:itemOkButton];
    [itemExecuteButtonsView addSubview:itemCancelButton];
    [itemExecuteActionView addSubview:itemExecuteButtonsView];
    
    actionBtnView = [[UIView alloc] init];
    actionBtnDelete = [[UIButton alloc] init];
    actionBtnEdit = [[UIButton alloc] init];
    actionBtnInsertLeft = [[UIButton alloc] init];
    actionBtnInsertRight = [[UIButton alloc] init];
    actionBtnMoveLeft = [[UIButton alloc] init];
    actionBtnMoveRight = [[UIButton alloc] init];
    actionBtnCancel = [[UIButton alloc] init];
    actionBtnDelete.tag = ACTION_DELETE;
    actionBtnEdit.tag = ACTION_EDIT;
    actionBtnInsertLeft.tag = ACTION_INSERT_LEFT;
    actionBtnInsertRight.tag = ACTION_INSERT_RIGHT;
    actionBtnMoveLeft.tag = ACTION_MOVE_LEFT;
    actionBtnMoveRight.tag = ACTION_MOVE_RIGHT;
    actionBtnCancel.tag = ACTION_CANCEL;
    [actionBtnView addSubview:actionBtnDelete];
    [actionBtnView addSubview:actionBtnEdit];
    [actionBtnView addSubview:actionBtnInsertLeft];
    [actionBtnView addSubview:actionBtnInsertRight];
    [actionBtnView addSubview:actionBtnMoveLeft];
    [actionBtnView addSubview:actionBtnMoveRight];
    [actionBtnView addSubview:actionBtnCancel];
    [actionBtnDelete addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnEdit addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnInsertLeft addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnInsertRight addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnMoveLeft addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnMoveRight addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtnCancel addTarget:self action:@selector(actSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    itemConfirmView = [[UIView alloc] init];
    itemConfirmButtonsView = [[UIView alloc] init];
    itemConfirmLabel = [[UILabel alloc] init];
    itemYesButton = [[UIButton alloc] init];
    itemNoButton = [[UIButton alloc] init];
    [itemConfirmView addSubview:itemConfirmLabel];
    [itemConfirmButtonsView addSubview:itemYesButton];
    [itemConfirmButtonsView addSubview:itemNoButton];
    [itemConfirmView addSubview:itemConfirmButtonsView];
    [itemCancelButton addTarget:self action:@selector(actReset) forControlEvents:UIControlEventTouchUpInside];
    [itemOkButton addTarget:self action:@selector(actOK) forControlEvents:UIControlEventTouchUpInside]; 
    [itemYesButton addTarget:self action:@selector(actDelete) forControlEvents:UIControlEventTouchUpInside];
    [itemNoButton addTarget:self action:@selector(actReset) forControlEvents:UIControlEventTouchUpInside];
}
-(void) setAppearance{
    [ac setNavTitle:[lc getTranslated:TRNS_KBD_TITLE]];
    [ac setButton:itemCancelButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
}
-(void) setItemPosition{
    for( UIView *v in self.view.subviews ){
        if(v==itemExecuteActionView){
            [self setActSub];
        }
        if(v==itemConfirmView){
            [self setConfirmSub];
        }
        if(v==actionBtnView){
            [self setActionBtnsSub];
        }
    }
    
    [ksv setWholeAppearence];
    if(targetTabIdx>=0 && targetTxtIdx<0){
        [ksv setHighLightTab:targetTabIdx];
    }else if(targetTabIdx>=0 && targetTxtIdx>=0){
        [ksv setHighLightTxt:targetTxtIdx];
    }
    
    CGFloat plus = [ac isShort] ? [ac getMargin:MARGIN_SMALL]*4 : [ac getMargin:MARGIN_NORMAL]*3+[ac getMargin:MARGIN_LARGE];
    [ac setX:ksv xMargin:MARGIN_NONE];
    [ac changeY:ksv y:[ac getButtonSize:BUTTON_SIZE_NORMAL]+plus];
}

#pragma mark - specific
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated]; 
    [self actReset];
}
-(void) setConfirmSub{    
    [ac setLabel:itemConfirmLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_KBD_SURE] font:FONT_NORMAL];    
    [ac setButton:itemYesButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_DELETE] imgName:nil];
    [ac setButton:itemNoButton type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_CANCEL] imgName:nil];
    
    [ac setY:itemConfirmLabel yMargin:MARGIN_LARGE];
    [ac setX:itemYesButton xMargin:MARGIN_NONE];
    [ac setY:itemYesButton yMargin:MARGIN_NONE];
    [ac setX:itemNoButton rightOf:itemYesButton withMargin:MARGIN_NORMAL];
    [ac setY:itemNoButton nextTo:itemYesButton];
    [ac fitOuter:itemConfirmButtonsView];
    [ac setY:itemConfirmButtonsView under:itemConfirmLabel withMargin:MARGIN_NORMAL];    
    [ac setSubView:itemConfirmView type:SUBVIEW_ROUND xPadding:MARGIN_LARGE yPadding:MARGIN_LARGE];
    [ac setY:itemConfirmView yMargin:MARGIN_LARGE];
    [ac setX:itemConfirmLabel centerOf:itemConfirmView];
    [ac setX:itemConfirmButtonsView centerOf:itemConfirmView];
}
-(void) setActSub{        
    NSString *txt = @"";
    NSString *btnTxt = @"";
    if(actionCode==ACTION_EDIT){
        btnTxt = [lc getTranslated:TRNS_EDIT];
        if(targetCode==TARGET_TAB){
            txt = [[DataKeyboard getAllTabTitles] objectAtIndex:targetTabIdx];
        }else if(targetCode==TARGET_TXT){
            txt = [[DataKeyboard getTxtsByTabIndex:targetTabIdx] objectAtIndex:targetTxtIdx];
        }
    }else if(actionCode==ACTION_INSERT_LEFT){
        btnTxt = [lc getTranslated:TRNS_KBD_INSERT_LEFT];
    }else if(actionCode==ACTION_INSERT_RIGHT){
        btnTxt = [lc getTranslated:TRNS_KBD_INSERT_RIGHT];
    }
    NSString *ph = targetCode==TARGET_TAB ? [lc getTranslated:TRNS_TXT_TITLE_PLACEFOLDER] : @"";
    [ac setTextField:itemText text:txt placeHolder:ph];
    if(![btnTxt isEqual:@""]){
        [ac setButton:itemOkButton type:BUTTON_TYPE_RICH title:btnTxt imgName:nil];
    }
    
    CGFloat xPadding = [ac isSlim] ? MARGIN_SMALL : MARGIN_NORMAL;
    CGFloat yPadding = [ac isShort] ? MARGIN_SMALL : MARGIN_NORMAL;
    CGFloat yMargin = [ac isShort] ? MARGIN_SMALL : MARGIN_LARGE;
    [ac resizeObject:itemText w:[ac getW]-itemOkButton.frame.size.width-itemCancelButton.frame.size.width-[ac getMargin:MARGIN_NORMAL]*4-[ac getMargin:xPadding]*2 h:[ac getButtonSize:BUTTON_SIZE_NORMAL]];
    [ac setX:itemText xMargin:MARGIN_NONE];
    [ac setY:itemText yMargin:MARGIN_NONE];
    [ac setX:itemOkButton rightOf:itemText withMargin:MARGIN_NORMAL];
    [ac setY:itemOkButton nextTo:itemText];
    [ac setX:itemCancelButton rightOf:itemOkButton withMargin:MARGIN_NORMAL];
    [ac setY:itemCancelButton nextTo:itemText];
    [ac fitOuter:itemExecuteButtonsView];
    [ac setY:itemExecuteButtonsView yMargin:yPadding];
    [ac setSubView:itemExecuteActionView type:SUBVIEW_ROUND xPadding:xPadding yPadding:yPadding];
    [ac setY:itemExecuteActionView yMargin:yMargin];
    [ac setX:itemExecuteButtonsView centerOf:itemExecuteActionView];
}
-(void) setActionBtnsSub{
    [itemExecuteActionView removeFromSuperview];
    [itemConfirmView removeFromSuperview];
    
    CGFloat w, h;
    if( [ac isShort] ){
        w = ( [ac getW] - [ac getMargin:MARGIN_NORMAL]*3 - [ac getMargin:MARGIN_SMALL]*2 ) / 2;
        h = ( [ac getH] - [ac getMargin:MARGIN_NORMAL]*3 - [ac getMargin:MARGIN_LARGE]*2 ) / 4;
    }else{
        w = [ac getW] - [ac getMargin:MARGIN_NORMAL]*2 - [ac getMargin:MARGIN_SMALL]*2;
        h = ( [ac getH] - [ac getMargin:MARGIN_NORMAL]*6 - [ac getMargin:MARGIN_LARGE]*2 ) / 7;
    }
    [ac setButton:actionBtnDelete type:BUTTON_ACTION_DELETE title:[lc getTranslated:TRNS_DELETE] imgName:nil w:w h:h];
    [ac setButton:actionBtnEdit type:BUTTON_ACTION_EDIT title:[lc getTranslated:TRNS_EDIT] imgName:nil w:w h:h];
    [ac setButton:actionBtnInsertLeft type:BUTTON_ACTION_INSERT title:[lc getTranslated:TRNS_KBD_INSERT_LEFT] imgName:nil w:w h:h];
    [ac setButton:actionBtnInsertRight type:BUTTON_ACTION_INSERT title:[lc getTranslated:TRNS_KBD_INSERT_RIGHT] imgName:nil w:w h:h];
    [ac setButton:actionBtnMoveLeft type:BUTTON_ACTION_MOVE title:[lc getTranslated:TRNS_KBD_MOVE_LEFT] imgName:nil w:w h:h];
    [ac setButton:actionBtnMoveRight type:BUTTON_ACTION_MOVE title:[lc getTranslated:TRNS_KBD_MOVE_RIGHT] imgName:nil w:w h:h];
    NSInteger trnsCancel = (targetCode==TARGET_TAB) ? TRNS_KBD_CANCEL : TRNS_CANCEL;
    [ac setButton:actionBtnCancel type:BUTTON_ACTION_CANCEL title:[lc getTranslated:trnsCancel] imgName:nil w:w h:h];
    
    tabIDs = [DataKeyboard getAllTabID];
    NSArray *titles;
    NSInteger targetIdx;
    if(targetCode==TARGET_TAB){
        titles = [DataKeyboard getAllTabTitles];
        targetIdx = targetTabIdx;
    }else{
        titles = [DataKeyboard getTxtsByTabIndex:targetTabIdx];
        targetIdx = targetTxtIdx;
    }
    NSUInteger titleCnt = titles.count;
    
    [actionBtnDelete setEnabled:titleCnt>1 ];
    [actionBtnInsertLeft setEnabled:(targetCode==TARGET_TAB || titleCnt>0)];
    [actionBtnInsertRight setEnabled:(targetCode==TARGET_TAB || titleCnt>0)];
    [actionBtnMoveLeft setEnabled:(titleCnt>1 && targetIdx>0)];
    [actionBtnMoveRight setEnabled:(titleCnt>1 && targetIdx<titleCnt-1)];
    
    [ac setLucentBg:actionBtnView type:BG_DARK];
    [actionBtnView setFrame:CGRectMake(
        [ac getMargin:MARGIN_SMALL],
        0,
        [ac getW]-[ac getMargin:MARGIN_SMALL]*2, 
        [ac getH]
    )];
    
    if( [ac isShort] ){
        [ac setX:actionBtnDelete xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnEdit rightOf:actionBtnDelete withMargin:MARGIN_NORMAL];
        [ac setX:actionBtnInsertLeft xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnInsertRight rightOf:actionBtnInsertLeft withMargin:MARGIN_NORMAL];
        [ac setX:actionBtnMoveLeft xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnMoveRight rightOf:actionBtnMoveLeft withMargin:MARGIN_NORMAL];
        [ac setX:actionBtnCancel centerOf:actionBtnView];
        
        [ac setY:actionBtnDelete yMargin:MARGIN_LARGE];
        [ac setY:actionBtnEdit nextTo:actionBtnDelete];
        [ac setY:actionBtnInsertLeft under:actionBtnEdit withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnInsertRight nextTo:actionBtnInsertLeft];
        [ac setY:actionBtnMoveLeft under:actionBtnInsertRight withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnMoveRight nextTo:actionBtnMoveLeft];
        [ac setY:actionBtnCancel under:actionBtnMoveRight withMargin:MARGIN_NORMAL];
    }else{
        [ac setX:actionBtnDelete xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnEdit xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnInsertLeft xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnInsertRight xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnMoveLeft xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnMoveRight xMargin:MARGIN_NORMAL];
        [ac setX:actionBtnCancel xMargin:MARGIN_NORMAL];
    
        [ac setY:actionBtnDelete yMargin:MARGIN_LARGE];
        [ac setY:actionBtnEdit under:actionBtnDelete withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnInsertLeft under:actionBtnEdit withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnInsertRight under:actionBtnInsertLeft withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnMoveLeft under:actionBtnInsertRight withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnMoveRight under:actionBtnMoveLeft withMargin:MARGIN_NORMAL];
        [ac setY:actionBtnCancel under:actionBtnMoveRight withMargin:MARGIN_NORMAL];
    }
}
-(void) actReset{
    [ksv removeHighLightTab:targetTabIdx];
    [ksv removeHighLightTxt:targetTxtIdx];
    targetTabIdx = -1;
    targetTxtIdx = -1;
    actionCode = 0;
    [itemExecuteActionView removeFromSuperview];
    [itemConfirmView removeFromSuperview];
    [actionBtnView removeFromSuperview];
}

#pragma mark - selectors
-(void) actOK{
    switch (targetCode) {
        case TARGET_TAB:
            if(actionCode==ACTION_EDIT){
                [DataKeyboard saveTabTitle:[itemText text] withTabIdx:targetTabIdx];
            }else if(actionCode==ACTION_INSERT_LEFT){
                NSString *newID = [DataKeyboard getNewTabID];
                NSMutableArray *newArray = [NSMutableArray arrayWithArray:tabIDs];
                [newArray insertObject:newID atIndex:targetTabIdx];
                [DataKeyboard saveAllTabID:newArray];
                [DataKeyboard saveTabTitle:[itemText text] withTabID:newID];
                [ksv setTxtButtons];
                [ksv setTxtAppearence];
            }else if(actionCode==ACTION_INSERT_RIGHT){
                NSString *newID = [DataKeyboard getNewTabID];
                NSMutableArray *newArray = [NSMutableArray arrayWithArray:tabIDs];
                [newArray insertObject:newID atIndex:targetTabIdx+1];
                [DataKeyboard saveAllTabID:newArray];
                [DataKeyboard saveTabTitle:[itemText text] withTabID:newID];
                ksv.tabIdx = targetTabIdx+1;
                [ksv setTxtButtons];
                [ksv setTxtAppearence];
            }
            [ksv setTabButtons];
            [ksv setTabAppearence];
            break;
        case TARGET_TXT:
            if(actionCode==ACTION_EDIT){
                NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];
                NSString *newB = [itemText text];
                if(newB==nil){ newB = @""; }
                if( newTxts.count!=0){
                    [newTxts removeObjectAtIndex:targetTxtIdx];
                }
                [newTxts insertObject:newB atIndex:targetTxtIdx];
                [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];
            }else if(actionCode==ACTION_INSERT_LEFT){
                NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];           
                [newTxts insertObject:[itemText text] atIndex:targetTxtIdx];
                [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];                
            }else if(actionCode==ACTION_INSERT_RIGHT){
                NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];            
                [newTxts insertObject:[itemText text] atIndex:targetTxtIdx+1];
                [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];            
            }
            [ksv setTxtButtons];
            [ksv setTxtAppearence];
            break;            
        default:
            break;
    }
    [self actReset];
}
-(void) actDelete{
    if(targetCode == TARGET_TAB){
        [DataKeyboard deleteTabDataByIndex:targetTabIdx];
        NSMutableArray *newTabIDs = [NSMutableArray arrayWithArray:tabIDs];
        [newTabIDs removeObjectAtIndex:targetTabIdx];
        [DataKeyboard saveAllTabID:newTabIDs];
        ksv.tabIdx = 0;
        [ksv setTabButtons];
        [ksv setTabAppearence];
        [ksv setTxtButtons];
        [ksv setTxtAppearence];
        [self actReset];
    }else if(targetCode == TARGET_TXT){
        NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];
        [newTxts removeObjectAtIndex:targetTxtIdx];
        [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];
        [ksv setTxtButtons];
        [ksv setTxtAppearence];
        [self actReset];
    }
}
-(void) actSelected:(UIButton*)sender{
    actionCode = sender.tag;
    
    switch (actionCode) {
        case ACTION_EDIT:
        case ACTION_INSERT_LEFT:
        case ACTION_INSERT_RIGHT:
            [self setActSub];
            [self.view addSubview:itemExecuteActionView];
            break;            
        case ACTION_MOVE_LEFT:
            if(targetCode == TARGET_TAB){
                if(targetTabIdx>0){
                    NSMutableArray *newTabIDs = [NSMutableArray arrayWithArray:tabIDs];
                    [newTabIDs exchangeObjectAtIndex:targetTabIdx withObjectAtIndex:targetTabIdx-1];
                    [DataKeyboard saveAllTabID:newTabIDs];
                }
                ksv.tabIdx = targetTabIdx-1;
                [ksv setTabButtons];
                [ksv setTabAppearence];
                [self actReset];
            }else if(targetCode == TARGET_TXT){
                if(targetTxtIdx>0){
                    NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];
                    [newTxts exchangeObjectAtIndex:targetTxtIdx withObjectAtIndex:targetTxtIdx-1];
                    [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];
                }
                [ksv setTxtButtons];
                [ksv setTxtAppearence];
                [self actReset];
            }
            break;            
        case ACTION_MOVE_RIGHT:
            if(targetCode == TARGET_TAB){
                NSMutableArray *newTabIDs = [NSMutableArray arrayWithArray:tabIDs];
                if(newTabIDs.count>targetTabIdx+1){
                    [newTabIDs exchangeObjectAtIndex:targetTabIdx withObjectAtIndex:targetTabIdx+1];
                    [DataKeyboard saveAllTabID:newTabIDs];
                }
                ksv.tabIdx = targetTabIdx+1;
                [ksv setTabButtons];
                [ksv setTabAppearence];
                [self actReset];
            }else if(targetCode == TARGET_TXT){
                NSMutableArray *newTxts = [NSMutableArray arrayWithArray:[DataKeyboard getTxtsByTabIndex:targetTabIdx]];
                if(newTxts.count>targetTxtIdx+1){
                    [newTxts exchangeObjectAtIndex:targetTxtIdx withObjectAtIndex:targetTxtIdx+1];
                    [DataKeyboard saveTxts:newTxts withTabIdx:targetTabIdx];
                }
                [ksv setTxtButtons];
                [ksv setTxtAppearence];
                [self actReset];
            }
            break;
        case ACTION_DELETE:
            [self setConfirmSub];
            [self.view addSubview:itemConfirmView];
            break;            
        default:
            [self actReset];
            break;
    }
    [actionBtnView removeFromSuperview];
}

#pragma mark - keybordSub delegate
-(void) tabSelected:(UIButton*)sender{
    [ksv removeHighLightTab:targetTabIdx];
    [ksv removeHighLightTxt:targetTxtIdx];
    [ksv setHighLightTab:ksv.tabIdx];
    
    targetCode = TARGET_TAB;
    actionCode = ACTION_EDIT;
    targetTabIdx = ksv.tabIdx;
    targetTxtIdx = -1;
    [self setActionBtnsSub];
    [ac slideUp:actionBtnView onto:self.view];
}
-(void) txtSelected:(UIButton*)sender{
    [ksv removeHighLightTab:targetTabIdx];
    [ksv removeHighLightTxt:targetTxtIdx];
    [ksv setHighLightTxt:sender.tag];
    
    targetCode = TARGET_TXT;
    actionCode = ACTION_EDIT;
    targetTabIdx = ksv.tabIdx;
    targetTxtIdx = sender.tag;
    [self setActionBtnsSub];
    [ac slideUp:actionBtnView onto:self.view];
}

@end