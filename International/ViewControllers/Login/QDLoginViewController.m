//
//  QDLoginViewController.m
//  International
//
//  Created by hzg on 2021/9/2.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLoginViewController.h"
#import "QDSizeUtils.h"
#import "QDForgetPasswordViewController.h"
#import "QDDeviceActiveResultModel.h"
#import "QDButton.h"
#import "QDRegisterViewController.h"
#import "UIUtils.h"
#import "QDForgetFillEmailViewController.h"

@interface QDLoginViewController () <UITextFieldDelegate, UITextViewDelegate>

//@property(nonatomic, strong) QDButton* signInButton;
@property (nonatomic, strong) UIButton * signInButton;
@property(nonatomic, strong) UITextField* accoutTextField;
@property(nonatomic, strong) UITextField* passwordTextField;
@property(nonatomic, strong) UIImageView* eyeImageView;

@end

@implementation QDLoginViewController

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
    // view
    UIButton* rootView = [UIButton new];
    rootView.backgroundColor = [UIColor clearColor];
    [rootView addTarget:self action:@selector(outsideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // close
    UIButton* closeButton = [UIButton new];
    [rootView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"feature_close_btn"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(rootView).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    // title
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"Login_Title", nil);
    label.textColor     = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"SFUIText-Medium" size:28];
    label.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
//        make.top.equalTo(closeButton.mas_bottom).offset(20);
        make.centerY.equalTo(closeButton);
    }];
//    [label sizeToFit];
    
    // E-mail
    CGFloat gap = 15;
    CGFloat height = 48;
    UIImageView * emailView = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"login_tf_bg"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    emailView.image = image;
    emailView.userInteractionEnabled = YES;
    [rootView addSubview:emailView];
    [emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(gap));
        make.right.equalTo(@(-gap));
        make.height.equalTo(@(height));
        make.top.equalTo(label.mas_bottom).offset(70);
    }];
    self.accoutTextField = [UITextField new];
    self.accoutTextField.returnKeyType = UIReturnKeyNext;
    self.accoutTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.accoutTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accoutTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accoutTextField.placeholder = NSLocalizedString(@"Email", nil);
    self.accoutTextField.delegate = self;
    [self.accoutTextField addTarget:self action:@selector(accountTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.accoutTextField.enablesReturnKeyAutomatically = YES;
    [emailView addSubview:self.accoutTextField];
    [self.accoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emailView).offset(15);
        make.right.equalTo(emailView).offset(-15);
        make.height.equalTo(emailView);
        make.centerX.equalTo(emailView);
    }];
    
    // Password
//    UIView* passwordView = [UIView new];
//    passwordView.layer.cornerRadius  = 24;
//    passwordView.layer.masksToBounds = YES;
//    passwordView.backgroundColor = RGB_HEX(0xFFFFFF);
    UIImageView * passwordView = [[UIImageView alloc] init];
    UIImage * image1 = [UIImage imageNamed:@"login_tf_bg"];
    image1 = [image1 stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    passwordView.image = image1;
    passwordView.userInteractionEnabled = YES;
    [rootView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(gap));
        make.right.equalTo(@(-gap));
        make.height.equalTo(@(height));
        make.top.equalTo(emailView.mas_bottom).offset(20);
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
        make.left.equalTo(passwordView).offset(15);
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
    
    // forgot password
    UIButton* forgotButton = [UIButton new];
    [rootView addSubview:forgotButton];
    [forgotButton addTarget:self action:@selector(forgotAction) forControlEvents:UIControlEventTouchUpInside];
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).offset(12);
        make.right.equalTo(rootView).offset(-gap);
        make.width.equalTo(@(110));
        make.height.equalTo(@(44));
    }];
    UILabel* forgotLabel = [UILabel new];
    forgotLabel.text          = NSLocalizedString(@"Login_Forget_Password", nil);
    forgotLabel.font          = kSFUITextFont(16);
    forgotLabel.textColor     = RGB_HEX(0x999999);
    [forgotButton addSubview:forgotLabel];
    [forgotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(forgotButton);
    }];
    [forgotLabel sizeToFit];
    
    UIView* line = [UIView new];
    line.backgroundColor     = RGB_HEX(0xbfbfbf);
    [forgotButton addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(forgotLabel.mj_w));
        make.bottom.equalTo(forgotLabel.mas_bottom);
        make.height.equalTo(@(1));
        make.right.equalTo(forgotButton);
    }];
    
    self.signInButton = [UIButton new];
    [self.signInButton setTitle:NSLocalizedString(@"Login_Login", nil) forState:UIControlStateNormal];
    UIImage * image2 = [UIImage imageNamed:@"home_premium"];
    image2 = [image2 stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    [self.signInButton setBackgroundImage:image2 forState:UIControlStateNormal];
    [rootView addSubview:self.signInButton];
    [self.signInButton addTarget:self action:@selector(doSignInAction) forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-([QDSizeUtils is_tabBarHeight] + 100)));
        make.centerX.equalTo(rootView);
        make.left.equalTo(rootView).offset(68);
        make.height.equalTo(@(50));
    }];
    [self setUnEnableLoginButton];
    
    UITextView * linkTextView = [[UITextView alloc] init];
    linkTextView.delegate = self;
    linkTextView.editable = NO;
//    linkTextView.textColor = RGB_HEX(0x27A3EF);
//    linkTextView.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:linkTextView];
    [linkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(rootView);
        make.top.equalTo(self.signInButton.mas_bottom).offset(16);
        make.height.mas_equalTo(44);
    }];
    
    NSString *str1 = NSLocalizedString(@"Login_bind_mailbox_text", nil);
    NSString *str2 = NSLocalizedString(@"Login_Register_Now", nil);
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:kSFUITextFont(16),NSForegroundColorAttributeName:RGB_HEX(0x999999)}];
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:kSFUITextFont(16),NSLinkAttributeName:@"link"}];
    [attrStr1 appendAttributedString:attrStr2];
    linkTextView.linkTextAttributes = @{NSFontAttributeName:kSFUITextFont(16),NSForegroundColorAttributeName:RGB_HEX(0x27A3EF)};
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    [attrStr1 addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, str.length)];
    
    linkTextView.attributedText = attrStr1;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL absoluteString] isEqualToString:@"link"]) {
        [self registerAction];
        return NO;
    }
    return YES;
}

- (void) refreshPasswordView {
    NSString* eyeImageName = self.passwordTextField.secureTextEntry ?  @"login_eye_close" : @"login_eye_open";
    self.eyeImageView.image = [UIImage imageNamed:eyeImageName];
}

// 登录预处理操作
- (void) doPreprogressAction {
    NSString* account = self.accoutTextField.text;
    NSString* password = self.passwordTextField.text;
    BOOL isEnabled = account&&![account isEqual:@""]&&password&&![password isEqual:@""];
//    self.signInButton.isButtonEnabled = isEnabled;
    if (isEnabled) {
        [self setEnableLoginButton];
    }
}

- (void)setEnableLoginButton {
    self.signInButton.alpha = 1;
    self.signInButton.userInteractionEnabled = YES;
}

- (void)setUnEnableLoginButton {
    self.signInButton.alpha = 0.5;
    self.signInButton.userInteractionEnabled = NO;
}

// 登录操作
- (void) doSignInAction {
    
    // 去掉焦点
    [self.accoutTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    // 检查操作
    NSString* account = [self.accoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
    
    // 邮箱是否合法
    if (![UIUtils isValidateEmail:account]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Email_Invaid", nil)];
        return;
    }
    
    [SVProgressHUD show];
    [QDModelManager requestLoginByEmailAndUnbind:QDConfigManager.shared.activeModel.uid email:account password:password completed:^(NSDictionary * _Nonnull dictionary) {
        QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
        [SVProgressHUD dismiss];
        if (resultModel.code == kHttpStatusCode200) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login_success", nil)];
            QDConfigManager.shared.activeModel = resultModel.data;
            QDConfigManager.shared.email    = account;
            QDConfigManager.shared.password = password;
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLoginSuccess object:nil];
            [self closeAction];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoHomeView object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:resultModel.message];
        }
    }];
}

# pragma mark - actions
- (void) outsideAction {
    [self.accoutTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void) viewPasswordAction {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    [self refreshPasswordView];
}

- (void) closeAction {
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

- (void) forgotAction {
    QDForgetPasswordViewController* vc = [QDForgetPasswordViewController new];
//    QDForgetFillEmailViewController * vc = [[QDForgetFillEmailViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) registerAction {
    QDRegisterViewController* vc = [QDRegisterViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) signinAction {
    [self doSignInAction];
}

- (void)accountTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

- (void)passwordTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
}

#pragma mark - delegete
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self doPreprogressAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.accoutTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self doSignInAction];
    }
    return YES;
}

@end
