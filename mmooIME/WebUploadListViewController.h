//
//  WebUploadListViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"

@interface WebUploadListViewController : ViewControllerCommon<UITableViewDelegate, UITableViewDataSource>{
    NSInteger targetCode;
    NSArray *titles;
    
    UILabel *itemLabelNoItem;
    UILabel *itemLabelPlease;
    UITableView *tv;
    UIView *tvBack;
}

-(id) initWithTargetCode:(NSInteger)code;

@end
