//
//  QDResetPasswordViewController.m
//  International
//
//  Created by hzg on 2021/9/2.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDResetPasswordViewController.h"
#import "QDButton.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"
#import "QDBaseResultModel.h"
#import "QDPasswordView.h"

@interface QDResetPasswordViewController () <UITextFieldDelegate>

//@property(nonatomic, strong) QDButton* okButton;
@property(nonatomic, strong) UIButton* resignButton;
@property(nonatomic, strong) UITextField* passwordTextField;
@property(nonatomic, strong) UITextField* passwordTextField1;
@property(nonatomic, strong) UIImageView* eyeImageView;
@property(nonatomic, strong) UIImageView* eyeImageView1;
@property(nonatomic, strong) QDPasswordView* passwordComplexView;

@end


@implementation QDResetPasswordViewController

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
    [closeButton setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(self.view).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    
    // title
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"Password_New", nil);
    label.textColor     = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeButton);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Forgot_Email_title_tip", nil);
    titleLabel.numberOfLines = 0;
    titleLabel.font = kSFUIDisplayFont(22);
    titleLabel.textColor = RGB_HEX(0x333333);
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(titleLabel);
        make.height.mas_equalTo(14);
        make.top.equalTo(titleLabel.mas_bottom).offset(4);
    }];

    // new Password
    UIImageView * newPasswordView = [[UIImageView alloc] init];
    UIImage * passwordImage = [UIImage imageNamed:@"login_tf_bg"];
    passwordImage = [passwordImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    newPasswordView.image = passwordImage;
    newPasswordView.userInteractionEnabled = YES;
    [self.view addSubview:newPasswordView];
    [newPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(51));
        make.top.equalTo(descLabel.mas_bottom).offset(22);
    }];

    self.passwordTextField = [UITextField new];
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.placeholder = NSLocalizedString(@"Password_New", nil);
    self.passwordTextField.delegate = self;
    [self.passwordTextField addTarget:self action:@selector(passwordTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.passwordTextField.enablesReturnKeyAutomatically = YES;
    [newPasswordView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPasswordView).offset(12);
        make.right.equalTo(newPasswordView).offset(-68);
        make.centerX.height.equalTo(newPasswordView);
    }];

    // view password button
    UIButton* viewPasswordButton = [UIButton new];
    [viewPasswordButton addTarget:self action:@selector(viewPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [newPasswordView addSubview:viewPasswordButton];
    [viewPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(newPasswordView).offset(-12);
        make.centerY.equalTo(newPasswordView);
        make.width.height.equalTo(@(44));
    }];
    self.eyeImageView = [UIImageView new];
    [viewPasswordButton addSubview:self.eyeImageView];
    [self.eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewPasswordButton);
    }];
    [self refreshPasswordView];
    
    // confirm Password
    UIImageView * confirmPasswordView = [[UIImageView alloc] init];
//    confirmPasswordView.image = [UIImage imageNamed:@"login_tf_bg"];
    UIImage * confirmImage = [UIImage imageNamed:@"login_tf_bg"];
    confirmImage = [confirmImage stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    confirmPasswordView.image = confirmImage;
    confirmPasswordView.userInteractionEnabled = YES;
    [self.view addSubview:confirmPasswordView];
    [confirmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(51));
        make.top.equalTo(newPasswordView.mas_bottom).offset(20);
    }];

    self.passwordTextField1 = [UITextField new];
    self.passwordTextField1.returnKeyType = UIReturnKeyGo;
    self.passwordTextField1.secureTextEntry = YES;
    self.passwordTextField1.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField1.placeholder = NSLocalizedString(@"Confirm_Password", nil);
    self.passwordTextField1.delegate = self;
    [self.passwordTextField1 addTarget:self action:@selector(passwordTextChangedAction:) forControlEvents:(UIControlEventEditingChanged)];
    self.passwordTextField1.enablesReturnKeyAutomatically = YES;
    [confirmPasswordView addSubview:self.passwordTextField1];
    [self.passwordTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmPasswordView).offset(15);
        make.right.equalTo(confirmPasswordView).offset(-65);
        make.top.height.equalTo(confirmPasswordView);
    }];

    // view password button
    UIButton* viewPasswordButton1 = [UIButton new];
    [viewPasswordButton1 addTarget:self action:@selector(viewPasswordAction1) forControlEvents:UIControlEventTouchUpInside];
    [confirmPasswordView addSubview:viewPasswordButton1];
    [viewPasswordButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(confirmPasswordView).offset(-12);
        make.centerY.equalTo(confirmPasswordView);
        make.width.height.equalTo(@(44));
    }];
    self.eyeImageView1 = [UIImageView new];
    [viewPasswordButton1 addSubview:self.eyeImageView1];
    [self.eyeImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewPasswordButton1);
    }];
    [self refreshPasswordView1];

    self.resignButton = [UIButton new];
    [self.resignButton setTitle:NSLocalizedString(@"Password_Reset_Ok", nil) forState:UIControlStateNormal];
    UIImage * image = [UIImage imageNamed:@"home_premium"];
    image = [image stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    [self.resignButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.resignButton];
    [self.resignButton addTarget:self action:@selector(dookAction) forControlEvents:UIControlEventTouchUpInside];
    [self.resignButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPasswordView.mas_bottom).offset(29);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@240);
        make.height.equalTo(@(50));
    }];
    [self setUnEableButton];
}

- (void) refreshPasswordView {
    NSString* eyeImageName = self.passwordTextField.secureTextEntry ?  @"login_eye_close" : @"login_eye_open";
    self.eyeImageView.image = [UIImage imageNamed:eyeImageName];
}

- (void) refreshPasswordView1 {
    NSString* eyeImageName = self.passwordTextField1.secureTextEntry ?  @"login_eye_close" : @"login_eye_open";
    self.eyeImageView1.image = [UIImage imageNamed:eyeImageName];
}

// 登录预处理操作
- (void) doPreprogressAction {
    NSString* password = self.passwordTextField.text;
    BOOL isEnabled = password&&![password isEqual:@""];
//    self.okButton.isButtonEnabled = isEnabled;
    if (isEnabled) {
        [self setEableButton];
    }
}

- (void)setUnEableButton {
    self.resignButton.alpha = 0.5;
    self.resignButton.userInteractionEnabled = NO;
}

- (void)setEableButton {
    self.resignButton.alpha = 1;
    self.resignButton.userInteractionEnabled = YES;
}

// 注册操作
- (void) dookAction {
    
    // 去掉焦点
    [self.passwordTextField resignFirstResponder];
    
    // 检查操作
    NSString* password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password1 = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    // 密码是否为空
    if (!password || [password isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Password_Empty", nil)];
        return;
    }
    
    // 两次密码需要一致
    if (![password isEqualToString:password1]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error_Password_not_match", nil)];
        return;
    }
    
    // 密码少于6位
    if (password.length < 6) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Password_Tip", nil)];
        return;
    }
    
    [SVProgressHUD show];
    [QDModelManager requestUpdatePassword:password type:1 completed:^(NSDictionary * _Nonnull dictionary) {
        [SVProgressHUD dismiss];
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel&&resultModel.code == kHttpStatusCode200) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Password_modify_success", nil)];
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
    [self.passwordTextField resignFirstResponder];
}

- (void) viewPasswordAction {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    [self refreshPasswordView];
}

- (void) viewPasswordAction1 {
    self.passwordTextField1.secureTextEntry = !self.passwordTextField1.secureTextEntry;
    [self refreshPasswordView1];
}

- (void) closeAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) okAction {
    [self dookAction];
}

- (void)passwordTextChangedAction:(UITextField *)textField {
    [self doPreprogressAction];
    self.passwordComplexView.password = textField.text;
}

#pragma mark - delegete
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self doPreprogressAction];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dookAction];
    return YES;
}

- (void)tap {
    [self outsideAction];
}

@end
