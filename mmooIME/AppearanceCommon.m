//
//  AppearanceCommon.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/07/03.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "AppearanceCommon.h"
#import "DataSettings.h"
#import "ColorCommon.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppearanceCommon

-(id) initWithViewController:(UIViewController*)viewController{
    self = [super init];
    if(self){
        [self resetColorCode];
        vc = viewController;
    }
    return self;
}
-(void) resetColorCode{
    colorCode = [DataSettings getColor];
}

-(void) setColors{
    vc.navigationController.navigationBar.barTintColor = [ColorCommon getColorFor:CLR_FOR_NAV withColorCode:colorCode];
    vc.tabBarController.tabBar.barTintColor = [ColorCommon getColorFor:CLR_FOR_TAB withColorCode:colorCode];
    vc.view.backgroundColor = [ColorCommon getColorFor:CLR_FOR_BG_LIGHT withColorCode:colorCode];
}
-(void) setNavTitle:(NSString*)navTitle{
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.font = [UIFont boldSystemFontOfSize:[self getFontSize:FONT_LARGE]];
    navTitleLabel.text = navTitle;
    [navTitleLabel sizeToFit];
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.textColor =[UIColor whiteColor];
    vc.navigationItem.titleView = navTitleLabel;
}
-(void) setLabel:(UILabel*)label type:(NSInteger)type text:(NSString*)text font:(NSInteger)fontType{
    UIColor *clr;
    
    if( type == LABEL_WHITE ){
        clr = [UIColor whiteColor];
    }else if( type == LABEL_WEAK ){
        clr = [[ColorCommon getColorFor:CLR_FOR_CONTENT withColorCode:colorCode] colorWithAlphaComponent:0.4];
    }else if( type== LABEL_CAUTION ){
        clr = [UIColor redColor];
    }else{
        clr = [ColorCommon getColorFor:CLR_FOR_CONTENT withColorCode:colorCode];
    }
    [label setTextColor:clr];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.font = [UIFont fontWithName:COMMON_FONT_FAMILY size:[self getFontSize:fontType]];
    [label sizeToFit];
}
-(void) setButton:(UIButton*)b type:(NSInteger)type title:(NSString*)title imgName:(NSString*)imgName{
    [self setButton:b type:type title:title imgName:imgName w:0 h:0];    
}
-(void) setButton:(UIButton*)b type:(NSInteger)type title:(NSString*)title imgName:(NSString*)imgName w:(CGFloat)w h:(CGFloat)h{
    if(h==0){ h = [self getButtonSize:BUTTON_SIZE_NORMAL]; }
    
    UIImage *img;
    CGFloat imgLeft=0, imgRight=0, imgW=0, txtLeft=0, txtRight=0, txtW=0;

    if( imgName!=nil ){
        img = [UIImage imageNamed:imgName];
        
        CGFloat r = 0.0f;
        if( [self isIpad] ){
            if( img.size.height * 2 > h ){
                r = h / img.size.height;
            }else{
                r = 2.0f;
            }
        }else{
            if( img.size.height > h ){
                r = h / img.size.height;
            }
        }
        
        if( r>0 ){
            CGSize sz = CGSizeMake(img.size.width*r,img.size.height*r);
            UIGraphicsBeginImageContext(sz);
            [img drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        [b setImage:img forState:UIControlStateNormal];
    }
    if( title.length>0 ){
        NSInteger font = (imgName==nil) ? FONT_NORMAL : FONT_SMALL;
        b.titleLabel.font = [UIFont fontWithName:COMMON_FONT_FAMILY size:[self getFontSize:font]];
        [b setTitle:title forState:UIControlStateNormal];
        [b.titleLabel sizeToFit];
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.numberOfLines = 0;
        [self setLabel:lbl type:LABEL_CONTENT text:title font:font];
        txtW = lbl.frame.size.width;
    }
    
    if(w==0){
        if(imgName==nil){
            imgLeft = 0;
            imgRight = 0;
            imgW = 0;
            txtLeft = [self getMargin:MARGIN_NORMAL];
            txtRight = [self getMargin:MARGIN_NORMAL];
        }else if(title.length==0){
            imgLeft = [self getMargin:MARGIN_NORMAL];
            imgRight = [self getMargin:MARGIN_NORMAL];
            imgW = img.size.width;
            txtLeft = 0;
            txtRight = 0;
        }else{
            imgLeft = [self getMargin:MARGIN_SMALL]/2;
            imgRight = 0;
            imgW = img.size.width;
            txtLeft = [self getMargin:MARGIN_SMALL];
            txtRight = [self getMargin:MARGIN_SMALL]/2;
        }
        w = imgLeft + imgRight + imgW + txtLeft + txtRight + txtW;
    }else{
        if(imgName==nil){
            imgLeft = 0;
            imgRight = 0;
            txtLeft = ( w - txtW ) / 2;
            txtRight = txtLeft;
        }else if(title.length==0){
            imgLeft = ( w - img.size.width ) / 2;
            imgRight = imgLeft;
            txtLeft = 0;
            txtRight = 0;
        }else{
            imgLeft = (w-b.imageView.frame.size.width-txtW)/5;
            imgRight = (w-b.imageView.frame.size.width-txtW)/5;
            txtLeft = imgLeft+imgRight;
            txtRight = (w-b.imageView.frame.size.width-txtW)*3/5;
        }
    }
    
    [b setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    b.imageEdgeInsets = UIEdgeInsetsMake(0, imgLeft, 0, imgLeft);
    b.titleEdgeInsets = UIEdgeInsetsMake(0, txtLeft, 0, txtRight);
    [self resizeObject:b w:w h:h];

    if(type==BUTTON_TYPE_DARK){
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setBackgroundColor:[UIColor lightGrayColor]];
        [[b layer] setBorderWidth:0.0];
        return;
    }
    if(type==BUTTON_TYPE_LIGHT){
        [b setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [b setBackgroundColor:[UIColor whiteColor]];
        [[b layer] setBorderWidth:1.0];
        [[b layer] setBorderColor:[ColorCommon getColorFor:CLR_FOR_CONTENT withColorCode:colorCode].CGColor];
        return;
    }
    if(type==BUTTON_TYPE_HIGHLIGHT){
        [b setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [b setBackgroundColor:[UIColor yellowColor]];
        [[b layer] setBorderWidth:1.0];
        [[b layer] setBorderColor:[ColorCommon getColorFor:CLR_FOR_CONTENT withColorCode:colorCode].CGColor];
        return;        
    }
    if(type==BUTTON_TYPE_CUSTOM){
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setBackgroundColor:[ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:colorCode]];
        [[b layer] setBorderWidth:2.0];
        [[b layer] setBorderColor:[UIColor whiteColor].CGColor];
        return;
    }
    
    UIColor *baseColor;
    switch (type) {
        case BUTTON_ACTION_DELETE:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:CLR_ORANGE];
            break;
        case BUTTON_ACTION_CANCEL:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:CLR_GREEN];
            break;
        case BUTTON_ACTION_EDIT:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:CLR_PINK];
            break;
        case BUTTON_ACTION_INSERT:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:CLR_PURPLE];
            break;
        case BUTTON_ACTION_MOVE:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:CLR_BLUE];
            break;
        default:
            baseColor = [ColorCommon getColorFor:CLR_FOR_BUTTON withColorCode:colorCode];
            break;
    }
    
    if(type==BUTTON_TYPE_RICH){
        [b setTitleColor:[ColorCommon getColorFor:CLR_FOR_CONTENT withColorCode:colorCode] forState:UIControlStateNormal];
    }else{
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [b setTitleColor:baseColor forState:UIControlStateDisabled];
    
    UIView *bgView = [[UIView alloc] initWithFrame:b.frame];
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.frame = layerView.bounds;
    NSMutableArray *arrL = 
    [NSMutableArray arrayWithObjects:
        [NSNumber numberWithFloat:0.0f],
        [NSNumber numberWithFloat:0.1f],
        [NSNumber numberWithFloat:0.2f],
        [NSNumber numberWithFloat:0.3f],
        [NSNumber numberWithFloat:0.5f],
        [NSNumber numberWithFloat:0.8f],
        [NSNumber numberWithFloat:1.0f],
     nil];
    [gradLayer setLocations:arrL];    
    gradLayer.colors =
    [NSArray arrayWithObjects:
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.9].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
     nil];
    
    [bgView setBackgroundColor:baseColor];
    [layerView.layer addSublayer:gradLayer];
    [bgView addSubview:layerView];
    
    [bgView.layer setMasksToBounds:YES];
    [bgView.layer setCornerRadius:h/3];
    [bgView.layer setBorderWidth:1.0];
    [bgView.layer setBorderColor:baseColor.CGColor];
    
    UIGraphicsBeginImageContext(bgView.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [b setBackgroundImage:bgImg forState:UIControlStateNormal];
    
    gradLayer.colors =
    [NSArray arrayWithObjects:
        (id)[[UIColor grayColor] colorWithAlphaComponent:1.0].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:0.7].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:0.7].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor,
        (id)[[UIColor grayColor] colorWithAlphaComponent:1.0].CGColor,
     nil];
    [bgView.layer setMasksToBounds:YES];
    [bgView.layer setCornerRadius:h/3];
    [bgView.layer setBorderWidth:1.0];
    [bgView.layer setBorderColor:baseColor.CGColor];
    UIGraphicsBeginImageContext(bgView.frame.size);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *simpleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [b setBackgroundImage:simpleImg forState:UIControlStateDisabled];
}
-(void) setSeg:(UISegmentedControl*)seg{
    //seg.segmentedControlStyle = UISegmentedControlStyleBar;
    [seg setTintColor:[UIColor blackColor]];
    [seg setBackgroundColor:[UIColor whiteColor]];
    
    UIFont *font = [UIFont fontWithName:COMMON_FONT_FAMILY size:[self getFontSize:FONT_SMALL]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UILabel *dummy = [[UILabel alloc] init];
    for(NSInteger i=0; i<seg.numberOfSegments; i++){
        [self setLabel:dummy type:LABEL_WEAK text:[seg titleForSegmentAtIndex:i] font:FONT_SMALL];
        [seg setWidth:dummy.frame.size.width+[self getMargin:MARGIN_LARGE] forSegmentAtIndex:i];
    }
    
    UIColor *on = [ColorCommon getColorFor:CLR_FOR_SEG withColorCode:colorCode];
    UIColor *off = [UIColor lightGrayColor];
    for(id cell in [seg subviews]){
        if([ cell isSelected]){ [cell setTintColor:on];}
        else{ [cell setTintColor:off];}
    }
    
    [self resizeObject:seg w:seg.frame.size.width h:[self getButtonSize:BUTTON_SIZE_NORMAL]];
}
-(void) setTextField:(UITextField*)tf text:(NSString*)text placeHolder:(NSString *)placeHolder{
    [tf setFont:[UIFont fontWithName:COMMON_FONT_FAMILY size:[self getFontSize:FONT_NORMAL]]];
    [tf setText:text];
    [tf setPlaceholder:placeHolder];
    tf.layer.cornerRadius = tf.frame.size.height/4;
    tf.backgroundColor = [UIColor whiteColor];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
}
-(void) setTextView:(UITextView*)tv text:(NSString*)text type:(NSInteger)type{
    [tv setFont:[UIFont fontWithName:COMMON_FONT_FAMILY size:[self getFontSize:FONT_NORMAL]]];
    [tv setText:text];
    tv.backgroundColor = [UIColor whiteColor];
    [tv setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [tv setAutocorrectionType:UITextAutocorrectionTypeNo];
    if(type==TEXT_ROUND){
        [tv.layer setCornerRadius:[self getButtonSize:BUTTON_SIZE_NORMAL]/3];
        tv.clipsToBounds = YES;
    }
    if(type==TEXT_CLEAR){
        [tv setTextColor:[UIColor whiteColor]];
        [tv setBackgroundColor:[UIColor clearColor]];
    }
}
-(void) setSubView:(UIView*)subView type:(NSInteger)type xPadding:(NSInteger)xPadding yPadding:(NSInteger)yPadding{
    CGFloat w=0.0f, h=0.0f;
    for(UIView *v in [subView subviews]){
        if( w < v.frame.size.width ){
            w = v.frame.size.width;
        }
        
        if( h < v.frame.origin.y + v.frame.size.height ){
            h = v.frame.origin.y + v.frame.size.height;
        }
    }
    
    w += [self getMargin:xPadding]*2;
    h += [self getMargin:yPadding];
  
    CGRect frame = CGRectMake( ([self getW]-w)/2, 0, w, h);
    [subView setFrame:frame];
    if(type==SUBVIEW_SQUARE){
        subView.backgroundColor = [ColorCommon getColorFor:CLR_FOR_BG_DARK withColorCode:colorCode];
    }else{
        UIColor *baseColor = [ColorCommon getColorFor:CLR_FOR_BG_DARK withColorCode:colorCode];
        CGFloat innerBorder = [self isIpad] ? 5.6f : 2.8f;
        CGFloat outerBorder = [self isIpad] ? 2.4f : 1.2f;
        CGRect frameOuter = CGRectMake(0, 0, w, h);
        CGRect frameInner = CGRectMake(innerBorder, innerBorder, w-innerBorder*2, h-innerBorder*2);
        UIView *bgView = [[UIView alloc] initWithFrame:frameOuter];
        
        CGFloat radBig, radSmall;
        if(h<[self getButtonSize:BUTTON_SIZE_NORMAL]*4){
            radBig = h/4;
            radSmall = (h-innerBorder*2) / 4;
        }else{
            radBig = [self getButtonSize:BUTTON_SIZE_NORMAL];
            radSmall = [self getButtonSize:BUTTON_SIZE_NORMAL];
        }
        
        CALayer *outerLayer = [CALayer layer];
        CALayer *innerBaseLayer = [CALayer layer];
        CAGradientLayer *innerGradLayer = [CAGradientLayer layer];
        outerLayer.frame = frameOuter;
        innerBaseLayer.frame = frameInner;
        innerGradLayer.frame = frameInner;
        [outerLayer setMasksToBounds:YES];
        [innerBaseLayer setMasksToBounds:YES];
        [innerGradLayer setMasksToBounds:YES];
        [outerLayer setCornerRadius:radBig];
        [innerBaseLayer setCornerRadius:radSmall];
        [innerGradLayer setCornerRadius:radSmall];
        
        outerLayer.backgroundColor = [ColorCommon getColorFor:CLR_FOR_BG_LIGHT withColorCode:colorCode].CGColor;
        innerBaseLayer.backgroundColor = [UIColor whiteColor].CGColor;
        NSMutableArray *arrL = [NSMutableArray arrayWithObjects:
                [NSNumber numberWithFloat:0.0f],
                [NSNumber numberWithFloat:0.2f],
                [NSNumber numberWithFloat:0.5f],
                [NSNumber numberWithFloat:1.0f],nil];
        [innerGradLayer setLocations:arrL];    
        innerGradLayer.colors = [NSArray arrayWithObjects:
                (id)[baseColor colorWithAlphaComponent:0.4].CGColor,
                (id)[baseColor colorWithAlphaComponent:0.6].CGColor,
                (id)[baseColor colorWithAlphaComponent:0.8].CGColor,
                (id)[baseColor colorWithAlphaComponent:1.0].CGColor,nil];

        [bgView.layer addSublayer:outerLayer];
        [bgView.layer addSublayer:innerBaseLayer];
        [bgView.layer addSublayer:innerGradLayer];
        
        UIGraphicsBeginImageContext(frameOuter.size);
        [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [subView setBackgroundColor:[UIColor colorWithPatternImage:bgImg]];
       
        [subView.layer setMasksToBounds:YES];
        [subView.layer setCornerRadius:radBig];
        [subView.layer setBorderWidth:outerBorder];
        [subView.layer setBorderColor:[ColorCommon getColorFor:CLR_FOR_BG_DARK withColorCode:colorCode].CGColor];
    }
}
-(void) setTableBg:(UITableView *)tv{
    tv.backgroundColor = [ColorCommon getColorFor:CLR_FOR_BG_LIGHT withColorCode:colorCode];
    tv.separatorColor = [ColorCommon getColorFor:CLR_FOR_BG_DARK withColorCode:colorCode];
}
-(void) setLucentBg:(UIView*)v type:(NSInteger)type{
    if(type==BG_DARK){
        [v setBackgroundColor:[[ColorCommon getColorFor:CLR_FOR_BG_DARK withColorCode:colorCode] colorWithAlphaComponent:0.8]];
    }else if(type==BG_LIGHT){
        [v setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void) slideUp:(UIView *)subView onto:(UIView *)superView{
    CGRect originalFrame = subView.frame;
    subView.frame = CGRectMake(originalFrame.origin.x, [self getH], originalFrame.size.width, originalFrame.size.height);
    subView.alpha = 0.0;
    [superView addSubview:subView];
    
    [UIView transitionWithView:subView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        subView.frame = originalFrame;
        subView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
-(void) slide:(UIView *)subView into:(UIView *)superView{
    CGRect originalFrame = subView.frame;
    subView.frame = CGRectMake([self getW], originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height);
    subView.alpha = 0.0;
    [superView addSubview:subView];
    
    [UIView transitionWithView:subView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        subView.frame = originalFrame;
        subView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
-(void) glide:(UIView *)subView into:(UIView *)superView{
    CGRect originalFrame = subView.frame;
    subView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, 0);
    NSMutableArray *arrOf = [[NSMutableArray alloc] init];
    for(UIView *v in subView.subviews){
        CGRect of = v.frame;
        [arrOf addObject:[NSString stringWithFormat:@"%f",of.size.height]];
        v.frame = CGRectMake(of.origin.x, of.origin.y, of.size.width, 0);
    }
    
    [superView addSubview:subView];
    
    [UIView transitionWithView:subView duration:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        subView.frame = originalFrame;
        NSInteger cnt=0;
        for(UIView *v in subView.subviews){
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, [[arrOf objectAtIndex:cnt] floatValue]);
            cnt++;
        }
    } completion:^(BOOL finished) {
    }];
}
-(void) fade:(UIView*)subView into:(UIView*)superView{
    subView.alpha = 0.0;
    [superView addSubview:subView];
    
    [UIView transitionWithView:subView duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        subView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }]; 
}

-(void) resizeObject:(UIView*)object w:(CGFloat)w h:(CGFloat)h{
    [object setFrame:CGRectMake(object.frame.origin.x, object.frame.origin.y, w, h)];
}
-(void) fitOuter:(UIView*)outer{
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    for(UIView *v in outer.subviews){
        if(v.frame.origin.x + v.frame.size.width > w){
            w = v.frame.origin.x + v.frame.size.width;
        }
        if(v.frame.size.height > h){
            h = v.frame.size.height;
        }
    }
    [outer setFrame:CGRectMake(0, 0, w, h)];
}

-(void) changeX:(UIView*)object x:(CGFloat)x{
    [object setFrame:CGRectMake(x, object.frame.origin.y, object.frame.size.width, object.frame.size.height)];
}
-(void) changeY:(UIView*)object y:(CGFloat)y{
    [object setFrame:CGRectMake(object.frame.origin.x, y, object.frame.size.width, object.frame.size.height)];
}
-(void) setX:(UIView*)object xMargin:(NSInteger)x{
    [self changeX:object x:[self getMargin:x]];
}
-(void) setX:(UIView*)object rightOf:(UIView*)another withMargin:(NSInteger)margin{
    [self changeX:object x:another.frame.origin.x+another.frame.size.width+[self getMargin:margin]];
}
-(void) setX:(UIView*)object leftOf:(UIView*)another withMargin:(NSInteger)margin{
    [self changeX:object x:another.frame.origin.x-object.frame.size.width-[self getMargin:margin]];
}
-(void) setX:(UIView *)object centerOf:(UIView*)superView{
    [self changeX:object x:(superView.frame.size.width-object.frame.size.width)/2];
}
-(void) setX:(UIView *)object xRightMargin:(NSInteger)x of:(UIView*)superView{
    [self changeX:object x:superView.frame.size.width-object.frame.size.width-[self getMargin:x]];
}

-(void) setY:(UIView*)object yMargin:(NSInteger)y{
    [self changeY:object y:[self getMargin:y]];
}
-(void) setY:(UIView*)object under:(UIView*)another withMargin:(NSInteger)margin{
    [self changeY:object y:another.frame.origin.y+another.frame.size.height+[self getMargin:margin]];
}
-(void) setY:(UIView *)object nextTo:(UIView*)another{
    if( object.frame.size.height > another.frame.size.height ){
        [self changeY:object y:another.frame.origin.y];
        [self changeY:another y:another.frame.origin.y+(object.frame.size.height-another.frame.size.height)/2];
    }else{
        [self changeY:object y:another.frame.origin.y+(another.frame.size.height-object.frame.size.height)/2];
    }
}

-(BOOL) isIpad{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}
-(BOOL) isSlim{
    if( [self isIpad] ){
        return NO;
    }else{
        return [self getH] > [self getW];
    }
}
-(BOOL) isShort{
    if( [self isIpad] ){
        return NO;
    }else{
        return [self getH] < [self getW];
    }
}
-(CGFloat) getH{
    return vc.view.bounds.size.height;
}
-(CGFloat) getW{
    return vc.view.bounds.size.width;
}
-(CGFloat) getMargin:(NSInteger)marginType{
    if([self isIpad]){
        switch (marginType) {
            case MARGIN_SMALL:
                return 9.0; break;
            case MARGIN_NORMAL:
                return 18.0; break;
            case MARGIN_LARGE:
                return 36.0; break;
            case MARGIN_SUPER:
                return 60.0; break;
            case MARGIN_INDENT:
                return [self getW]/4; break;
            default:
                return 0; break;
        }
    }else{
        switch (marginType) {
            case MARGIN_SMALL:
                return 6.0; break;
            case MARGIN_NORMAL:
                return 12.0; break;
            case MARGIN_LARGE:
                return 24.0; break;
            case MARGIN_SUPER:
                return 30.0; break;
            case MARGIN_INDENT:
                return [self getW]/3; break;
            default:
                return 0; break;
        } 
    }
}

-(CGFloat) getFontSize:(NSInteger)fontType{
    if([self isIpad]){
        switch (fontType) {
            case FONT_SMALL:
                return 21; break;
            case FONT_LARGE:
                return 35; break;
            default:
                return 28; break;
        }
    }else{
        switch (fontType) {
            case FONT_SMALL:
                return 12; break;
            case FONT_LARGE:
                return 20; break;
            default:
                return 16; break;
        }
    }
}
-(CGFloat) getButtonSize:(NSInteger)buttonType{
    if( [self isIpad] ){
        switch (buttonType) {
            case BUTTON_SIZE_SMALL:
                return 36.0; break;
            case BUTTON_SIZE_ARROW:
                return 60.0; break;
            default:
                return 54.0; break;
        }
    }else{
        switch (buttonType) {
            case BUTTON_SIZE_SMALL:
                return 24.0; break;
            case BUTTON_SIZE_ARROW:
                return 36.0; break;
            default:
                return 32.0; break;
        }
    }
}
-(CGFloat) getTableCellH:(NSInteger)tableType{
    if( [self isShort] ){
        return [self getH]/6;
    }else{
        switch (tableType) {
            case TABLE_NARROW:
                return [self getH]/10; break;
            default:
                return [self getH]/8; break;
        }
    }
}
@end
