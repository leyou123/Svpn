//
//  CSLYLoginSelectViewController.m
//  StormVPN
//
//  Created by hzg on 2021/12/15.
//

#import "QDLoginSelectViewController.h"
#import "QDLoginViewController.h"

@interface QDLoginSelectViewController ()

@end

@implementation QDLoginSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void) setup {
    
    // back
    self.view.backgroundColor = [UIColor whiteColor];
    
    // parent
    CGFloat width = 306;
    CGFloat height = 433;
    UIView* parentView = [UIView new];
    [self.view addSubview:parentView];
    [parentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    
    // icon
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ICON"]];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [parentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentView);
        make.width.height.equalTo(@(140));
        make.centerX.equalTo(parentView);
    }];
    
    // email button
    UIButton* emailButton = [UIButton new];
    emailButton.layer.cornerRadius = 6;
    emailButton.layer.masksToBounds = YES;
    [parentView addSubview:emailButton];
    [emailButton addTarget:self action:@selector(emailLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(132-40);
        make.centerX.equalTo(parentView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(51));
    }];
    // back label
    UIView* emailBackView = [UIView new];
    emailBackView.userInteractionEnabled = NO;
    emailBackView.backgroundColor = RGB_HEX(0x3e9efa);
    [emailButton addSubview:emailBackView];
    [emailBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(emailButton);
    }];
    
    UILabel* label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = NSLocalizedString(@"Login_By_Email", nil);
    [emailButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(emailButton);
    }];
    
    // no register button
    UIButton* noregisterButton = [UIButton new];
    noregisterButton.backgroundColor = RGB_HEX(0xb2b2b2);
    noregisterButton.layer.cornerRadius = 6;
    noregisterButton.layer.masksToBounds = YES;
    [parentView addSubview:noregisterButton];
    [noregisterButton addTarget:self action:@selector(noregisterLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [noregisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailButton.mas_bottom).offset(28);
        make.centerX.equalTo(parentView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(51));
    }];
    UIView* noregisterBackView = [UIView new];
    noregisterBackView.userInteractionEnabled = NO;
    noregisterBackView.backgroundColor = [UIColor whiteColor];
    [noregisterButton addSubview:noregisterBackView];
    [noregisterBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(noregisterButton);
        make.width.equalTo(@(width-0.5));
        make.width.equalTo(@(51-0.5));
    }];
    
    UILabel* noregisterLabel = [UILabel new];
    noregisterLabel.alpha = 0.5;
    noregisterLabel.font = [UIFont boldSystemFontOfSize:16];
    noregisterLabel.textColor = [UIColor blackColor];
    noregisterLabel.text = NSLocalizedString(@"Login_By_Quick", nil);
    [noregisterButton addSubview:noregisterLabel];
    [noregisterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(noregisterButton);
    }];
}

#pragma mark - action methods
- (void) emailLoginAction {
    QDLoginViewController* vc = [QDLoginViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) noregisterLoginAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoHomeView object:nil];
}

#pragma mark - override methods
-(BOOL) shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
