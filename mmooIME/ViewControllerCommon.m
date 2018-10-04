//
//  ViewControllerCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "ViewControllerCommon.h"

@implementation ViewControllerCommon

-(void) didReceiveMemoryWarning{ [super didReceiveMemoryWarning]; }
-(void) viewDidUnload{ [super viewDidUnload]; }

-(void) viewWillDisappear:(BOOL)animated{ [super viewWillDisappear:animated]; }
-(void) viewDidDisappear:(BOOL)animated{ [super viewDidDisappear:animated]; }
-(void) viewDidLoad{ 
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.tabBarController.tabBar.tintColor = [UIColor whiteColor];

    ac = [[AppearanceCommon alloc] initWithViewController:self];
    [self initSubViews];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ac resetColorCode];
    lc = [[LangCommon alloc] init];
    [ac setColors];
    [self setAppearance];
    [self setItemPosition];
}
-(void) viewDidAppear:(BOOL)animated{ 
    [super viewDidAppear:animated];
    [self setItemPosition];
    [self setItemPosition];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setAppearance];
    [self setItemPosition];
}

-(void) initSubViews{}
-(void) setAppearance{}
-(void) setItemPosition{}

@end
