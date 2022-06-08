//
//  QDForgetPasswordViewController.m
//  International
//
//  Created by hzg on 2021/9/2.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDForgetPasswordViewController.h"
#import "QDSizeUtils.h"
#import "QDButton.h"
#import "UIUtils.h"
#import "QDBaseResultModel.h"
#import "QDResetPasswordViewController.h"

@interface QDForgetPasswordViewController () <UITextFieldDelegate>

@property(nonatomic, strong) UITextField* emailTextField;
@property(nonatomic, strong) UITextField* codeTextField;

@property(nonatomic, strong) UIButton* sendCodeButton;
@property(nonatomic, strong) NSTimer* timer;
@property(nonatomic, assign) int totalTimeCount;

@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UILabel* descLabel;
@property(nonatomic, strong) UIButton* signupButton;

@end

@implementation QDForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!QDConfigManager.shared.activeModel||QDConfigManager.shared.activeModel.member_type != 1) {
        CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
        [QDAdManager.shared showBanner:self toBottom:toBottom];
    }
}

- (void) setup {
    
    // close
    UIButton* closeButton = [UIButton new];
    [self.view addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(self.view).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    // Navtitle
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"Reset_Password", nil);
    label.textColor     = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(closeButton.mas_right);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(closeButton);
    }];
    
    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Forgot_Email_title_tip", nil);
    titleLabel.numberOfLines = 0;
    titleLabel.font = kSFUIDisplayFont(22);
    titleLabel.textColor = RGB_HEX(0x333333);
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(32);
        make.top.equalTo(label.mas_bottom).offset(17);
    }];
    
    // desc
    UILabel* descLabel = [UILabel new];
    descLabel.text = NSLocalizedString(@"Forgot_Email_desc_tip", nil);
    descLabel.numberOfLines = 0;
    descLabel.font = kSFUITextFont(12);
    descLabel.textColor = RGB_HEX(0xCCCCCC);
    [self.view addSubview:descLabel];
    _descLabel = descLabel;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(titleLabel);
        make.height.mas_equalTo(14);
        make.top.equalTo(titleLabel.mas_bottom).offset(4);
    }];
    
    // email背景
    UIImageView * emailView = [[UIImageView alloc] init];
//    emailView.image = [UIImage imageNamed:@"login_tf_bg"];
    UIImage * emailImage = [UIImage imageNamed:@"login_tf_bg"];
    emailImage = [emailImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    emailView.image = emailImage;
    emailView.userInteractionEnabled = YES;
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(51));
        make.top.equalTo(descLabel.mas_bottom).offset(22);
    }];
    
    self.emailTextField = [UITextField new];
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.emailTextField.placeholder = NSLocalizedString(@"Email", nil);
    self.emailTextField.enablesReturnKeyAutomatically = YES;
    self.emailTextField.delegate = self;
    [emailView addSubview:self.self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailView).offset(15);
        make.right.equalTo(emailView).offset(-15);
        make.height.equalTo(emailView);
    }];

    // code背景
    UIImageView * codeView = [[UIImageView alloc] init];
//    codeView.image = [UIImage imageNamed:@"login_tf_bg"];
    UIImage * codeImage = [UIImage imageNamed:@"login_tf_bg"];
    codeImage = [codeImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    codeView.image = codeImage;
    codeView.userInteractionEnabled = YES;
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(51));
        make.top.equalTo(emailView.mas_bottom).offset(20);
    }];
    
    self.codeTextField = [UITextField new];
    self.codeTextField.returnKeyType = UIReturnKeyNext;
    self.codeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.codeTextField.placeholder = NSLocalizedString(@"Forgot_Email_Code", nil);
    self.codeTextField.enablesReturnKeyAutomatically = YES;
    self.codeTextField.delegate = self;
    [codeView addSubview:self.self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView).offset(15);
        make.right.equalTo(codeView).offset(-15);
        make.height.equalTo(codeView);
    }];
    
    // send&resend code
    self.sendCodeButton = [UIButton new];
    self.sendCodeButton.backgroundColor = RGB_HEX(0xF4F4F4);
    [self.sendCodeButton setTitle:@"Send Code" forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:RGB_HEX(0x27A3EF) forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = kSFUITextFont(13);
    [self.sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:self.sendCodeButton];
    [self.sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(2));
        make.right.bottom.equalTo(@(-2));
        make.width.equalTo(@(90));
    }];
    
    // forgot password
    UIButton* forgotButton = [UIButton new];
    [forgotButton setTitle:NSLocalizedString(@"Forgot_Email", nil) forState:UIControlStateNormal];
    [forgotButton setTitleColor:RGB_HEX(0x999999) forState:UIControlStateNormal];
    [self.view addSubview:forgotButton];
    [forgotButton addTarget:self action:@selector(forgotAction) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(12);
        make.right.equalTo(codeView.mas_right);
//        make.width.equalTo(@(110));
        make.height.equalTo(@(44));
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor     = RGB_HEX(0xbfbfbf);
    [forgotButton addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(forgotButton);
        make.top.equalTo(forgotButton.mas_bottom);
        make.height.equalTo(@(1));
        make.right.equalTo(forgotButton);
    }];
    
    [self updateCodeText:0];
    
    self.signupButton = [UIButton new];
    [self.signupButton setTitle:NSLocalizedString(@"Forgot_Nextstep", nil) forState:UIControlStateNormal];
    UIImage * image = [UIImage imageNamed:@"home_premium"];
    image = [image stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    [self.signupButton setBackgroundImage:image forState:UIControlStateNormal];
    self.signupButton.titleLabel.font = kSFUIDisplayFont(20);
    [self.view addSubview:self.signupButton];
    [self.signupButton addTarget:self action:@selector(verifyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@240);
        make.height.equalTo(@(50));
        make.top.equalTo(codeView.mas_bottom).offset(85);
    }];
    [self setUnEnableLoginButton];
    [self.view layoutIfNeeded];
    self.sendCodeButton.layer.mask = [self getRectCorner:self.sendCodeButton corners:UIRectCornerTopRight | UIRectCornerBottomRight radii:CGSizeMake(25, 25)];
}

- (void)setEnableLoginButton {
    self.signupButton.alpha = 1;
    self.signupButton.userInteractionEnabled = YES;
}

- (void)setUnEnableLoginButton {
    self.signupButton.alpha = 0.5;
    self.signupButton.userInteractionEnabled = NO;
}

// 登录预处理操作
- (void) doPreprogressAction {
    NSString* account = self.emailTextField.text;
    NSString* code = self.codeTextField.text;
    BOOL isEnabled = account&&![account isEqual:@""]&&code&&![code isEqual:@""];
    if (isEnabled) {
        [self setEnableLoginButton];
    }
}

// 进入重置密码解码
- (void) goResetViewController {
    QDResetPasswordViewController* vc = [QDResetPasswordViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

# pragma mark - actions
- (void) outsideAction {
    [self.emailTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

- (void) closeAction {
    [self stopTimer];
    UIViewController* vc = self.presentingViewController;
    UIViewController* currentVC = vc;
    while(vc) {
        vc = vc.presentingViewController;
        if (vc) {
            currentVC = vc;
        }
    }
    [currentVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendCodeAction {
    NSString* account = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 邮箱是否为空
    if (!account || [account isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Empty", nil)];
        return;
    }
    
    // 邮箱是否合法
    if (![UIUtils isValidateEmail:account]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Invaid", nil)];
        return;
    }
    
    [self.sendCodeButton setEnabled:NO];
    [self startTimer];
    [SVProgressHUD show];
    [QDModelManager requestEmailCode:account type:2 completed:^(NSDictionary * _Nonnull dictionary) {
        [SVProgressHUD dismiss];
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel&&resultModel.code == kHttpStatusCode200) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Send_Code_Success", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
            [self stopTimer];
            [self updateCodeText:2];
        }
    }];
}

- (void) verifyAction {
    // 去掉焦点
    [self.emailTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    // 检查操作
    NSString* account = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* code = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 邮箱是否为空
    if (!account || [account isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Empty", nil)];
        return;
    }
    
    // 邮箱是否合法
    if (![UIUtils isValidateEmail:account]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Invaid", nil)];
        return;
    }
    
    // code是否为空
    if (!code || [code isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Code_Invaid", nil)];
        return;
    }
    
    // code是否合法
    if (![UIUtils isPureInt:code]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Code_Invaid", nil)];
        return;
    }
    
    [SVProgressHUD show];
    [QDModelManager requestVerifyEmailCode:code type:2 completed:^(NSDictionary * _Nonnull dictionary) {
        [SVProgressHUD dismiss];
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel&&resultModel.code == kHttpStatusCode200) {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Password_Reset_success", nil)];
            [self goResetViewController];
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
            [self stopTimer];
            [self updateCodeText:2];
        }
    }];
}

// 忘记邮箱
- (void) forgotAction {
    [QDDialogManager showItemsDialog:self title:NSLocalizedString(@"Dialog_Contact_Title", nil) message:NSLocalizedString(@"Dialog_Contact_Text", nil) actionItems:@[NSLocalizedString(@"Dialog_Ok", nil)] callback:^(NSString *itemName) {
        
    }];
}

- (void)accountTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

- (void)codeTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

#pragma mark - delegete
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self doPreprogressAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.codeTextField becomeFirstResponder];
    } else {
        [self verifyAction];
    }
    return YES;
}

# pragma mark - timer
- (void) startTimer {
    
    // 停止
    [self stopTimer];
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        // 检查时间
        if (strongSelf.totalTimeCount > 0) {
            strongSelf.totalTimeCount -= 1;
            [strongSelf updateCodeText:1];
        } else {
            [strongSelf stopTimer];
            [strongSelf updateCodeText:2];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.totalTimeCount = 60;
    [self updateCodeText:1];
}

// 0表示发送，1表示发送中，2表示重新发送
- (void) updateCodeText:(int)status {
    UIColor* color = RGB_HEX(0x00aee9);
    NSString* text = NSLocalizedString(@"Send_Code", nil);
    BOOL isEnabled = YES;
    switch (status) {
        case 1:
        {
            isEnabled = NO;
            color = RGB_HEX(0xbfbfbf);
            text = [NSString stringWithFormat:@"%ds", self.totalTimeCount];
        }
            break;
        case 2:
        {
            text = NSLocalizedString(@"Resend_Code", nil);
        }
            break;
        case 0:
        default:
            break;
    }
//    self.codeLabel.text = text;
//    self.codeLabel.textColor = color;
//    [self.sendCodeButton setEnabled:isEnabled];

    [self.sendCodeButton setTitle:text forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:color forState:UIControlStateNormal];

}

- (void) stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (CAShapeLayer *)getRectCorner:(UIView *)view corners:(UIRectCorner)corners radii:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
    byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}


@end

