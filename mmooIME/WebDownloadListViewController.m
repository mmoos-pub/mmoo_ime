//
//  WebDownloadListViewController.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/06/25.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "WebDownloadListViewController.h"
#import "WebCommon.h"
#import "DataCommon.h"
#import "WebDownloadViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebDownloadListViewController

#pragma mark - ViewControllerCommon
-(void) initSubViews{
    UIBarButtonItem *leftButton = [
        [UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"icon_arrow_left.png"]
        style: UIBarButtonItemStyleBordered
        target:self 
        action:@selector(popBack)
    ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    itemSortLabel = [[UILabel alloc] init];
    itemGenreLabel = [[UILabel alloc] init];
    NSArray *sortItems = [NSArray arrayWithObjects:@"", @"",nil];
    itemSortSeg = [[UISegmentedControl alloc] initWithItems:sortItems];
    itemGenreButton = [[UIButton alloc] init];
    itemLabelNoData = [[UILabel alloc] init];
    
    tv = [[UITableView alloc] init];
    tv.delegate = self;
    tv.dataSource = self;
    tvBack = [[UIView alloc] init];
    [tvBack addSubview:tv];
    
    [itemSortSeg addTarget:self action:@selector(setSort) forControlEvents:UIControlEventValueChanged];
    [itemGenreButton addTarget:self action:@selector(showGenre) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:itemSortLabel];
    [self.view addSubview:itemSortSeg];
    [self.view addSubview:itemGenreLabel];
    [self.view addSubview:itemGenreButton];

    gv = [[WebGenreSubView alloc] initWithATargetCode:targetCode actionCode:ACTION_DOWNLOAD superView:self];
    gv.delegate = self;
    
    errView = [[UIView alloc] init];
    errLabel = [[UILabel alloc] init];
    errBtn = [[UIButton alloc] init];
    [errBtn addTarget:self action:@selector(setArrTitles) forControlEvents:UIControlEventTouchUpInside];
    [errView addSubview:errLabel];
    [errView addSubview:errBtn];
    
    choseGenreFlg = NO;
    ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:ai];
}
-(void) setAppearance{
    NSInteger titleCode = targetCode==TARGET_TEXT ? TRNS_DT_TITLE : TRNS_DI_TITLE;
    [ac setNavTitle:[lc getTranslated:titleCode]];
    
    [ac setLabel:itemSortLabel type:LABEL_CONTENT text:[lc getTranslated:TRNS_D_SORT] font:FONT_SMALL];
    
    [itemSortSeg setTitle:[lc getTranslated:TRNS_D_SORT_DATE] forSegmentAtIndex:SORT_DATE];
    [itemSortSeg setTitle:[lc getTranslated:TRNS_D_SORT_POP] forSegmentAtIndex:SORT_POP];
    [itemSortSeg setSelectedSegmentIndex:sortCode];
    [ac setSeg:itemSortSeg];
    
    [self setGenreLabel];
    [ac setButton:itemGenreButton 
        type:BUTTON_TYPE_RICH 
        title:[lc getTranslated:TRNS_CHANGE] 
        imgName:@"icon_arrow_right.png"
        w:0 
        h:[ac getButtonSize:BUTTON_SIZE_SMALL]
    ];
    
    [ac setLabel:errLabel type:LABEL_WHITE text:[lc getTranslated:TRNS_UD_FAILED] font:FONT_NORMAL];
    [ac setButton:errBtn type:BUTTON_TYPE_RICH title:[lc getTranslated:TRNS_UD_RETRY] imgName:nil];
    
    [self resetListTable];
}
-(void) setItemPosition{
    [ac setX:itemSortLabel xMargin:MARGIN_NORMAL];
    [ac setX:itemSortSeg rightOf:itemSortLabel withMargin:MARGIN_SMALL];
    [ac setY:itemSortSeg yMargin:MARGIN_NORMAL];
    [ac setY:itemSortLabel nextTo:itemSortSeg];
    
    if([ac isSlim]){
        [ac setX:itemGenreLabel xMargin:MARGIN_NORMAL];
        [ac setY:itemGenreButton under:itemSortSeg withMargin:MARGIN_NORMAL];
        [ac setY:itemGenreLabel nextTo:itemGenreButton];
    }else{
        [ac setX:itemGenreLabel rightOf:itemSortSeg withMargin:MARGIN_LARGE];
        [ac setY:itemGenreButton nextTo:itemSortSeg];
        [ac setY:itemGenreLabel nextTo:itemSortSeg];
    }
    [ac setX:itemGenreButton rightOf:itemGenreLabel withMargin:MARGIN_SMALL];
    
    [ac setY:errLabel yMargin:MARGIN_LARGE];
    [ac setY:errBtn under:errLabel withMargin:MARGIN_LARGE];    
    [ac setSubView:errView type:SUBVIEW_ROUND xPadding:MARGIN_LARGE yPadding:MARGIN_LARGE];
    [ac setY:errView yMargin:MARGIN_LARGE];
    [ac setX:errLabel centerOf:errView];
    [ac setX:errBtn centerOf:errView];
    errView.center = self.view.center;
    
    [self setTvPosition];
    [gv setItemPosition];
    ai.center = self.view.center;
}

#pragma mark - specific
- (void)viewWillDisappear:(BOOL)animated{ 
    [super viewWillDisappear:animated]; 
    [self genreNotSelected];
}
-(id) initWithTargetCode:(NSInteger)code{
    self = [super init];
    if(self){
        targetCode = code;
        sortCode = SORT_DATE;
        catCode = GENRE_NONE;
        genreCode = GENRE_NONE;
    }
    return self;
}
-(CGFloat) getTvCellHeight{
    if(genreCode!=GENRE_NONE){
        return [ac getTableCellH:TABLE_NARROW];
    }else{
        UILabel *mainDummy = [[UILabel alloc] init];    
        UILabel *subDummy = [[UILabel alloc] init];
        [ac setLabel:mainDummy type:LABEL_CONTENT text:[lc getTranslated:TRNS_YES] font:FONT_NORMAL];        
        [ac setLabel:subDummy type:LABEL_CONTENT text:[lc getTranslated:TRNS_YES] font:FONT_SMALL];
        return [ac getMargin:MARGIN_SMALL]*2 + mainDummy.frame.size.height + subDummy.frame.size.height;
    }
}
-(CGFloat) getTvHeight{
    CGFloat minH = [self getTvCellHeight]*[arrTitles count];
    CGFloat maxH = [ac getH] - itemGenreButton.frame.origin.y - itemGenreButton.frame.size.height - [ac getMargin:MARGIN_NORMAL];
    
    if( minH > maxH ){
        padding = MARGIN_NONE;
        return maxH;
    }else{
        padding = MARGIN_SMALL;
        return minH;
    }
}
-(void) setTvPosition{
    [ac resizeObject:tv w:[ac getW]-[ac getMargin:MARGIN_SUPER]*2 h:[self getTvHeight]];
    [ac changeX:tv x:[ac getMargin:MARGIN_SMALL]/2];
    [ac changeY:tv y:[ac getMargin:MARGIN_SMALL]/2];
    [ac setLucentBg:tvBack type:BG_DARK];
    [ac resizeObject:tvBack w:[ac getW]-[ac getMargin:MARGIN_SUPER]*2+[ac getMargin:MARGIN_SMALL] h:[self getTvHeight]+[ac getMargin:MARGIN_SMALL]];
    [ac setY:tvBack yMargin:MARGIN_NORMAL];
    [ac setX:tvBack centerOf:self.view];
    [ac setY:tvBack under:itemGenreButton withMargin:MARGIN_NORMAL];
}
-(void) setGenreCode{
    [self setGenreLabel];
    choseGenreFlg = NO;
    [gv removeFromSuperview];
    [self resetListTable];
}
-(void) setGenreLabel{
    NSString *targetGenre;
    if(genreCode == GENRE_NONE){
        targetGenre = [lc getTranslated:TRNS_D_GENRE_ALL];
    }else{
        targetGenre = [[[WebCommon alloc] initWithTargetCode:targetCode] getGenre:genreCode inCat:catCode type:GENRE_TYPE_STR];
    }
    
    [ac setLabel:itemGenreLabel type:LABEL_CONTENT text:[[lc getTranslated:TRNS_UD_GENRE] stringByAppendingString:targetGenre] font:FONT_SMALL];
    [ac setX:itemGenreButton rightOf:itemGenreLabel withMargin:MARGIN_SMALL];
}
-(void) resetListTable{
    [errView removeFromSuperview];
    [itemLabelNoData removeFromSuperview];
    [tvBack removeFromSuperview];
    if(arrTitles.count > 0){
        [tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    arrTitles = [NSMutableArray array];
    arrSeq = [NSMutableArray array];
    arrGenre = [NSMutableArray array];
    page = 1;
    [self setArrTitles];
}
-(void) setArrTitles{
    parseErrFlg = NO;
    [errView removeFromSuperview];
    [itemSortSeg setEnabled:NO];
    [itemGenreButton setEnabled:NO];
    [ai startAnimating];
    finalFlg = YES;
    
    NSMutableURLRequest *request = [WebCommon getReq:@"list"];
    request.HTTPMethod = @"POST";
    NSString *target = (targetCode==TARGET_IME) ? @"ime" : @"text";
    NSString *tag = [[[WebCommon alloc] initWithTargetCode:targetCode] getGenre:genreCode inCat:catCode type:GENRE_TYPE_KEY];
    NSString *download = (sortCode==SORT_POP) ? @"yes" : @"no";
    NSString *body = [NSString stringWithFormat:@"target=%@&tag=%@&download=%@&page=%zd", target,tag,download,page];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData dataWithLength:0];
    }else{
        [self showErr];
    }
}
-(void) updateTable{
    if(!parseErrFlg && !choseGenreFlg){    
        if([arrTitles count]==0){
            [ac setLabel:itemLabelNoData type:LABEL_CONTENT text:[lc getTranslated:TRNS_D_NO_ITEM] font:FONT_LARGE];
            [ac setX:itemLabelNoData centerOf:self.view];
            [ac setY:itemLabelNoData under:itemGenreButton withMargin:MARGIN_SUPER];
            [self.view addSubview:itemLabelNoData];
        }else{        
            [self setTvPosition];
            [tv reloadData];
            if(page == 2){
                [ac glide:tvBack into:self.view];
                [ai removeFromSuperview];
                [self.view addSubview:ai];
            }
        }
    }
    [ai stopAnimating];
    [itemSortSeg setEnabled:YES];
    [itemGenreButton setEnabled:YES];
}
-(void) showErr{
    [ai stopAnimating];
    [itemSortSeg setEnabled:YES];
    [itemGenreButton setEnabled:YES];
    [self.view addSubview:errView];
}

#pragma mark - selectors
-(void) popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) setSort{
    sortCode = itemSortSeg.selectedSegmentIndex;
    [ac setSeg:itemSortSeg];
    [self resetListTable];
}
-(void) showGenre{
    choseGenreFlg = YES;
    [itemSortSeg setEnabled:NO];
    [itemGenreButton setEnabled:NO];
    [gv refresh];
    [ac slide:gv into:self.view];
}


#pragma mark - WebGenreSubView delegate
-(void) genreSelected:(NSInteger)gc inCat:(NSInteger)cc{
    choseGenreFlg = NO;
    genreCode = gc;
    catCode = cc;
    [self setGenreCode];
}
-(void) genreNotSelected{
    choseGenreFlg = NO;
    [gv removeFromSuperview];
    [itemSortSeg setEnabled:YES];
    [itemGenreButton setEnabled:YES];
}

#pragma mark - URLconnection delegate
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self showErr];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:receivedData];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - XMLparser delegate
-(void) parserDidStartDocument:(NSXMLParser *)parser{
    found = 0;
    inTitleTag = NO;
    inSeqTag = NO;
    inGenreTag = NO;
}
-(void) parserDidEndDocument:(NSXMLParser *)parser{
    page++;
    finalFlg = (found<20);    
    [self updateTable];
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"title"]) {
        inTitleTag = YES;
        title = [NSMutableString string];
	}else if ([elementName isEqualToString:@"seq"]) {
        inSeqTag = YES;
        seq = [NSMutableString string];
	}else if([elementName isEqualToString:@"genre"]){
        inGenreTag = YES;
        genre = [NSMutableString string];
    }
}
-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"item"]) {
        found ++;
        BOOL already = NO;
        for(NSInteger i=0; i<arrSeq.count; i++){
            if( [seq isEqualToString:[arrSeq objectAtIndex:i]] ){
                already = YES;
            }
        }
        if(!already){
            [arrTitles addObject:title];
            [arrSeq addObject:seq];
            [arrGenre addObject:genre];
        }
	} else if ([elementName isEqualToString:@"title"]) {
        inTitleTag = NO;
	} else if ([elementName isEqualToString:@"seq"]) {
        inSeqTag = NO;
	} else if ([elementName isEqualToString:@"genre"]){
        inGenreTag = NO;
    }
}
-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (inTitleTag) {
		[title appendString:string];
	} else if (inSeqTag) {
		[seq appendString:string];
	} else if (inGenreTag){
        [genre appendString:string];
    }
}
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    parseErrFlg = YES;
    [self showErr];
}

#pragma mark - Table view datasource,delegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if(finalFlg){
        return 1;
    }else{
        return 2;
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return [arrTitles count];
    }else{
        return 1;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [self getTvCellHeight];
    }else{
        return [ac getTableCellH:TABLE_WIDE];
    }
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else{
        for(UIView *v in [cell subviews] ){
            [v removeFromSuperview];
        }
    }
    
    NSString *strTitle;
    if(indexPath.section==0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
        UILabel *mainLbl = [[UILabel alloc] init];
        strTitle = [arrTitles objectAtIndex:indexPath.row];
        if(strTitle.length==0){
            strTitle = [lc getTranslated:TRNS_TXT_NO_TITLE];
        }
        [ac setLabel:mainLbl type:LABEL_CONTENT text:strTitle font:FONT_NORMAL];
        [ac setX:mainLbl xMargin:MARGIN_NORMAL];
        [cell addSubview:mainLbl];
        if(genreCode!=GENRE_NONE){
            [ac changeY:mainLbl y:([self getTvCellHeight]-mainLbl.frame.size.height)/2];
        }else {
            [ac setY:mainLbl yMargin:MARGIN_SMALL];
            UILabel *subLbl = [[UILabel alloc] init];
            NSString *strGenre = [[[WebCommon alloc] initWithTargetCode:targetCode] convertGenre:[arrGenre objectAtIndex:indexPath.row]];
            if(strGenre.length==0){
                strGenre = [lc getTranslated:TRNS_U_GENRE_NONE];
            }
            [ac setLabel:subLbl type:LABEL_WEAK text:[[lc getTranslated:TRNS_UD_GENRE] stringByAppendingString:strGenre] font:FONT_SMALL];
            [ac setX:subLbl xMargin:MARGIN_SUPER];
            [ac setY:subLbl under:mainLbl withMargin:MARGIN_NONE];
            [cell addSubview:subLbl];
        }
        [cell.layer setBorderWidth:0.7];
        [cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        strTitle = [lc getTranslated:TRNS_D_MORE];        
        [ac setLabel:cell.textLabel type:LABEL_CONTENT text:strTitle font:FONT_NORMAL];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        WebDownloadViewController *wdv = [[WebDownloadViewController alloc] initWithTargetCode:targetCode title:[arrTitles objectAtIndex:indexPath.row] seq:[arrSeq objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:wdv animated:YES];
    }
}

#pragma mark - ScrollView delegate
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(finalFlg){
        return;
    }
    
    if( tv.contentSize.height-tv.contentOffset.y < [self getTvHeight] ){
        [self setArrTitles];
    }
}
@end