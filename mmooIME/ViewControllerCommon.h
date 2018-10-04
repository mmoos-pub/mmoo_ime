//
//  ViewControllerCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppearanceCommon.h"
#import "LangCommon.h"

@interface ViewControllerCommon  : UIViewController{
    AppearanceCommon *ac;
    LangCommon *lc;
}

-(void) initSubViews;
-(void) setAppearance;
-(void) setItemPosition;

@end
