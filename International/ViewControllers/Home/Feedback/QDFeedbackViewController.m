//
//  QDFeedbackViewController.m
//  International
//
//  Created by hzg on 2022/1/8.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDFeedbackViewController.h"
#import "QDCheckBoxButton.h"
#import "UIUtils.h"
#import "QDSizeUtils.h"
#import "QDBaseResultModel.h"

@interface QDFeedbackViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *wrapView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@property (nonatomic, strong) NSMutableArray<QDCheckBoxButton*>* checkButtons;

@property (nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UILabel  *placeHolder;
@property (nonatomic, strong) UILabel *textViewNumLabel;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel     *textFieldLabel;

@property (nonatomic, assign) CGFloat viewOriginY;

@end

@implementation QDFeedbackViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self setUpNavBar];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Feedback_Text", nil);
    [self setup];
    [self registerNotification];
}

- (void)dealloc {
    [self unregisterNotification];
}

- (void) registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewEditChanged:)
                                                name:UITextViewTextDidChangeNotification
                                              object:self.textView];
}

- (void) unregisterNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)setUpNavBar {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setup {
//    self.edgesForExtendedLayout = YES;
    self.viewOriginY = self.view.frame.origin.y;
    self.wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+44, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.wrapView];
    [self setupScrollView];
//    [self setupTitle:NSLocalizedString(@"Feedback_Text", nil)];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - [QDSizeUtils navigationHeight] - 44)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void) setupScrollView {
    
    // root scrollview
    [self.wrapView addSubview:self.scrollView];
    
    [self setupOutsideButton];
    [self setupMutiChoices];
    [self setupDetails];
    [self setupEmail];
    [self setupSubmitButton];
    
    // banner 50
    self.scrollViewHeight += 10 + kStatusBarHeight + 44; //blank
    self.scrollViewHeight += 50;
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_W, self.scrollViewHeight)];
}

// outside
- (void) setupOutsideButton {
    UIButton* rootView = [UIButton new];
    [rootView addTarget:self action:@selector(outsideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 快捷问题选项 多选
- (void) setupMutiChoices {
    
    self.scrollViewHeight += 20;
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = NSLocalizedString(@"Feedback_myproblem", nil);
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.height.equalTo(@(20));
        make.left.equalTo(@(15));
    }];
    
    self.scrollViewHeight += 40;
    
    self.checkButtons = [NSMutableArray new];
    
    NSArray<NSString*>* dataArr = @[
        NSLocalizedString(@"Feedback_failconnect", nil),
        NSLocalizedString(@"Feedback_slowspeed", nil),
        NSLocalizedString(@"Feedback_lackline", nil),
        NSLocalizedString(@"Feedback_Disconnect_Game", nil),
        NSLocalizedString(@"Feedback_somethings_else", nil)
    ];
    
    CGFloat w = 161, h = 38, margin = 12, blank = 10;
    int rowOfCount = IS_IPAD ? 4 : 2;
    int i = 0;
    for (NSString* str in dataArr) {
        QDCheckBoxButton* button = [[QDCheckBoxButton alloc] initWithFrame:CGRectZero text:str];
        [self.scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
            make.height.equalTo(@(h));
            make.width.equalTo(@(w));
            if (IS_IPAD) {
                make.left.equalTo(self.view).offset(margin + (i % rowOfCount)*(w+blank));
            } else {
                if (i % rowOfCount == 0) {
                    make.left.equalTo(self.view).offset(margin);
                }
                else {
                    make.right.equalTo(self.view).offset(-margin);
                }
            }
        }];
        i += 1;
        if (i % rowOfCount == 0) {
            self.scrollViewHeight += (h + blank);
        }
        [self.checkButtons addObject:button];
    }
    
    // 补全
    if (i % rowOfCount != 0) {
        self.scrollViewHeight += (h + blank);
    }
}

// 详细问题
- (void) setupDetails {
    
    self.scrollViewHeight += 20;
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = NSLocalizedString(@"Feedback_details", nil);
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.height.equalTo(@(20));
        make.left.equalTo(@(15));
    }];
    
    self.scrollViewHeight += 30;
    
    CGFloat height = 157, margin = 12;
    UIView* textBackView = [UIView new];
    textBackView.layer.cornerRadius = 4;
    textBackView.layer.masksToBounds = YES;
    textBackView.backgroundColor = RGB_HEX(0xf3f3f3);
    [self.scrollView addSubview:textBackView];
    [textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(SCREEN_W - 24));
        make.height.equalTo(@(height));
    }];
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.backgroundColor = RGB_HEX(0xf3f3f3);
    self.textView.textColor = [UIColor blackColor];
    self.textView.returnKeyType = UIReturnKeyNext;
    self.textView.font = [UIFont systemFontOfSize:12];
    [textBackView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(textBackView).offset(margin);
        make.right.bottom.equalTo(textBackView).offset(-margin);
    }];
    
//    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
//    BOOL hasReward = !QDConfigManager.shared.isCommitIssue && !isVIP;
    UILabel *placeHolder = [UILabel new];
//    placeHolder.text = hasReward ? NSLocalizedString(@"Feedback_details_placeholder2", nil) : NSLocalizedString(@"Feedback_details_placeholder1", nil);
    placeHolder.text = NSLocalizedString(@"Feedback_details_placeholder3", nil);
    placeHolder.textColor = [UIColor lightGrayColor];
    placeHolder.numberOfLines = 0;
    placeHolder.font = [UIFont systemFontOfSize:12];
    [self.textView addSubview:placeHolder];
    [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(6);
        make.top.equalTo(self.textView).offset(10);
        make.width.equalTo(@(SCREEN_W - 24 - 24));
    }];
    self.placeHolder = placeHolder;
    
    
    self.textViewNumLabel = [UILabel new];
    self.textViewNumLabel.font = [UIFont systemFontOfSize:12];
    self.textViewNumLabel.text = @"0/300";
    self.textViewNumLabel.textColor = [UIColor lightGrayColor];
    [textBackView addSubview:self.textViewNumLabel];
    [self.textViewNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(textBackView).offset(-12);
    }];
    
    self.scrollViewHeight += height;
}

// email
- (void) setupEmail {
    
    self.scrollViewHeight += 20;
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = NSLocalizedString(@"Feedback_contact", nil);
    [self.scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.height.equalTo(@(20));
        make.left.equalTo(@(15));
    }];
    
    self.scrollViewHeight += 30;
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.textColor = [UIColor blackColor];
    self.textField.font = [UIFont systemFontOfSize:12];
    self.textField.placeholder = NSLocalizedString(@"Feedback_email_placeholder1", nil);
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.width.equalTo(@(SCREEN_W - 24));
        make.height.equalTo(@(44));
        make.centerX.equalTo(self.scrollView);
    }];
    NSLog(@"%@",QDConfigManager.shared.email);
    if (QDConfigManager.shared.activeModel.email && ![QDConfigManager.shared.activeModel.email isEqualToString:@""])
        self.textField.text = QDConfigManager.shared.activeModel.email;
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = RGB_HEX(0xe5eff0);
    [self.textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.textField).offset(0);
        make.height.equalTo(@(0.5));
    }];
    
    self.scrollViewHeight += 44;
    self.scrollViewHeight += 5;
    
//    self.textFieldLabel = [UILabel new];
//    self.textFieldLabel.font = [UIFont systemFontOfSize:12];
//    self.textFieldLabel.textColor = [UIColor redColor];
//    self.textFieldLabel.text = NSLocalizedString(@"Feedback_email_error", nil);
//    [self.scrollView addSubview:self.textFieldLabel];
//    [self.textFieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
//        make.height.equalTo(@(20));
//        make.left.equalTo(@(12));
//    }];
//    [self textValueChanged:NULL];
    
    self.scrollViewHeight += 20;
}

// commmit button
- (void) setupSubmitButton {
    
    self.scrollViewHeight += 20;
    
    CGFloat height = 50;
    UIButton* commitButton = [UIButton new];
    commitButton.layer.cornerRadius = 4;
    commitButton.layer.masksToBounds = YES;
//    commitButton.backgroundColor = RGB_HEX(0x3e9efa);
    [commitButton setBackgroundImage:[UIImage imageNamed:@"home_premium"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.width.equalTo(@(240));
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(height));
    }];
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Feedback_submit", nil);
    [commitButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(commitButton);
    }];
    
    self.scrollViewHeight += height;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
    self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
}

// 这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
       //在这里做你响应return键的代码
        [textView resignFirstResponder];
        [self.textField becomeFirstResponder];
       return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }

    return YES;
}

-(void)textViewEditChanged:(NSNotification *)obj{
    //获取正在输入的textView
    int maxLength = 300;
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textView.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength) {
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
    self.textViewNumLabel.text = [NSString stringWithFormat:@"%ld/%d", [textView.text length], maxLength];
}

//监听文本框的值的改变
- (void) textValueChanged:(NSNotification *)notice {
//    BOOL isValid = NO;
//    if (self.textField.text) isValid = [UIUtils isValidateEmail:self.textField.text];
//    BOOL visiable = self.textField.text != nil && ![self.textField.text isEqual:@""] && !isValid;
//    [self.textFieldLabel setHidden:!visiable];
}


//点击输入框界面跟随键盘上移
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat offSet = IS_IPAD ? 352 : 270;
    offSet = SCREEN_H - textField.frame.origin.y - offSet - 60 - [QDSizeUtils navigationHeight] - 44;
    
    //iphone键盘高度为216.iped键盘高度为352
    //将试图的Y坐标向上移动offset个单位，以使线面腾出开的地方用于软键盘的显示
    if (offSet < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapView.mj_y = offSet;
        }];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self submitAction];
    return YES;
}


#pragma  mark - button actions
- (void) outsideAction {
    self.wrapView.mj_y = kStatusBarHeight+kAppNavigationBarHeight;
    if (self.textView.isFirstResponder)
        [self.textView resignFirstResponder];
    if (self.textField.isFirstResponder)
        [self.textField resignFirstResponder];
    
}

- (void) submitAction {
    self.wrapView.mj_y = kStatusBarHeight+kAppNavigationBarHeight;
    
    // 关闭键盘
    if (self.textView.isFirstResponder)
        [self.textView resignFirstResponder];
    if (self.textField.isFirstResponder)
        [self.textField resignFirstResponder];
    
    BOOL isSelectLacklines = NO;
    NSString* lacklines = NSLocalizedString(@"Feedback_lackline", nil);
    NSString* typeStr = @"";
    for (QDCheckBoxButton* button in self.checkButtons) {
        if (button.isSelected) {
            if ([typeStr isEqualToString:@""]) {
                typeStr = [typeStr stringByAppendingString:button.text];
            } else {
                typeStr = [typeStr stringByAppendingFormat:@";%@", button.text];
            }
            if ([lacklines isEqualToString:button.text]) {
                isSelectLacklines = YES;
            }
        }
    }
    

    if ((!self.textView || [self.textView.text isEqualToString:@""]) && [typeStr isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Toast_Feedback_fail", nil)];
        return;
    }
    
    
    NSString* content = @"";
    if (self.textView.text) content = self.textView.text;
    
    NSString* email = @"";
    if (self.textField.text) {
        email = self.textField.text;
    }

    BOOL isEmail = [UIUtils isValidateEmail:email];
    if (isEmail == NO) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Feedback_email_invaild", nil)];
        return;
    }
    
    [SVProgressHUD show];
    [QDModelManager requestFeedback:typeStr email:email content:content completed:^(NSDictionary * _Nonnull dictionary) {
        NSLog(@"dictionary = %@", dictionary);
        QDBaseResultModel* result = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (result.code == kHttpStatusCode200) {
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            // 刷新用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserActive object:nil];
            
//            [self doCommitSuccAction:isSelectLacklines message:NSLocalizedString(@"Toast_Feedback_succ1", nil)];
            
//            if (!QDConfigManager.shared.isCommitIssue) {
//                // 奖励
//                QDConfigManager.shared.isCommitIssue = YES;
//
//                [QDModelManager requestUserAddTimeNew:4 time:1*24*60*60 completed:^(NSDictionary * _Nonnull dictionary) {
//                    QDBaseResultModel* result1 = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
//                    if (result1.code == kHttpStatusCode200) {
//                        [self.navigationController popViewControllerAnimated:YES];
//
//                        // 刷新用户信息
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
//
//                        [self doCommitSuccAction:isSelectLacklines message:NSLocalizedString(@"Toast_Feedback_succ2", nil)];
//
//                        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Toast_Feedback_succ2", nil)];
//                    } else {
//                        [SVProgressHUD showErrorWithStatus:result1.message];
//                    }
//                }];
//            } else {
////                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Toast_Feedback_succ1", nil)];
//                [self.navigationController popViewControllerAnimated:YES];
//
//                // 刷新用户信息
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserActive object:nil];
//
//                [self doCommitSuccAction:isSelectLacklines message:NSLocalizedString(@"Toast_Feedback_succ1", nil)];
//            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:result.message];
        }
    }];
}

// 评论提交成功
- (void) doCommitSuccAction:(BOOL) showRecommandApp message:(NSString*)message {
    BOOL showTelegram = YES;
    if (showRecommandApp) {
        BOOL show_app_ad = QDVersionManager.shared.versionConfig && [QDVersionManager.shared.versionConfig[@"show_app_ad"] intValue] == 1;
        BOOL isVIP = QDConfigManager.shared.activeModel&& QDConfigManager.shared.activeModel.member_type == 1;
        
        // 交叉推广
        NSLocale *currentLocale = [NSLocale currentLocale];
        NSString* code = [currentLocale objectForKey:NSLocaleCountryCode];
        BOOL isPK = [code isEqualToString:@"PK"];
        BOOL showRecommandView = !isVIP && show_app_ad && isPK;
        if (showRecommandView) {
            showTelegram = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecommandApp object:nil];
        }
    }
    
    if (showTelegram) {
        NSString* telegram = @"Telegram";
        NSString* whatsapp = @"WhatsApp";
        NSString* telegram_url = @"https://t.me/+4MliG233smoxYjFl";
        NSString* whatsapp_url = @"https://chat.whatsapp.com/CwmwkQy7d0YB2FS3xhZaS5";
        if (QDVersionManager.shared.versionConfig != nil) {
            if (QDVersionManager.shared.versionConfig[@"link_telegram"]) {
                telegram_url = QDVersionManager.shared.versionConfig[@"link_telegram"];
            }
            if (QDVersionManager.shared.versionConfig[@"link_whatsapp"]) {
                whatsapp_url = QDVersionManager.shared.versionConfig[@"link_whatsapp"];
            }
        }
        
        [QDDialogView showTelegram:message items:@[telegram, whatsapp]
              hideWhenTouchOutside:YES cancel:NSLocalizedString(@"Dialog_Cancel", nil) callback:^(NSString *item) {
            if ([telegram isEqualToString:item]) {
                [UIUtils openURLWithString:telegram_url];
            } else if ([whatsapp isEqualToString:item]) {
                [UIUtils openURLWithString:whatsapp_url];
            }
        }];
    }
}



@end
