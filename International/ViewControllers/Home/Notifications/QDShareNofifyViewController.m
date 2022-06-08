//
//  CSLYShareNofifyViewController.m
//  StormVPN
//
//  Created by hzg on 2021/11/30.
//

#import "QDShareNofifyViewController.h"
#import "UIUtils.h"
#import "QDSizeUtils.h"

// 分享推送界面
@interface QDShareNofifyViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDShareNofifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupBanner];
}

- (void) setupBanner {
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

- (void) setup {
    
    // back
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSV];
    [self setupShareImg];
    
    self.scrollViewHeight = [QDSizeUtils is_tabBarHeight] + 44 + 270;
    [self setupRedeemCode];
    [self setupShareButton];
    
    UIButton* closeButton = [UIButton new];
    [self.scrollView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"feature_close_btn"] forState:UIControlStateNormal];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(self.scrollView).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void) setupSV {
    
    // root scrollview1
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

// 分享图
- (void) setupShareImg {
    // image
    UIImageView* image = [UIImageView new];
    image.image = [UIImage imageNamed:@"feature_share"];
    [self.scrollView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset([QDSizeUtils navigationHeight]+44);
        make.centerX.equalTo(self.scrollView);
    }];
}

// 分享码
- (void) setupRedeemCode {
    
    UIButton* redeemButton = [UIButton new];
    [redeemButton setImage:[UIImage imageNamed:@"line_back"] forState:UIControlStateNormal];
    [redeemButton addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:redeemButton];
    [redeemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(self.scrollViewHeight));
        make.width.equalTo(@(352));
        make.height.equalTo(@(57));
    }];
    
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
    codeLabel.font = [UIFont boldSystemFontOfSize:30];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(redeemButton);
    }];
    [codeLabel sizeToFit];
    
    self.scrollViewHeight += 57;
    
    // 间距
    self.scrollViewHeight += 10;
    
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
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(redeemButton);
        make.width.equalTo(@(220));
    }];
    [shareLabel sizeToFit];
    
    self.scrollViewHeight += 12;
}

- (void) setupShareButton {
    self.scrollViewHeight += 40;
    CGFloat buttonHeight = 51;
    CGFloat buttonWidth = 210;
    UIButton* shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.backgroundColor = RGB_HEX(0x3e9efa);
    shareButton.layer.cornerRadius = 6;
    [self.scrollView addSubview:shareButton];
    [shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
    }];
    UILabel* shareLabel = [UILabel new];
    [shareButton addSubview:shareLabel];
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.text = NSLocalizedString(@"Share_Slide", nil);
    shareLabel.numberOfLines = 0;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont boldSystemFontOfSize:18];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(shareButton);
        make.width.equalTo(@(buttonWidth));
    }];
}

- (void) shareAction:(UIButton*)pSender {
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
