//
//  TextListViewController.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/17.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewControllerCommon.h"

@interface TextListViewController : ViewControllerCommon<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tv;
}

-(void) setNav;
-(void) goToEdit:(NSString*)textID;

@end
