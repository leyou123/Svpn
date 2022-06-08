//
//  QDForgetFillEmailViewController.m
//  International
//
//  Created by LC on 2022/4/22.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDForgetFillEmailViewController.h"
#import "QDSizeUtils.h"
#import "QDResetPasswordViewController.h"
#import "UIUtils.h"
#import "QDBaseResultModel.h"

@interface QDForgetFillEmailViewController ()

@property (nonatomic, strong) UITextField * emailTextField;
@property (nonatomic, strong) UITextField * codeTextField;

@property (nonatomic, strong) UIButton * signupButton;
@property (nonatomic, strong) UILabel * countDownLB;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descLabel;

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger totalTimeCount;

@end

@implementation QDForgetFillEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubviews];
}

- (void)setUpSubviews {
    
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
    
    // textfiled背景
    UIImageView * emailView = [[UIImageView alloc] init];
    emailView.image = [UIImage imageNamed:@"login_tf_bg"];
    emailView.userInteractionEnabled = YES;
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(51));
        make.top.equalTo(descLabel.mas_bottom).offset(22);
    }];
    
    // email
    {
        self.emailTextField = [UITextField new];
        self.emailTextField.returnKeyType = UIReturnKeyNext;
        self.emailTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.emailTextField.placeholder = NSLocalizedString(@"LoginEmail", nil);
        self.emailTextField.enablesReturnKeyAutomatically = YES;
        self.emailTextField.hidden = YES;
        [emailView addSubview:self.self.emailTextField];
        [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(emailView).offset(15);
            make.right.equalTo(emailView).offset(-15);
            make.height.equalTo(emailView);
        }];
    }
    // verification
    {
        self.codeTextField = [UITextField new];
        self.codeTextField.returnKeyType = UIReturnKeyNext;
        self.codeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.codeTextField.placeholder = NSLocalizedString(@"Password_verification", nil);
        self.codeTextField.enablesReturnKeyAutomatically = YES;
        self.codeTextField.hidden = YES;
        [emailView addSubview:self.self.codeTextField];
        [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(emailView).offset(15);
            make.right.equalTo(emailView).offset(-15);
            make.height.equalTo(emailView);
        }];
        
        UILabel * countDownLB = [[UILabel alloc] init];
        countDownLB.font = kSFUITextFont(12);
        countDownLB.textColor = RGB_HEX(0xCCCCCC);
        countDownLB.hidden = YES;
        [self.view addSubview:countDownLB];
        _countDownLB = countDownLB;
        [_countDownLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(emailView).offset(15);
            make.top.equalTo(emailView.mas_bottom).offset(4);
            make.height.mas_equalTo(14);
        }];
    }
    self.signupButton = [UIButton new];
    [self.signupButton setTitle:NSLocalizedString(@"Forgot_Nextstep", nil) forState:UIControlStateNormal];
    UIImage * image = [UIImage imageNamed:@"home_premium"];
    image = [image stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    [self.signupButton setBackgroundImage:image forState:UIControlStateNormal];
    self.signupButton.titleLabel.font = kSFUIDisplayFont(20);
    [self.view addSubview:self.signupButton];
    [self.signupButton addTarget:self action:@selector(signupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.equalTo(@(50));
        make.top.equalTo(emailView.mas_bottom).offset(40);
    }];
    [self updateView];
}

- (void)updateView {
    [self showEmail];
}

- (void)showEmail {
    self.titleLabel.text = NSLocalizedString(@"Forgot_Email_title_tip", nil);
    self.descLabel.text = NSLocalizedString(@"Forgot_Email_desc_tip", nil);
    self.emailTextField.hidden = NO;
    self.codeTextField.hidden = YES;
    self.countDownLB.hidden = YES;
    self.page = PageFillEmail;
}

- (void)showVerification {
    self.titleLabel.text = NSLocalizedString(@"Forgot_Verification_title_tip", nil);
    self.descLabel.text = NSLocalizedString(@"Forgot_Verification_desc_tip", nil);
    self.emailTextField.hidden = YES;
    self.codeTextField.hidden = NO;
    self.countDownLB.hidden = NO;
    self.page = PageVerifation;
}


// 关闭
- (void)closeAction {
    if (self.page == PageVerifation) {
        [self showEmail];
    }else {
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
}

// next step
- (void)signupAction {
    if (self.page == PageFillEmail) {
        [self sendCodeAction];
        [self startTimer];
    }else {
        [self verifyAction];
    }
}

- (void) sendCodeAction {
    
    [self.emailTextField resignFirstResponder];
    
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
    
//    [self.sendCodeButton setEnabled:NO];
    [SVProgressHUD show];
    [QDModelManager requestEmailCode:account type:2 completed:^(NSDictionary * _Nonnull dictionary) {
        [SVProgressHUD dismiss];
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel&&resultModel.code == kHttpStatusCode200) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Send_Code_Success", nil)];
            [self showVerification];
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
        }
    }];
}

- (void) verifyAction {
    // 去掉焦点
    [self.codeTextField resignFirstResponder];
    
    // 检查操作
    NSString* code = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
            QDResetPasswordViewController * vc = [[QDResetPasswordViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
//            [self stopTimer];
//            [self updateCodeText:2];
        }
    }];
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
            text = [NSString stringWithFormat:@"%lds", self.totalTimeCount];
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
    self.countDownLB.text = text;
    self.countDownLB.textColor = color;
//    [self.s setEnabled:isEnabled];
}

- (void) stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
    
