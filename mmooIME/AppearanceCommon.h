//
//  AppearanceCommon.h
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MARGIN_SMALL 1
#define MARGIN_NORMAL 2
#define MARGIN_LARGE 3
#define MARGIN_SUPER 4
#define MARGIN_INDENT 5
#define MARGIN_NONE 6

#define FONT_SMALL 1
#define FONT_NORMAL 2
#define FONT_LARGE 3
#define COMMON_FONT_FAMILY @"Arial Rounded MT Bold"
#define LABEL_WHITE 0
#define LABEL_CONTENT 1
#define LABEL_WEAK 2
#define LABEL_CAUTION 3

#define BUTTON_TYPE_DARK 0
#define BUTTON_TYPE_LIGHT 1
#define BUTTON_TYPE_HIGHLIGHT 2
#define BUTTON_TYPE_CUSTOM 3
#define BUTTON_TYPE_RICH 4
#define BUTTON_ACTION_DELETE 5
#define BUTTON_ACTION_CANCEL 6
#define BUTTON_ACTION_EDIT 7
#define BUTTON_ACTION_INSERT 8
#define BUTTON_ACTION_MOVE 9
#define BUTTON_SIZE_NORMAL 0
#define BUTTON_SIZE_SMALL 1
#define BUTTON_SIZE_ARROW 2

#define TEXT_SQUARE 0
#define TEXT_ROUND 1
#define TEXT_CLEAR 2

#define SUBVIEW_SQUARE 0
#define SUBVIEW_ROUND 1

#define TABLE_WIDE 0
#define TABLE_NARROW 1

#define BG_DARK 0
#define BG_LIGHT 1

@interface AppearanceCommon : NSObject{
    NSInteger colorCode;
    UIViewController *vc;
}

-(id) initWithViewController:(UIViewController*)viewController;
-(void) resetColorCode;

-(void) setColors;
-(void) setNavTitle:(NSString*)navTitle;
-(void) setLabel:(UILabel*)label type:(NSInteger)type text:(NSString*)text font:(NSInteger)fontType;
-(void) setButton:(UIButton*)b type:(NSInteger)type title:(NSString*)title imgName:(NSString*)imgName w:(CGFloat)w h:(CGFloat)h;
-(void) setButton:(UIButton*)b type:(NSInteger)type title:(NSString*)title imgName:(NSString*)imgName;
-(void) setSeg:(UISegmentedControl*)seg;
-(void) setTextField:(UITextField*)tf text:(NSString*)text placeHolder:(NSString*)placeHolder;
-(void) setTextView:(UITextView*)tv text:(NSString*)text type:(NSInteger)type;
-(void) setSubView:(UIView*)subView type:(NSInteger)type xPadding:(NSInteger)xPadding yPadding:(NSInteger)yPadding;
-(void) setTableBg:(UITableView*)tv;
-(void) setLucentBg:(UIView*)v type:(NSInteger)type;

-(void) slideUp:(UIView*)subView onto:(UIView*)superView;
-(void) slide:(UIView *)subView into:(UIView *)superView;
-(void) glide:(UIView *)subView into:(UIView *)superView;
-(void) fade:(UIView*)subView into:(UIView*)superView;

-(void) resizeObject:(UIView*)object w:(CGFloat)w h:(CGFloat)h;
-(void) fitOuter:(UIView*)outer;

-(void) changeX:(UIView*)object x:(CGFloat)x;
-(void) changeY:(UIView*)object y:(CGFloat)y;
-(void) setX:(UIView*)object xMargin:(NSInteger)x;
-(void) setX:(UIView*)object rightOf:(UIView*)another withMargin:(NSInteger)margin;
-(void) setX:(UIView*)object leftOf:(UIView*)another withMargin:(NSInteger)margin;
-(void) setX:(UIView *)object centerOf:(UIView*)superView;
-(void) setX:(UIView *)object xRightMargin:(NSInteger)x of:(UIView*)superView;
-(void) setY:(UIView*)object yMargin:(NSInteger)y;
-(void) setY:(UIView*)object under:(UIView*)another withMargin:(NSInteger)margin;
-(void) setY:(UIView *)object nextTo:(UIView*)another;

-(BOOL) isIpad;
-(BOOL) isSlim;
-(BOOL) isShort;
-(CGFloat) getH;
-(CGFloat) getW;
-(CGFloat) getMargin:(NSInteger)marginType;
-(CGFloat) getFontSize:(NSInteger)fontType;
-(CGFloat) getButtonSize:(NSInteger)buttonType;
-(CGFloat) getTableCellH:(NSInteger)tableType;

@end
