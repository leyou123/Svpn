//
//  QDNativeAdViewController.m
//  International
//
//  Created by hzg on 2021/7/13.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDNativeAdViewController.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"
#import "QDLineButtonView.h"
#import "QDTimeView2.h"
#import "QDConnectedRateView.h"
#import "GADTMediumTemplateView.h"
#import "RefreshViewController.h"
#import "RefreshViewController2.h"
#import "QDConnectSuccessView.h"
#import "UIImage+Utils.h"
#import "QDFeedbackViewController.h"
#import "QDShareNofifyViewController.h"
#import "QDTimerManager.h"

@interface QDNativeAdViewController ()

@property (nonatomic,strong)QDLineButtonView    *lineButton;
@property (nonatomic,strong)QDTimeView2   *timeView;
@property (nonatomic,assign)CGFloat contentHeight;

@end

@implementation QDNativeAdViewController
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self setUpNavBar];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    QDAdManager.shared.forbidAd = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setData];
    QDAdManager.shared.forbidAd = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLineChange object:nil];
    [QDAdManager.shared reloadNativeAd];
}

#pragma mark -- data
- (void) setData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserActive) name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyLineChange) name:kNotificationLineChange object:nil];
}

//- (void)setUpNavBar {
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [button setImage:[UIImage imageNamed:@"line_nav_back"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.view.backgroundColor = [UIColor whiteColor];
//}

- (void)dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setup {
    UIImageView * imageBgIv = [[UIImageView alloc] init];
    imageBgIv.image = [UIImage imageNamed:@"user_info_bg"];
    [self.view addSubview:imageBgIv];
    [imageBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setupHeaderView];
//    [self setupTime];
//    [self setupRateView];
    [self setupLine];
    [self setupAdView];
    [self setupTitle];
}

- (void)setupHeaderView {
    QDConnectSuccessView * successView = [[QDConnectSuccessView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:successView];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kAppNavigationBarHeight+[QDSizeUtils navigationHeight]);
        make.height.mas_equalTo(192);
    }];
    self.contentHeight = 192+kAppNavigationBarHeight+[QDSizeUtils navigationHeight];
    successView.feedbackCallback = ^{
        QDFeedbackViewController * feedbackVC = [[QDFeedbackViewController alloc] init];
        feedbackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedbackVC animated:YES];
    };
    successView.shareCallback = ^{
//        QDShareNofifyViewController* shareVC = [QDShareNofifyViewController new];
//        shareVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self.navigationController presentViewController:shareVC animated:YES completion:nil];
        [UIUtils shareApp:self view:self.view];
    };
    [QDTimerManager shared].connectedCallBack = ^(NSInteger count) {
        [successView updateTime:count];
    };
}

- (void) setupRateView {
    QDConnectedRateView* rateView = [QDConnectedRateView new];
    [self.view addSubview:rateView];
    CGFloat height = 140;
    [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentHeight);
        make.centerX.width.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    self.contentHeight += height;
}

- (void) setupTime {
    self.timeView = [[QDTimeView2 alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.timeView];
    
    CGFloat height = 40;
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.width.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self updateTimeView];
    
    self.contentHeight = height;
}

- (void) setupLine {
    
    WS(weakSelf);
    self.lineButton = [[QDLineButtonView alloc] initWithFrame:CGRectZero clickBlock:^{
        [QDTrackManager track_button:QDTrackButtonType_7];
        if (QDConfigManager.shared.activeModel.member_type == 1) {
            [QDTrackManager track_button:QDTrackButtonType_7];
            RefreshViewController2* vc = [RefreshViewController2 new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [QDTrackManager track_button:QDTrackButtonType_7];
            RefreshViewController* vc = [RefreshViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    CGFloat height = 70;
    self.lineButton.nodeColor = RGB_HEX(0x333333);
    self.lineButton.descColor = RGB_HEX(0xcccccc);
    self.lineButton.imageName = @"line_connected_bg";
    [self.view addSubview:self.lineButton];
    [self.lineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentHeight);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(height);
    }];
    [self.lineButton updateNode:QDConfigManager.shared.node];
    
    self.contentHeight += height;
}

- (void) setupTitle {
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"HomeTitleName", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
//    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = kSFUIDisplayFont(28);
    titleLabel.textColor = RGB_HEX(0x000000);
    [UIUtils showAppTitle:titleLabel];
    self.navigationItem.titleView = titleLabel;
}

- (void) setupAdView {
    
    CGFloat bottom = [QDSizeUtils isIphoneX] ? 20 + 34 : 20;
    CGFloat gap = 10;
    CGFloat height = self.view.frame.size.height - self.contentHeight - ([QDSizeUtils navigationHeight]+44) - bottom - gap;
    GADTMediumTemplateView *templateView = [[GADTMediumTemplateView alloc] init];
    [self.view addSubview:templateView];
    [templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentHeight + 40);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(height);
    }];
    
    NSString *myBlueColor = @"#5C84F0";
    NSDictionary *styles = @{
        GADTNativeTemplateStyleKeyCallToActionFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyCallToActionFontColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCallToActionBackgroundColor :
            [GADTTemplateView colorFromHexString:myBlueColor],
        GADTNativeTemplateStyleKeySecondaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeySecondaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeySecondaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyPrimaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyPrimaryFontColor : UIColor.blackColor,
        GADTNativeTemplateStyleKeyPrimaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyTertiaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyTertiaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeyTertiaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyMainBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCornerRadius : [NSNumber numberWithFloat:7.0],
    };

    templateView.styles = styles;

    // STEP 6: Set the ad for your template to render.
//    templateView.nativeAd = nativeAd;

    // STEP 7 (Optional): If you'd like your template view to span the width of your
    // superview call this method.
//    [templateView addHorizontalConstraintsToSuperviewWidth];
//    [templateView addVerticalCenterConstraintToSuperview];
    if ([QDVersionManager.shared.versionConfig[@"show_base_link_ad"] intValue] == 1) {
        [QDAdManager.shared showNativeAd:templateView];
    }
}

# pragma mark - notify
// 更新用户剩余时间
-(void)notifyUserActive {
    
    if (!QDConfigManager.shared.activeModel) return;
    
//    // 会员
//    if (QDConfigManager.shared.activeModel.member_type == 1) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    
    if (QDVPNManager.shared.status != NEVPNStatusConnected) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // title
    [self setupTitle];
    
    // time
    [self updateTimeView];
}

// 更新时间视图
- (void) updateTimeView {
    BOOL isHidden = (QDConfigManager.shared.activeModel == nil || QDConfigManager.shared.activeModel.member_type == 1);
    [self.timeView setHidden:isHidden];
    [self.timeView updateTime:QDConfigManager.shared.remainMins];
}

// 更新线路
-(void)notifyLineChange {
    [self.lineButton updateNode:QDConfigManager.shared.node];
}

@end
