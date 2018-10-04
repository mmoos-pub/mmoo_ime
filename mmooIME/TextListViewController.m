//
//  TextListViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/17.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "TextListViewController.h"
#import "TextEditViewController.h"
#import "DataTexts.h"

@implementation TextListViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    UIBarButtonItem *rightButton = [
        [UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
        target:self
        action: @selector(goToNew)
    ];
    self.navigationItem.rightBarButtonItem = rightButton;
    tv = [[UITableView alloc] init];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
}
-(void) setAppearance{
    [self setNav];
    [ac setTableBg:tv];
    [tv reloadData];
}
-(void) setItemPosition{
    [tv setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - specific
- (void)viewWillDisappear:(BOOL)animated{ 
    [super viewWillDisappear:animated];
    [self setEditing:NO animated:NO];
}
-(void) setNav{
    NSString *navTitle = [lc getTranslated:TRNS_TXT_LIST_NAV_TITLE];
    NSInteger fileCnt = [DataTexts getFileCnt];
    if( fileCnt > 0 ){
        NSString *fileNum = [NSString stringWithFormat:@"(%zd)", fileCnt];
        navTitle = [navTitle stringByAppendingString:fileNum];
    }
    [ac setNavTitle:navTitle];
    
    if( [DataTexts getFileCnt] > 0 ){
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}
-(void) goToEdit:(NSString*)textID{
    TextEditViewController *tevc = [[TextEditViewController alloc] initWithTextID:textID];
    [self.navigationController pushViewController:tevc animated:YES];
}

#pragma mark - selectors
-(void) goToNew{
    [self goToEdit:nil];
}

#pragma mark - Table view datasource,delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataTexts getFileCnt];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ac getTableCellH:TABLE_WIDE];
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *textTitle = [DataTexts getTitleByIndex:indexPath.row];
    if(textTitle.length==0){
        textTitle = [lc getTranslated:TRNS_TXT_NO_TITLE];
    }
    
    [ac setLabel:cell.textLabel type:LABEL_CONTENT text:textTitle font:FONT_LARGE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tv setEditing:editing animated:animated];
    [self setNav];
    if(editing){
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DataTexts deleteTextDataByIndex:indexPath.row];
        [self setNav];
        if( [DataTexts getFileCnt] > 0 ){
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }else{
            [self setEditing:NO animated:YES];
        }
        [tv reloadData];
        [self setItemPosition];
    }else{
        [self setNav];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToEdit:[DataTexts getIDbyIndex:indexPath.row]];
}

@end