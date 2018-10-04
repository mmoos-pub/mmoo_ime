//
//  LangCommon.m
//  MmooKeyboardHyper
//
//  Created by 透子 桃井 on 12/01/28.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "LangCommon.h"
#import "DataSettings.h"

@implementation LangCommon

+(NSArray*) getAllLanguage{
    return [[NSArray alloc] initWithObjects:@"ENGLISH", @"日本語", nil];
}

-(id) init{
    self = [super init];
    if(self){ 
        langCode = [DataSettings getLanguage];
    }
    return  self;
}
-(NSString*) getTranslated:(NSInteger)textCode{
    switch (textCode) {
        case TRNS_YES: 
            switch (langCode) {
                case LANG_JP: return @"はい";
                default: return @"YES";
            }
        case TRNS_NO: 
            switch (langCode) {
                case LANG_JP: return @"いいえ";
                default: return @"NO";
            }
        case TRNS_SAVE:
            switch (langCode) {
                case LANG_JP: return @"保存";
                default: return @"SAVE";
            }
        case TRNS_EDIT:
            switch (langCode) {
                case LANG_JP: return @"編集";
                default: return @"EDIT";
            }
        case TRNS_DELETE:
            switch (langCode) {
                case LANG_JP: return @"削除";
                default: return @"DELETE";
            }
        case TRNS_CANCEL:
            switch (langCode) {
                case LANG_JP: return @"ｷｬﾝｾﾙ";
                default: return @"CANCEL";
            }
        case TRNS_CHANGE:
            switch (langCode) {
                case LANG_JP: return @"変更";
                default: return @"CHANGE";
            }
        case TRNS_COPY_TO_CLIPBOARD:
            switch (langCode) {
                case LANG_JP: return @"全文ｺﾋﾟｰ";
                default: return @"COPY";
            }
        case TRNS_COPIED:
            switch (langCode) {
                case LANG_JP: return @"ｺﾋﾟｰしました。";                    
                default: return @"text copied to your clipboard";
            }
        case TRNS_TXT_LIST_NAV_TITLE:
            switch (langCode) {
                case LANG_JP: return @"保存したﾃｷｽﾄ";
                default: return @"YOUR TEXTS";
            }
        case TRNS_TXT_NO_TITLE:
            switch (langCode) {
                case LANG_JP: return @"無題";
                default: return @"NO TITLE";
            }
        case TRNS_TXT_NEW_TITLE:
            switch (langCode) {
                case LANG_JP: return @"新規作成";
                default: return @"NEW TEXT";
            }
        case TRNS_TXT_TITLE:
            switch (langCode) {
                case LANG_JP: return @"ﾀｲﾄﾙ";
                default: return @"TITLE";
            }
        case TRNS_TXT_TITLE_PLACEFOLDER:
            switch (langCode) {
                case LANG_JP: return @"ﾀｲﾄﾙを入力";
                default: return @"title";
            }
        case TRNS_TXT_SAVE:
            switch (langCode) {
                case LANG_JP: return @"ﾃｷｽﾄを保存";
                default: return @"SAVE TEXT";
            }
        case TRNS_SETTINGS_NAV_TITLE:
            switch (langCode) {
                case LANG_JP: return @"設定";
                default: return @"SETTINGS";
            }
        case TRNS_SETTINGS_LABEL_LANG:
            switch (langCode) {
                case LANG_JP: return @"言語";
                default: return @"LANGUAGE";
            }
        case TRNS_SETTINGS_LABEL_CLR:
            switch (langCode) {
                case LANG_JP: return @"色";
                default: return @"COLOR";
            }
        case TRNS_KBD_TITLE:
            switch (langCode) {
                case LANG_JP: return @"ｷｰﾎﾞｰﾄﾞをｶｽﾀﾏｲｽﾞ";
                default: return @"EDIT YOUR IME";
            }
        case TRNS_KBD_INSERT_LEFT:
            switch (langCode) {
                case LANG_JP: return @"左に追加";
                default: return @"insert left";
            }
        case TRNS_KBD_INSERT_RIGHT:
            switch (langCode) {
                case LANG_JP: return @"右に追加";
                default: return @"insert right";
            }
        case TRNS_KBD_MOVE_LEFT:
            switch (langCode) {
                case LANG_JP: return @"左に移動";                    
                default: return @"move left";
            }
        case TRNS_KBD_MOVE_RIGHT:
            switch (langCode) {
                case LANG_JP: return @"右に移動";                    
                default: return @"move right";
            }
        case TRNS_KBD_CANCEL:
            switch (langCode) {
                case LANG_JP: return @"中身を編集";
                default: return @"edit contents";
            }
        case TRNS_KBD_SURE:
            switch (langCode) {
                case LANG_JP: return @"削除しますか？";
                default: return @"Are you sure you delete it?";
            }
        case TRNS_WEB_TITLE:
            switch (langCode) {
                case LANG_JP: return @"投稿／ﾀﾞｳﾝﾛｰﾄﾞ";
                default: return @"SHARE";
            }
        case TRNS_WEB_UPLOAD_IME:
            switch (langCode) {
                case LANG_JP: return @"ｶｽﾀﾑしたｷｰﾎﾞｰﾄﾞを投稿して\nみんなとｼｪｱしよう！";
                default: return @"Upload your IME\nand share it with others!";
            }
        case TRNS_WEB_UPLOAD_TEXT:
            switch (langCode) {
                case LANG_JP: return @"ﾃｷｽﾄを投稿して\nみんなとｼｪｱしよう！";
                default: return @"Upload your text\nand share it with others!";
            }
        case TRNS_WEB_DOWNLOAD_IME:
            switch (langCode) {
                case LANG_JP: return @"投稿されたｷｰﾎﾞｰﾄﾞを\nﾀﾞｳﾝﾛｰﾄﾞしよう！";
                default: return @"Download an IME\nposted by others!";
            }
        case TRNS_WEB_DOWNLOAD_TEXT:
            switch (langCode) {
                case LANG_JP: return @"投稿されたﾃｷｽﾄを\nﾀﾞｳﾝﾛｰﾄﾞしよう！";
                default: return @"Download a text\nposted by others!";
            }
        case TRNS_POLICY_TITLE:
            switch (langCode) {
                case LANG_JP:
                    return @"規約";
                default:
                    return @"AGREEMENT";
            }
        case TRNS_POLICY_CONTENT:
            switch (langCode) {
                case LANG_JP:
                    return @"<<アップロード>>\n投稿したデータは、以下のような場合に、通知なく消去されることがあります。\n ⅰ) 著作権等、第三者の権利を侵害する場合\n ⅱ) 第三者の誹謗中傷を含む場合\n ⅲ) その他、著しくモラルに反するような場合\n ⅳ) 上記に該当しなくとも、サービス運用上の都合による場合\n\n<<ダウンロード>>\nあなたが閲覧およびダウンロードするデータは、他の利用者の投稿によるものです。\nアプリケーション開発者は、その内容につき一切の責任を負いません。";
                default:
                    return @"<<UPLOAD>>\nThe data you upload could be deleted without notice if:\n ⅰ) it impinges on another's rights.\n ⅱ) it contains a calumny against another.\n ⅲ) it threatens public order and morals. \n ⅳ) neccessary for reasons of operation.\n\n<<DOWNLOAD>>\nThe data you would browse or download are posted by other users.\nThe application developer assumes no responsibility whatever for any direct, indirect, special, incidental, consequential damages and any other damages resulting from them.";
            }
        case TRNS_POLICY_AGREE:
            switch (langCode) {
                case LANG_JP:
                    return @"今回は同意する。";
                default:
                    return @"I agree this time.";
            }
        case TRNS_POLICY_DONT:
            switch (langCode) {
                case LANG_JP:
                    return @"同意しない。";
                default:
                    return @"I do not agree.";
            }
        case TRNS_POLICY_NEVER_SHOW:
            switch (langCode) {
                case LANG_JP:
                    return @"同意する。今後は表示しない。";
                default:
                    return @"I agree. And never ask me again.";
            }
        case TRNS_MAIL:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾌｨｰﾄﾞﾊﾞｯｸ／お問合";
                default:
                    return @"feedback/contact";
            }
        case TRNS_MAIL_TEXT:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾌｨｰﾄﾞﾊﾞｯｸがございましたら、是非お送りくださいませ。\nまた、ご質問には誠心誠意お答えさせていただきます。\n\n※ ﾒｰﾙに含まれる個人情報は、当該目的以外の使用はいたしません。\n※ 返答が必要な場合、数日を要する場合もございます。";
                default:
                    return @"The developper appreciates your feedbacks a lot, and is very willing to answer your questions.\n\n * Your personal information in the mail will not be used for other purpose whatssoever.\n * It may take a while before you get the developper's reply (if ever needed.)";
            }
        case TRNS_MAIL_SEND:
            switch (langCode) {
                case LANG_JP:
                    return @"同意してメールを送る";
                default:
                    return @"AGREE and SEND MAIL";
            }
        case TRNS_UI_TITLE:
            switch (langCode) {
                case LANG_JP:
                    return @"ｷｰﾎﾞｰﾄﾞをｱｯﾌﾟﾛｰﾄﾞ";
                default:
                    return @"UPLOAD IME";
            }
        case TRNS_UT_TITLE:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾃｷｽﾄをｱｯﾌﾟﾛｰﾄﾞ";
                default:
                    return @"UPLOAD TEXT";
            }
        case TRNS_DI_TITLE:
            switch (langCode) {
                case LANG_JP:
                    return @"ｷｰﾎﾞｰﾄﾞをﾀﾞｳﾝﾛｰﾄﾞ";
                default:
                    return @"DOWNLOAD IME";
            }
        case TRNS_DT_TITLE:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾃｷｽﾄをﾀﾞｳﾝﾛｰﾄﾞ";
                default:
                    return @"DOWNLOAD TEXT";
            }
        case TRNS_UD_GENRE:
            switch (langCode) {
                case LANG_JP:
                    return @"ジャンル : ";
                default:
                    return @"Genre : ";
            }
        case TRNS_UD_FAILED:
            switch (langCode) {
                case LANG_JP:
                    return @"データ通信に失敗しました。";
                default:
                    return @"Data Communication Failed.";
            }
        case TRNS_UD_RETRY:
            switch (langCode) {
                case LANG_JP:
                    return @"再試行";
                default:
                    return @"Retry";
            }
        case TRNS_D_GENRE_ALL:
            switch (langCode) {
                case LANG_JP:
                    return @"すべて";
                default:
                    return @"ALL";
            }
        case TRNS_D_SORT:
            switch (langCode) {
                case LANG_JP:
                    return @"並び順 : ";
                default:
                    return @"Sort : ";
            }
        case TRNS_D_SORT_DATE:
            switch (langCode) {
                case LANG_JP:
                    return @"新着順";
                default:
                    return @"Date";
            }
        case TRNS_D_SORT_POP:
            switch (langCode) {
                case LANG_JP:
                    return @"人気順";
                default:
                    return @"Popular";
            }
        case TRNS_D_NO_ITEM:
            switch (langCode) {
                case LANG_JP:
                    return @"投稿されたﾃﾞｰﾀがありません。";
                default:
                    return @"No data posted yet.";
            }
        case TRNS_D_DOWNLOAD:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾀﾞｳﾝﾛｰﾄﾞ";
                default:
                    return @"DOWNLOAD";
            }
        case TRNS_D_DONE:
            switch (langCode) {
                case LANG_JP:
                    return @"ﾀﾞｳﾝﾛｰﾄﾞしました。";
                default:
                    return @"Data downloaded.";
            }
        case TRNS_D_MORE:
            switch (langCode) {
                case LANG_JP:
                    return @"さらに見る...";
                default:
                    return @"See more...";
            }
        case TRNS_U_SELECT:
            switch (langCode) {
                case LANG_JP:
                    return @"ｱｯﾌﾟﾛｰﾄﾞするﾃﾞｰﾀを選んでください。";
                default:
                    return @"Select item to upload.";
            }
        case TRNS_U_NO_ITEM:
            switch (langCode) {
                case LANG_JP:
                    return @"保存されたﾃﾞｰﾀがありません。";
                default:
                    return @"You have no item saved.";
            }
        case TRNS_U_GENRE_SELECT:
            switch (langCode) {
                case LANG_JP:
                    return @"ｼﾞｬﾝﾙを選択してください。";
                default:
                    return @"Please select genre.";
            }
        case TRNS_U_GENRE_NONE:
            switch (langCode) {
                case LANG_JP:
                    return @"なし";
                default:
                    return @"none";
            }
        case TRNS_U_SUCCESS:
            switch (langCode) {
                case LANG_JP:
                    return @"ｱｯﾌﾟﾛｰﾄﾞ完了";
                default:
                    return @"DONE";
            }
        case TRNS_U_EMPTY:
            switch (langCode) {
                case LANG_JP:
                    return @"中身がありません！";
                default:
                    return @"It's empty!";
            }
        default:
            return @"";
    }
}

-(NSInteger) getLangCode{
    return langCode;
}
@end
