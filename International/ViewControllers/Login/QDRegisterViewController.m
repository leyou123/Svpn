//
//  QDRegisterViewController.m
//  International
//
//  Created by hzg on 2021/9/2.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDRegisterViewController.h"
#import "QDButton.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"
#import "QDDeviceActiveResultModel.h"
#import "QDPasswordView.h"
#import "QDLoginViewController.h"

@interface QDRegisterViewController () <UITextFieldDelegate>

//@property(nonatomic, strong) QDButton* signupButton;
@property(nonatomic, strong) UIButton* signupButton;
@property(nonatomic, strong) UITextField* accoutTextField;
@property(nonatomic, strong) UITextField* passwordTextField;
@property(nonatomic, strong) UIImageView* eyeImageView;

@property(nonatomic, strong) UITextField* codeTextField;
@property(nonatomic, strong) UIButton* sendCodeButton;
@property(nonatomic, strong) UILabel* codeLabel;
@property(nonatomic, strong) NSTimer* timer;
@property(nonatomic, assign) int totalTimeCount;

@property(nonatomic, strong) QDPasswordView* passwordComplexView;

@end


@implementation QDRegisterViewController

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
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    // close
    UIButton* closeButton = [UIButton new];
    [self.view addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"feature_close_btn"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(self.view).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    // title
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"Register_Uppercase", nil);
    label.textColor     = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(closeButton);
        make.left.equalTo(closeButton.mas_right);
    }];
    
    // title
    UILabel* sublabel      = [UILabel new];
    sublabel.text          = NSLocalizedString(@"Register_Target", nil);
    sublabel.textColor     = [UIColor grayColor];
    sublabel.font = [UIFont systemFontOfSize:12];
    sublabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sublabel];
    [sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(label.mas_bottom).offset(8);
    }];
    [sublabel sizeToFit];
    
    // E-mail
    CGFloat gap = 35;
    CGFloat height = 50;
    UIImageView * emailView = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"login_tf_bg"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    emailView.image = image;
    emailView.userInteractionEnabled = YES;
    [self.view addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(gap));
        make.right.equalTo(@(-gap));
        make.height.equalTo(@(height));
        make.top.equalTo(sublabel.mas_bottom).offset(16);
    }];
    self.accoutTextField = [UITextField new];
    self.accoutTextField.returnKeyType = UIReturnKeyNext;
    self.accoutTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.accoutTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accoutTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Email", nil) attributes:
    @{NSForegroundColorAttributeName:RGB_HEX(0xCCCCCC),
    NSFontAttributeName:kSFUITextFont(17)}
    ];
    self.accoutTextField.attributedPlaceholder = attrString;
    self.accoutTextField.delegate = self;
    [self.accoutTextField addTarget:self action:@selector(accountTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.accoutTextField.enablesReturnKeyAutomatically = YES;
    [emailView addSubview:self.accoutTextField];
    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailView).offset(12);
        make.right.equalTo(emailView).offset(-12);
        make.height.equalTo(emailView);
        make.centerX.equalTo(emailView);
    }];
    
    UIImageView * codeView = [[UIImageView alloc] init];
    UIImage * codeImage = [UIImage imageNamed:@"login_tf_bg"];
    codeImage = [codeImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    codeView.image = codeImage;
    codeView.userInteractionEnabled = YES;
    [self.view addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(gap));
        make.right.equalTo(@(-gap));
        make.height.equalTo(@(height));
        make.top.equalTo(emailView.mas_bottom).offset(16);
    }];
    self.codeTextField = [UITextField new];
    self.codeTextField.returnKeyType = UIReturnKeyNext;
    self.codeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.codeTextField.placeholder = NSLocalizedString(@"Email_Verification", nil);
    self.codeTextField.delegate = self;
    [self.codeTextField addTarget:self action:@selector(codeTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.codeTextField.enablesReturnKeyAutomatically = YES;
    [codeView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView).offset(12);
        make.right.equalTo(codeView).offset(-100);
        make.height.equalTo(codeView);
    }];
    
    // send&resend code
    self.sendCodeButton = [UIButton new];
    self.sendCodeButton.backgroundColor = RGB_HEX(0xF4F4F4);
    [codeView addSubview:self.sendCodeButton];
    [self.sendCodeButton addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(1));
        make.right.bottom.equalTo(@(-1));
        make.width.equalTo(@(90));
    }];
    
    self.codeLabel = [UILabel new];
    [self.sendCodeButton addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.sendCodeButton);
    }];
    self.codeLabel.font = [UIFont systemFontOfSize:14];
    self.codeLabel.textColor = RGB_HEX(0x00aee9);
    [self updateCodeText:0];
    
    // Password
    UIImageView * passwordView = [[UIImageView alloc] init];
    UIImage * passworImage = [UIImage imageNamed:@"login_tf_bg"];
    passworImage = [passworImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    passwordView.image = passworImage;
    passwordView.userInteractionEnabled = YES;
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(gap));
        make.right.equalTo(@(-gap));
        make.height.equalTo(@(height));
        make.top.equalTo(codeView.mas_bottom).offset(16);
    }];
    self.passwordTextField = [UITextField new];
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    self.passwordTextField.delegate = self;
    [self.passwordTextField addTarget:self action:@selector(passwordTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.passwordTextField.enablesReturnKeyAutomatically = YES;
    [passwordView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView).offset(12);
        make.right.equalTo(passwordView).offset(-68);
        make.centerX.height.equalTo(passwordView);
    }];
    
    // view password button
    UIButton* viewPasswordButton = [UIButton new];
    [viewPasswordButton addTarget:self action:@selector(viewPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:viewPasswordButton];
    [viewPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passwordView).offset(-12);
        make.centerY.equalTo(passwordView);
        make.width.height.equalTo(@(44));
    }];
    self.eyeImageView = [UIImageView new];
    [viewPasswordButton addSubview:self.eyeImageView];
    [self.eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewPasswordButton);
    }];
    [self refreshPasswordView];
    
    self.passwordComplexView = [[QDPasswordView alloc] initWithFrame:CGRectMake(0, 0, [QDSizeUtils is_width] - gap*2, 56)];
    [self.view addSubview:self.passwordComplexView];
    [self.passwordComplexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@([QDSizeUtils is_width] - gap*2));
        make.height.equalTo(@(56));
    }];
    
    // sign in
//    WS(weakSelf);
//    self.signupButton = [[QDButton alloc] initWithFrame:CGRectZero title:NSLocalizedString(@"Login_Login", nil) clickBlock:^{
//        [weakSelf signupAction];
//    }];
//    [self.view addSubview:self.signupButton];
//    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@(-([QDSizeUtils is_tabBarHeight] + 100)));
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(@([QDSizeUtils is_width] - gap*2));
//        make.height.equalTo(@(50));
//    }];
//    self.signupButton.isButtonEnabled = NO;
    
    self.signupButton = [UIButton new];
    [self.signupButton setTitle:NSLocalizedString(@"Login_Link", nil) forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"home_premium"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    [self.signupButton setBackgroundImage:image forState:UIControlStateNormal];
//    [self.signInButton setBackgroundColor:RGB_HEX(0x27A3EF)];
    [self.view addSubview:self.signupButton];
    [self.signupButton addTarget:self action:@selector(signupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-([QDSizeUtils is_tabBarHeight] + 100)));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(68);
        make.height.equalTo(@(50));
    }];
    [self setUnEnableLoginButton];
    
    // signin
    UIButton* signinButton = [UIButton new];
    [self.view addSubview:signinButton];
    [signinButton addTarget:self action:@selector(signinAction) forControlEvents:UIControlEventTouchUpInside];
    [signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signupButton.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(100));
        make.height.equalTo(@(44));
    }];
    
    UILabel* signinLabel = [UILabel new];
    signinLabel.font          = kSFUITextFont(16);
    signinLabel.textColor     = RGB_HEX(0x27A3EF);
    signinLabel.text = NSLocalizedString(@"Register_SignIn", nil);
    [signinButton addSubview:signinLabel];
    [signinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(signinButton);
    }];
    
    [self.view layoutIfNeeded];
    self.sendCodeButton.layer.mask = [self getRectCorner:self.sendCodeButton corners:UIRectCornerTopRight | UIRectCornerBottomRight radii:CGSizeMake(25, 25)];
}

- (void) refreshPasswordView {
    NSString* eyeImageName = self.passwordTextField.secureTextEntry ?  @"login_eye_close" : @"login_eye_open";
    self.eyeImageView.image = [UIImage imageNamed:eyeImageName];
}

// 登录预处理操作
- (void) doPreprogressAction {
    NSString* account = self.accoutTextField.text;
    NSString* password = self.passwordTextField.text;
    NSString* code = self.codeTextField.text;
    BOOL isEnabled = account&&![account isEqual:@""]&&password&&![password isEqual:@""]&&code&&![code isEqual:@""];
    if (isEnabled) {
        [self setEnableLoginButton];
    }
}

- (void)setEnableLoginButton {
    self.signupButton.alpha = 1;
    self.signupButton.userInteractionEnabled = YES;
}

- (void)setUnEnableLoginButton {
    self.signupButton.alpha = 0.5;
    self.signupButton.userInteractionEnabled = NO;
}

// 注册操作
- (void) doSignupAction {
    
    // 去掉焦点
    [self.accoutTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    // 检查操作
    NSString* account = [self.accoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* code = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 邮箱是否为空
    if (!account || [account isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Empty", nil)];
        return;
    }
    
    // 密码是否为空
    if (!password || [password isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Password_Empty", nil)];
        return;
    }
    
    // 密码少于6位
    if (password.length < 6) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Password_Tip", nil)];
        return;
    }
    
    // 邮箱是否合法
    if (![UIUtils isValidateEmail:account]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Invaid", nil)];
        return;
    }
    
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
    // 验证code
    [QDModelManager requestVerifyEmailCode:code type:1 completed:^(NSDictionary * _Nonnull dictionary) {
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel&&resultModel.code == kHttpStatusCode200) {
            [QDModelManager requestUpdatePassword:password type:1 completed:^(NSDictionary * _Nonnull dictionary) {
                
                QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
                
                if (resultModel&&resultModel.code == kHttpStatusCode200) {
                    // 邮箱密码登录
                    [QDModelManager requestLoginByEmail:account password:password completed:^(NSDictionary * _Nonnull dictionary) {
                        [SVProgressHUD dismiss];
                        QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
                        if (resultModel&&resultModel.code == kHttpStatusCode200) {
                            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Register_success", nil)];
                            QDConfigManager.shared.activeModel = resultModel.data;
                            QDConfigManager.shared.email    = account;
                            QDConfigManager.shared.password = password;
//                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLoginSuccess object:nil];
                            [self closeAction];
                            [self doRewardAction];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoHomeView object:nil];
                        } else {
                            [SVProgressHUD showErrorWithStatus:resultModel.message];
                        }
                    }];
                } else {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:resultModel.message];
                }
            }];
        } else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:resultModel.message];
        }
    }];
    
//    [QDModelManager requestLogout:^(NSDictionary * _Nonnull dictionary) {
//        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
//        if (resultModel.code == kHttpStatusCode200) {
//            
//        } else {
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:resultModel.message];
//        }
//    }];
}

- (void) doRewardAction {
    if (QDActivityManager.shared.activityResultModel.isBindEmail) return;
    [QDActivityManager.shared bindEmailComplete];
    
    if (QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1) return;
    
    [QDModelManager requestUserAddTimeNew:4 time:12*60*60 completed:^(NSDictionary * _Nonnull dictionary) {
        QDBaseResultModel* result1 = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (result1.code == kHttpStatusCode200) {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Toast_Register_Reward", nil)];
            
            // 刷新用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:result1.message];
        }
    }];
}


# pragma mark - actions
- (void) sendCodeAction {
    NSString* account = [self.accoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
    [QDModelManager requestEmailCode:account type:1 completed:^(NSDictionary * _Nonnull dictionary) {
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

- (void) outsideAction {
    [self.accoutTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void) viewPasswordAction {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    [self refreshPasswordView];
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

- (void) signinAction {
    QDLoginViewController* vc = [QDLoginViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) signupAction {
    [self doSignupAction];
}

- (void)accountTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

- (void)passwordTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
    self.passwordComplexView.password = textField.text;
}

- (void)codeTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

#pragma mark - delegete
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self doPreprogressAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.accoutTextField]) {
        [self.codeTextField becomeFirstResponder];
    } else if ([textField isEqual:self.codeTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self doSignupAction];
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
    self.codeLabel.text = text;
    self.codeLabel.textColor = color;
    [self.sendCodeButton setEnabled:isEnabled];
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

- (void)tap {
    [self outsideAction];
}

@end
