//
//  CSLYShareViewController.m
//  StormVPN
//
//  Created by hzg on 2021/11/4.
//

#import "QDShareViewController.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"

@interface QDShareViewController ()

@property(nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupBanner];
}

- (void) setupBanner {
    if(!QDConfigManager.shared.activeModel || QDConfigManager.shared.activeModel.member_type != 1) {
        CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
        [QDAdManager.shared showBanner:self toBottom:toBottom];
    }
}

- (void) setup {
    
    // back
    self.view.backgroundColor = [UIColor whiteColor];
    
    // close button
    UIButton* cancelButton = [UIButton new];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:[UIImage imageNamed:@"feature_close_btn"] forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
        make.top.equalTo(@([QDSizeUtils navigationHeight]+44));
        make.left.equalTo(@(12));
    }];
    
    [self setupRedeemCode];
    [self setupShareButton];
}

// 分享码
- (void) setupRedeemCode {
    
    self.scrollViewHeight = [QDSizeUtils navigationHeight]+150;
    
    UIButton* redeemButton = [UIButton new];
    [redeemButton setImage:[UIImage imageNamed:@"share_bk"] forState:UIControlStateNormal];
    [redeemButton addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redeemButton];
    [redeemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(self.scrollViewHeight));
        make.width.equalTo(@(312));
        make.height.equalTo(@(200));
    }];
    
    
    UILabel* promationTitle = [UILabel new];
    [redeemButton addSubview:promationTitle];
    promationTitle.text = NSLocalizedString(@"Share_Your", nil);
    promationTitle.textColor = [UIColor whiteColor];
    promationTitle.numberOfLines = 0;
    promationTitle.textAlignment = NSTextAlignmentCenter;
    promationTitle.font = [UIFont boldSystemFontOfSize:21];
    [promationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redeemButton);
        make.top.equalTo(@(12));
        make.width.equalTo(@(300));
    }];
    [promationTitle sizeToFit];
    
    self.scrollViewHeight += promationTitle.mj_h + 50;
    
    NSString* code = @"";
    if (QDConfigManager.shared.activeModel) {
        code = QDConfigManager.shared.activeModel.code;
    }
    UILabel* codeLabel = [UILabel new];
    [redeemButton addSubview:codeLabel];
    codeLabel.text = code;
    codeLabel.textColor = RGB(246, 136, 43);
    codeLabel.numberOfLines = 0;
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont boldSystemFontOfSize:22];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redeemButton);
        make.centerY.equalTo(redeemButton).offset(-10);
        make.width.equalTo(@(220));
    }];
    [codeLabel sizeToFit];
    
    self.scrollViewHeight += 80;
    
    // 间距
    self.scrollViewHeight += 50;
    
    // 分享语句
    NSString* shareText = NSLocalizedString(@"Share_Redeem_Text1", nil);
    if (QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1) {
        shareText = NSLocalizedString(@"Share_Redeem_Text2", nil);
    }
    UILabel* shareLabel = [UILabel new];
    [redeemButton addSubview:shareLabel];
    shareLabel.text = shareText;
    shareLabel.textColor = [UIColor blackColor];
    shareLabel.numberOfLines = 0;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:12];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-20));
        make.centerX.equalTo(redeemButton);
        make.width.equalTo(@(220));
    }];
    [shareLabel sizeToFit];
}

- (void) setupShareButton {
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = (375 - 52)/2;
    UIButton* shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = RGB_HEX(0x3e9efa);
    shareButton.layer.cornerRadius = 6;
    [self.view addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.bottom.equalTo(self.view).offset(-150);
    }];
    UILabel* shareLabel = [UILabel new];
    [shareButton addSubview:shareLabel];
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.text = NSLocalizedString(@"Share_Slide", nil);
    shareLabel.numberOfLines = 0;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:18];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shareButton);
        make.width.equalTo(@(buttonWidth));
    }];
}

- (void) shareAction:(UIButton*)pSender {
    [QDTrackManager track_button:QDTrackButtonType_36];
    [UIUtils shareApp:self view:pSender];
}

- (void) copyAction {
    NSString* code = @"";
    if (QDConfigManager.shared.activeModel) {
        code = QDConfigManager.shared.activeModel.code;
    }
    [UIPasteboard generalPasteboard].string = code;
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Copy_Success", nil)];
}

- (void) cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
