//
//  ViewController.m
//  International
//
//  Created by a on 2019/11/19.
//  Copyright © 2019 com. All rights reserved.
//

#import "QDHomeViewController.h"
#import "QDSizeUtils.h"
#import "QDDateUtils.h"
#import "QDConnectButtonView.h"
#import "QDLineButtonView.h"
#import "QDDeviceActiveResultModel.h"
#import "QDNodesResultModel.h"
#import <AVFoundation/AVFoundation.h>
#import "Protocol/ProtocolView.h"
#import "QDRecommandAdView.h"
#import "QDGuideView.h"
#import "QDVersionConfigResultModel.h"
#import "QDRefreshNormalHeader.h"
#import "QDPayViewController2.h"
#import "QDTimeView.h"
#import "UIUtils.h"
#import "QDConfigInstallGuideView.h"
#import "QDErrorView.h"
#import "QDNativeAdViewController.h"
#import "QDVPNConnectCheck.h"
#import "QDConnectTipView.h"
#import "RefreshViewController.h"
#import "RefreshViewController2.h"
#import "QDNoticeView.h"
#import "QDSpashView.h"
//#import "QDBindTipView.h"
#import "QDRegisterViewController.h"
#import "QDShareViewController.h"
#import "QDQRCodeViewController.h"
#import "QDAnnualPayButtonView.h"
#import "QDFeedBackButton.h"
#import "QDPayViewController3.h"
#import <sys/utsname.h>
#import <StoreKit/StoreKit.h>
#import "UIViewController+MMDrawerController.h"
#import "QDTimeView3.h"
#import "QDClickButtonView.h"
#import "QDWatchAD.h"
#import "QDGetPremiumView.h"
#import "QDConnectStatusView.h"
#import "QDSubscriptionViewController.h"
#import "QDNoticeView2.h"
#import "QDFeedbackViewController.h"
#import "QDTimerManager.h"
#import "QDDeviceUtils.h"
#import "QDShareNofifyViewController.h"
#import "UIImage+GIF.h"
#import "MMDrawerController.h"
#import "FFSimplePingHelper.h"
#import "UnityOpenAds.h"
#import "NENPingManager.h"

static NSString *const kLastTime = @"kLastTime";
static NSString *const kHadRate = @"kHadRate";

@interface QDHomeViewController ()

@property (nonatomic,strong)UIImageView *semicircleImage;
@property (nonatomic,strong)UIImageView *whiteBottomImage;
@property (nonatomic,strong)UIImageView *animationImage;
@property (nonatomic,strong)QDConnectButtonView *connectButton;
@property (nonatomic,strong)QDLineButtonView    *lineButton;
@property (nonatomic,strong)QDRecommandAdView   *recommandAdView;
@property (nonatomic,strong)QDTimeView   *timeView;
@property (nonatomic,strong)QDTimeView3   *timeView3;
@property (nonatomic,strong)QDAnnualPayButtonView *annualPayButtonView;
@property (nonatomic,strong)QDFeedBackButton *feedBackButton;
@property (nonatomic,strong)QDGetPremiumView *premiumView;
//@property (nonatomic,strong)QDConnectStatusView *connectStatusView;
@property (nonatomic,strong)QDNoticeView2 *noticeView2;
@property (nonatomic,strong)QDClickButtonView * watchAdView;
// 定时器
@property (nonatomic,strong)NSTimer* timer;

// 是否处于loading状态
@property (nonatomic,assign)BOOL isLoading;

// 恢复订单补丁，每次登录只恢复一次，同步之前的老用户
@property (nonatomic,assign)BOOL isRestored;

// sv
@property(nonatomic, strong) UIScrollView* scrollView;
@property(nonatomic, strong) UIView* wrapView;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) QDConfigInstallGuideView* configInstallGuideView;
@property(nonatomic, strong) QDErrorView* configErrorView;
@property(nonatomic, strong) QDConnectTipView* connectTipView;
@property(nonatomic, strong) QDNoticeView* noticeView;
//@property(nonatomic, strong) QDBindTipView* bindView;
@property(nonatomic, strong) UIButton* scanButton;
@property(nonatomic, strong) UIButton* menuButton;

@property(nonatomic, strong) UILabel * remainLabel;

@property(nonatomic, strong) NSString* typeString;

@property (nonatomic, assign) BOOL hadShowAds;

@property (nonatomic, assign) BOOL canShowAds;

@property (nonatomic,strong) FFSimplePingHelper *simplePingHelper;

@property (nonatomic,strong) NENPingManager *pingHelper;

@end

@implementation QDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self setData];
    
    // 非引导模式，显示加载动画
    if (QDConfigManager.shared.isAccepted) {
        self.isLoading = YES;
//        [SVProgressHUD show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 界面推送
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    if(QDVPNManager.shared.isInstallerVPNConfig&&!isVIP&& QDVersionManager.shared.versionConfig) {
        BOOL show_push_view = [QDVersionManager.shared.versionConfig[@"show_push_view"] intValue] == 1;
        if (show_push_view) {
            [QDPushViewManager.shared popRandomView];
        }
    }
    
    // 若显示交叉推广，就不显示banner
    [self updateBannerView];
    
    
    UIViewController * currentVc = [UIUtils getCurrentVC];
    if ([currentVc isKindOfClass:[MMDrawerController class]]) {
        MMDrawerController * vc = (MMDrawerController *)currentVc;
        if (QDConfigManager.shared.isNoneFirstEnterApp && vc.openSide != MMDrawerSideLeft && self.canShowAds) {
            [self showAds];
            self.canShowAds = NO;
        }
    }
}

#pragma mark -- data
- (void) setData {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserActive) name:kNotificationUserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserActive) name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserInfo) name:kNotificationUserChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:kNotificationAppBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyLineChange) name:kNotificationLineChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyLineRefresh) name:kNotificationLineRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNetworkChanged) name:kNotificationNetworkChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConfigInstallStart) name:kNotificationConfigInstallStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConfigInstallEnd) name:kNotificationConfigInstallEnd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConfigInstallFail) name:kNotificationConfigInstallFail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyConfigUpdate) name:kNotificationConfigUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRecommandApp) name:kNotificationRecommandApp object:nil];
    
    // 加载数据
    [self.scrollView.mj_header beginRefreshing];
   // [self requestUserInfo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLineChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLineRefresh object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNetworkChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConfigInstallStart object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConfigInstallEnd object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConfigInstallFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationConfigUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRecommandApp object:nil];
}

- (void) responseRequestUserInfo:(BOOL)isRegister result:(NSDictionary*) dictionary {
    if (self.scrollView.mj_header.isRefreshing) {
        [self.scrollView.mj_header endRefreshing];
    }
    
    QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
    
    if (resultModel.code == kHttpStatusCode200) {
        
        QDConfigManager.shared.activeModel = resultModel.data;
        if (!self.hadShowAds) {
            [self showAds];// 展示开屏广告
        }
        if (isRegister) {
            QDConfigManager.shared.local_UID = QDConfigManager.shared.activeModel.uid;
        }
        
        // 恢复订单
        [self requestRestoreOrders];
        
        // 刷新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserActive object:nil];
        
        // 请求节点信息
        if (!QDConfigManager.shared.nodes || QDConfigManager.shared.nodes.count == 0) {
            [self requestNodes];
        } else {
            // 刷新节点列表
            [QDConfigManager.shared preprogressNodes];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLineRefresh object:nil];
        }
        
    } else if (resultModel.code == kHttpStatusCode404) {
        QDConfigManager.shared.email    = nil;
        QDConfigManager.shared.password = nil;
        
        // 跳转至用户选择界面
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserGoLoginSelectView object:nil];
    } else {
        if (self.isLoading) {
            // 请求失败
            [QDDialogManager showDialog:nil message:resultModel.message ok:NSLocalizedString(@"Dialog_Retry", nil) cancel:nil okBlock:^{
                [self requestUserInfo];
            } cancelBlock:^{
                
            }];
        }
    }
    
    // 隐藏加载动画
    if (self.isLoading) {
        self.isLoading = NO;
//        [SVProgressHUD dismiss];
    }
}

// 请求用户或激活用户信息
- (void) requestUserInfo {
    if (QDConfigManager.shared.email
        &&![QDConfigManager.shared.email isEqual:@""]
        && QDConfigManager.shared.password
        &&![QDConfigManager.shared.password isEqual:@""]) {
        [QDModelManager requestLoginByEmail:QDConfigManager.shared.email password:QDConfigManager.shared.password completed:^(NSDictionary * _Nonnull dictionary) {
            [self responseRequestUserInfo:NO result:dictionary];
        }];
    } else {
        [QDModelManager requestRegister:^(NSDictionary * _Nonnull dictionary) {
            QDDeviceActiveResultModel* resultModel = [QDDeviceActiveResultModel mj_objectWithKeyValues:dictionary];
            if (resultModel.code == kHttpStatusCode200 && resultModel.data) {
                QDConfigManager.shared.UID = resultModel.data.uid;
                [QDModelManager requestLoginByUid:^(NSDictionary * _Nonnull dictionary) {
                    [self responseRequestUserInfo:YES result:dictionary];
                }];
            } else {
                [self responseRequestUserInfo:YES result:dictionary];
            }
//            [self responseRequestUserInfo:YES result:dictionary]; 
        }];
    }
    if (QDVPNManager.shared.status == NEVPNStatusConnected) {
        [self.connectButton updateUIStatus:status_button_connected];
    }
}

// 唤醒app后设置按钮状态
- (void)appBecomeActive {
    if (QDVPNManager.shared.status == NEVPNStatusDisconnected) {
        [self.connectButton updateUIStatus:status_button_disconnected];
    }
}

// 请求恢复订单逻辑
- (void) requestRestoreOrders {
    if (self.isRestored) return;
    self.isRestored = YES;
    [QDReceiptManager.shared restore:^(BOOL success) {
        
    }];
}

- (void) requestNodes {
    [QDModelManager requestNodes:^(NSDictionary * _Nonnull dictionary) {
        QDNodesResultModel* resultModel = [QDNodesResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel.code == kHttpStatusCode200) {
            // 默认第一条线路
            QDConfigManager.shared.nodes = resultModel.data;
            [QDConfigManager.shared preprogressNodes];
            [QDConfigManager.shared setDefaultNode];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLineRefresh object:nil];
        } else {
            NSLog(@"requestNodes request failed %@", resultModel.message);
        }
    }];
}

#pragma mark -- ui
- (void) setup {
    [self setupBack];
    [self setupScrollView];
    [self setupErrorView];
//    [self setupBindView];
    if (!self.isUserSelectEnter) {
        [self setupSpashView];
    }
}

//- (void) setupBindView {
//    self.bindView = [[QDBindTipView alloc] initWithFrame:CGRectMake(0, 0, [QDSizeUtils is_width], 44)];
//    [self.wrapView addSubview:self.bindView];
//    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@([QDSizeUtils navigationHeight] + 44));
//        make.left.right.equalTo(self.wrapView);
//        make.height.equalTo(@(44));
//    }];
//    [self.bindView setHidden:YES];
//    [self.bindView addTarget:self action:@selector(onBindAction) forControlEvents:UIControlEventTouchUpInside];
//}

- (void) setupErrorView {
    self.configErrorView = [QDErrorView new];
    [self.view addSubview:self.configErrorView];
    [self.configErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 44));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    [self.configErrorView setHidden:YES];
}

- (void) setupScrollView {
    self.scrollView = [UIScrollView new];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    QDRefreshNormalHeader* header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestUserInfo];
    }];
    header.showBack = YES;
    self.scrollView.mj_header = header;
    [self.scrollView setContentSize:CGSizeMake([QDSizeUtils is_width], [QDSizeUtils is_height] - [QDSizeUtils navigationHeight] - 44)];
    
    self.wrapView = [UIView new];
    [self.scrollView addSubview:self.wrapView];
    [self.wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.scrollView);
//        make.width.equalTo(@([QDSizeUtils is_width]));
//        make.height.equalTo(@([QDSizeUtils is_height]));
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self setupTitle];
    [self setMiddleLabel];
    [self setupTimeView];
    [self setupLine];
//    [self setupAnnualPayView];
    [self setupRecommand];
    [self setupSemicircle];
    [self setupNotice];
    [self setupConnect];
    [self setWatchADView];
//    [self setConnectStatusView];
    [self setPremiumView];
    [self setNoticeView2];
}

// click to watch ad
- (void)setWatchADView {
    
    UIView * verLine = [[UIView alloc] initWithFrame:CGRectZero];
    verLine.backgroundColor = [UIColor whiteColor];
    [self.wrapView addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPAD) {
            make.top.equalTo(self.lineButton.mas_bottom).offset(40);
        }else {
            make.top.equalTo(self.lineButton.mas_bottom).offset(20*kScreenScale);
        }
        make.centerX.equalTo(self.wrapView);
        make.size.mas_equalTo(CGSizeMake(1, 40));
    }];

    QDClickButtonView * watchAdView = [[QDClickButtonView alloc] initWithFrame:CGRectZero image:@"home_add" text:@"" attributeString:@"" Action:^{
        [UIUtils shareApp:self view:self.watchAdView];
    }];
    watchAdView.watch = ^{
        self.canShowAds = NO;
    };
    _watchAdView = watchAdView;
    [self.wrapView addSubview:_watchAdView];
    [_watchAdView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.wrapView).offset(15);
        if (IS_IPAD) {
            make.width.mas_equalTo(172);
        }else {
            make.width.mas_greaterThanOrEqualTo(172*kScreenScale);
        }
        make.centerY.equalTo(verLine);
        make.right.equalTo(verLine.mas_left);
        make.height.mas_equalTo(40);
    }];
//  connect support
    QDClickButtonView * supportView = [[QDClickButtonView alloc] initWithFrame:CGRectZero image:@"home_connectUs" text:NSLocalizedString(@"Home_ConnectSupport", nil) attributeString:@"" Action:^{
        self.canShowAds = YES;
        QDFeedbackViewController* vc = [QDFeedbackViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.wrapView addSubview:supportView];
    [supportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verLine.mas_right).offset(10);
        make.centerY.equalTo(verLine);
//        make.right.equalTo(self.wrapView).offset(-30);
        make.width.mas_greaterThanOrEqualTo(172*kScreenScale);
        make.height.mas_equalTo(40);
    }];
}


// GetPremium  1 多端登录 2 会员未绑定 3 非会员
- (void)setPremiumView {
    self.premiumView = [[QDGetPremiumView alloc] initWithFrame:CGRectZero clickAction:^(NSInteger status) {
        if (status == 1) {
            // 跳转至指定网页
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEBSITE_URL] options:@{} completionHandler:nil];
        }else if (status == 2) {
            [self onBindAction];
        }else {
            self.canShowAds = YES;
            QDPayViewController3* vc = [QDPayViewController3 new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    [self.wrapView addSubview:self.premiumView];
    [self.premiumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wrapView);
        if ([QDDeviceUtils deviceIs678]) {
            make.top.equalTo(self.connectButton.mas_bottom).offset(15*kScreenScale);
        }else {
            make.top.equalTo(self.connectButton.mas_bottom).offset(53*kScreenScale);
        }
        make.width.mas_equalTo(@240);
        make.height.mas_equalTo(50);
    }];
    [self.premiumView updateStatus];
}

//// connect status
//- (void)setConnectStatusView {
//    self.connectStatusView = [[QDConnectStatusView alloc] init];
//    [self.wrapView addSubview:self.connectStatusView];
//    [self.connectStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.centerX.equalTo(self.wrapView);
//        if ([QDDeviceUtils deviceIs678]) {
//            make.top.equalTo(self.connectButton.mas_bottom).offset(-3);
//        }else {
//            make.top.equalTo(self.connectButton.mas_bottom).offset(5);
//        }
//        make.height.equalTo(@16);
//    }];
//}

// notice
- (void)setNoticeView2 {
    self.noticeView2 = [[QDNoticeView2 alloc] init];
    self.noticeView2.hidden = YES;
    [self.semicircleImage addSubview:self.noticeView2];
    [self.noticeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.semicircleImage.mas_right).offset(-15*kScreenScale);
        make.top.equalTo(self.semicircleImage).offset(74*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(48*kScreenScale, 48*kScreenScale));
    }];
    
    [self.wrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.semicircleImage.mas_bottom);
    }];
}

// back
- (void) setupBack {
    
    UIImageView* backImage = [UIImageView new];
    backImage.image = [UIImage imageNamed:@"topSemicircle"];
    [self.view addSubview:backImage];
    
    CGFloat width  = 750/2;
    CGFloat height = 1198/2;
    CGFloat scaleWidth = [QDSizeUtils is_width];
    CGFloat scaleHeight = scaleWidth*height/width;
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.view);
        make.width.mas_equalTo(scaleWidth);
        make.height.mas_equalTo(scaleHeight);
    }];
}

- (void) setupTitle {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = NSLocalizedString(@"HomeTitleName", nil);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"SFUIText-Medium" size:28.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.wrapView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wrapView);
        make.top.equalTo(self.wrapView).offset([QDSizeUtils navigationHeight] + 5);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(34*kScreenScale);
    }];
    
    self.scanButton = [[UIButton alloc] init];
    [self.wrapView addSubview:self.scanButton];
    [self.scanButton addTarget:self action:@selector(onScanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.wrapView).offset(-10);
        make.width.height.mas_equalTo(40);
    }];
    [self updateScanButton];
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton setImage:[UIImage imageNamed:@"home_menu"] forState:UIControlStateNormal];
    [self.wrapView addSubview:self.menuButton];
    [self.menuButton addTarget:self action:@selector(onsideButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.wrapView);
        make.width.height.mas_equalTo(60);
    }];
}

// 更新时间视图
- (void) updateTimeView {
//    BOOL isHidden = (QDConfigManager.shared.activeModel == nil || QDConfigManager.shared.activeModel.member_type == 1);
//    [self.timeView setHidden:isHidden];
//    [self.timeView updateTime:QDConfigManager.shared.remainMins];

//    BOOL isHidden = (QDConfigManager.shared.activeModel == nil || QDConfigManager.shared.activeModel.member_type == 1);
//    [self.timeView3 setHidden:isHidden];
    [[QDTimerManager shared] clearTime];
    [self.timeView3 updateTime:QDConfigManager.shared.remainSeconds];
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    long expiredTime = [[userDefault objectForKey:@"expiredTime"] longLongValue];
//    if (!expiredTime) {
//        [self.timeView3 updateTime:QDConfigManager.shared.remainSeconds];
//        [userDefault setObject:[NSNumber numberWithLong:QDConfigManager.shared.activeModel.member_validity_time] forKey:@"expiredTime"];
//        [userDefault synchronize];
//    }else {
//        if (expiredTime == QDConfigManager.shared.activeModel.member_validity_time) {
//            return;
//        }else {
//            [self.timeView3 updateTime:QDConfigManager.shared.remainSeconds];
//            [userDefault setObject:[NSNumber numberWithLong:QDConfigManager.shared.activeModel.member_validity_time] forKey:@"expiredTime"];
//            [userDefault synchronize];
//        }
//    }
}

// 更新剩余时间标题
- (void) updateRemainText {
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        self.remainLabel.text = NSLocalizedString(@"Home_PremiumRemain_Time", nil);
    }else {
        self.remainLabel.text = NSLocalizedString(@"Home_Remain_Time", nil);
    }
}

// 更新绑定邮箱提示视图
//- (void) updateBindEmailTipView {
//    [self.bindView setHidden:![QDConfigManager.shared.activeModel.email isEqual:@""]];
//    [self.bindView updateView];
//}

// 更新反馈按钮
- (void) updateFeedBackView {
    BOOL showFeedBack = QDConfigManager.shared.activeModel != nil;
    [self.feedBackButton setHidden:!showFeedBack];
    [self.feedBackButton updateView];
}

// 更新RecommandView
- (void) updateRecommandView {
    BOOL show_app_ad = QDVersionManager.shared.versionConfig && [QDVersionManager.shared.versionConfig[@"show_app_ad"] intValue] == 1;
    BOOL isVIP = QDConfigManager.shared.activeModel&& QDConfigManager.shared.activeModel.member_type == 1;
    
    // 交叉推广
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString* code = [currentLocale objectForKey:NSLocaleCountryCode];
    BOOL isCN = [code isEqualToString:@"CN"];
    BOOL showRecommandView = !isVIP && show_app_ad && !isCN;
    [self.recommandAdView setHidden:!showRecommandView];
}

// 更新banner
- (void) updateBannerView {
    if (!self.recommandAdView.isHidden) return;
    
    if (!QDConfigManager.shared.activeModel) return;
    
    // add/remove banner ad
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        [QDAdManager.shared removeBannerAd];
    } else {
//        [QDAdManager.shared showBanner:self toBottom:-[QDSizeUtils is_tabBarHeight]];
        CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
        [QDAdManager.shared showBanner:self toBottom:toBottom];
    }
}

// 更新年度升级按钮
- (void) updateAnnualPayView {
    BOOL isVIP = QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1;
    BOOL isAnnualMeal = [QDConfigManager.shared.activeModel.set_meal isEqualToString:Year_Subscribe_Name];
    BOOL showAnnualPayView = isVIP && !isAnnualMeal;
    [self.annualPayButtonView updateText];
    [self.annualPayButtonView setHidden:!showAnnualPayView];
}

// 更新扫码按钮
- (void) updateScanButton {
    
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        [self.scanButton setImage:[UIImage imageNamed:@"common_scan_code"] forState:UIControlStateNormal];
    }else {
//        [self.scanButton setImage:[UIImage imageNamed:@"home_vip"] forState:UIControlStateNormal];
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"home_crow" ofType:@"gif"];

        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        UIImage * image = [UIImage sd_imageWithGIFData:imageData];
        [self.scanButton setImage:image forState:UIControlStateNormal];
    }
    
    BOOL isM1 = NO;
    if (@available(iOS 14.0, *)) {
        isM1 = [[NSProcessInfo processInfo] isiOSAppOnMac];
    }
    BOOL showScanButton = !isM1 && QDVersionManager.shared.versionConfig&&[QDVersionManager.shared.versionConfig[@"show_scan_code"] intValue] == 1;
    [self.scanButton setHidden:!showScanButton];
}
// 更新看广告加时长标题
- (void)updateWatchADText {
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        self.watchAdView.title = NSLocalizedString(@"Home_Share", nil);
    }else {
        self.watchAdView.title = NSLocalizedString(@"Home_GetTimeADs", nil);
    }
}
// 设置下方白色弧形
- (void) setupSemicircle {
    self.semicircleImage = [UIImageView new];
    self.semicircleImage.image = [UIImage imageNamed:@"home_white_Bottom"];
    self.semicircleImage.userInteractionEnabled = YES;
    CGFloat width  = 750/2;
    CGFloat height = 0.0;
    if ([QDDeviceUtils deviceIs678] || [QDDeviceUtils deviceIsPad]) {
        height = 700/2;
    }else {
        height = 886/2;
    }
    CGFloat scaleWidth = [QDSizeUtils is_width];
    CGFloat scaleHeight = scaleWidth*height/width;
    if (scaleWidth < [QDSizeUtils is_width])
        scaleWidth = [QDSizeUtils is_width];
    
    [self.wrapView addSubview:self.semicircleImage];
    [self.semicircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.wrapView);
        make.width.mas_equalTo(scaleWidth);
        if (IS_IPAD) {
            make.top.equalTo(self.lineButton.mas_bottom).offset(81);
        }else {
            if ([QDDeviceUtils deviceIs678]) {
                make.top.equalTo(self.lineButton.mas_bottom).offset(81*kScreenScale);
            }else {
                make.top.equalTo(self.lineButton.mas_bottom).offset(93*kScreenScale);
            }
        }
        make.height.mas_equalTo(scaleHeight);
    }];
}

- (void)setMiddleLabel {
    UILabel * remainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    remainLabel.text = NSLocalizedString(@"Home_Remain_Time", nil);
    remainLabel.textColor = [UIColor whiteColor];
    remainLabel.font = kSFUITextFont(12.0);
    remainLabel.textAlignment = NSTextAlignmentCenter;
    [self.wrapView addSubview:remainLabel];
    _remainLabel = remainLabel;
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wrapView);
        if (IS_IPAD) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(80);
        }else {
            if ([QDDeviceUtils deviceIs678] || [QDDeviceUtils deviceIsPad]) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(25*kScreenScale);
            }else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(40*kScreenScale);
            }
        }
        make.left.equalTo(self.wrapView);
        make.height.equalTo(@13);
    }];
    [self updateRemainText];
}

- (void) setupConnect {

    // 连接按钮
    WS(weakSelf);
    CGFloat wh;
    if ([QDDeviceUtils deviceIs678]) {
        wh = 189*kScreenScale;
    }else if (IS_IPAD) {
        wh = 240;
    }else {
        wh = 191*kScreenScale;
    }
    
    self.connectButton = [[QDConnectButtonView alloc] initWithFrame:CGRectZero clickBlock:^{
        if ((QDVPNManager.shared.status == NEVPNStatusDisconnected) || (QDVPNManager.shared.status == NEVPNStatusInvalid)) {
            [[QDConfigManager shared] getOtherTwoLinsWith:QDConfigManager.shared.node.ip];
        }
        [weakSelf onConnectAction];
    }];
    [self.semicircleImage addSubview:self.connectButton];
    [self.connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.semicircleImage);
        if (IS_IPAD) {
            make.top.equalTo(self.semicircleImage).offset(29);
        }else {
            if ([QDDeviceUtils deviceIs678]) {
                make.top.equalTo(self.semicircleImage).offset(16*kScreenScale);
            }else {
                make.top.equalTo(self.semicircleImage).offset(29*kScreenScale);
            }
        }
        make.width.height.mas_equalTo(wh);
    }];
    
//    CGFloat scaleHeight = ([QDSizeUtils is_height]*1.1/3);
//    CGFloat top = scaleHeight + wh / 2 - 55;
//    self.feedBackButton = [QDFeedBackButton new];
//    [self.view addSubview:self.feedBackButton];
//    [self.feedBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).offset(-12);
//        make.top.equalTo(self.view).offset(top);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(55);
//    }];
//    [self updateFeedBackView];
    
//    // 连接提示
//    self.connectTipView = [QDConnectTipView new];
//    [self.wrapView addSubview:self.connectTipView];
//    [self.connectTipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.connectButton.mas_bottom).offset(5);
//        make.centerX.equalTo(self.wrapView);
//        make.width.mas_equalTo(@(250));
//        make.height.mas_equalTo(@(20));
//    }];

    // 监听连接状态
    [self updateConnectStatus];
    QDVPNManager.shared.statusChangedHandler = ^(NEVPNStatus status) {
        [self updateConnectStatus];
    };
}

- (void) setupLine {
    WS(weakSelf);
    self.lineButton = [[QDLineButtonView alloc] initWithFrame:CGRectZero clickBlock:^{
        if (QDConfigManager.shared.activeModel.member_type == 1) {
            self.canShowAds = YES;
            [QDTrackManager track_button:QDTrackButtonType_7];
            RefreshViewController2* vc = [RefreshViewController2 new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            self.canShowAds = YES;
            [QDTrackManager track_button:QDTrackButtonType_7];
            RefreshViewController* vc = [RefreshViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.wrapView addSubview:self.lineButton];
    [self.lineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPAD) {
            make.top.equalTo(self.timeView3.mas_bottom).offset(50);
            make.height.mas_equalTo(120);
        }else {
            make.top.equalTo(self.timeView3.mas_bottom).offset(28*kScreenScale);
            make.height.mas_equalTo(90*kScreenScale);
        }
        make.centerX.equalTo(self.wrapView);
        make.width.mas_equalTo([QDSizeUtils is_width]);
    }];
    [self.lineButton setHidden:YES];
}

- (void) setupTimeView {
//    self.timeView = [[QDTimeView alloc] initWithFrame:CGRectZero];
//    [self.wrapView addSubview:self.timeView];
//    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineButton.mas_bottom).offset(12);
//        make.centerX.equalTo(self.wrapView);
//        make.width.mas_equalTo([QDSizeUtils is_width] - 40);
//        make.height.mas_equalTo(65);
//    }];
//    [self updateTimeView];
    
    self.timeView3 = [[QDTimeView3 alloc] initWithFrame:CGRectZero];
    [self.wrapView addSubview:self.timeView3];
    [self.timeView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainLabel.mas_bottom).offset(6);
        make.centerX.left.equalTo(self.wrapView);
        make.height.mas_equalTo(33);
    }];
    [self updateTimeView];
    
}

// annual pay view
- (void) setupAnnualPayView {
    self.annualPayButtonView = [QDAnnualPayButtonView new];
    [self.view addSubview:self.annualPayButtonView];
    [self.annualPayButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-[QDSizeUtils is_tabBarHeight]-10);
        make.centerX.width.equalTo(self.view);
        make.height.mas_equalTo(82);
    }];
    [self updateAnnualPayView];
}

// 推荐ad
- (void) setupRecommand {
    self.recommandAdView = [[QDRecommandAdView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.recommandAdView];
    [self.recommandAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-[QDSizeUtils is_tabBarHeight]);
        make.centerX.width.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self updateRecommandView];
}

// 通知窗口
- (void) setupNotice {
    
//    // 是否显示通知栏
//    BOOL show_notice = (QDVersionManager.shared.versionConfig != nil && [QDVersionManager.shared.versionConfig[@"show_notice"] intValue] == 1);
//    if (!show_notice) return;
//
//    // 移除通知栏
//    if (self.noticeView) [self.noticeView removeFromSuperview];

//    // 通知文本
//    NSString* notice_text = QDVersionManager.shared.versionConfig[@"notice_text"];
//    if (!notice_text || [notice_text isEqual:@""]) notice_text = NSLocalizedString(@"Notice_Default_Text", nil);
//
//    // 跳转
//    CGFloat w = 300;
//    CGFloat h = 32;
//    CGFloat x = ([QDSizeUtils is_width] - w)/2;
//    CGFloat y = [QDSizeUtils navigationHeight] + 44 + 20;
//    QDNoticeView* noticeView = [[QDNoticeView alloc] initWithFrame:CGRectMake(x, y, w, h) text:notice_text];
//    noticeView.layer.cornerRadius = 6;
//    noticeView.layer.masksToBounds = YES;
//    [self.wrapView addSubview:noticeView];
}

// 启动页
- (void) setupSpashView {
    QDSpashView* v = [QDSpashView new];
    UIView* rootView = UIApplication.sharedApplication.delegate.window.rootViewController.view;
    [rootView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    v.callback = ^{
        if (!QDConfigManager.shared.isAccepted) {
            BOOL hide_privacy = (QDVersionManager.shared.versionConfig && [QDVersionManager.shared.versionConfig[@"hide_privacy"] intValue] == 1);
            if (hide_privacy) {
                [self setupGuide];
            } else {
                [self setupPrivate];
            }
        } else {
            [self doInit];
        }
    };
}

// 用户隐私
- (void) setupPrivate {
    ProtocolView* v = [ProtocolView new];
    UIView* rootView = UIApplication.sharedApplication.delegate.window.rootViewController.view;
    [rootView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    v.callback = ^{
        if ([QDVersionManager.shared.versionConfig[@"show_guide"] intValue]) {
            [self setupGuide];
        } else {
            [self doInit];
        }
    };
}

// 引导
- (void) setupGuide {
    [QDGuideView showGuide:^{
        [self doInit];
    }];
}

// 进入操作
- (void) doInit {
    
    self.hadShowAds = NO;
    
    // 用户协议已接收
    QDConfigManager.shared.isAccepted = YES;
    
    // 初始化完成统计
    [QDTrackManager track:QDTrackType_app_inited data:@{}];
//    [QDLocalNoticationManager.shared setup];
//    [QDAdManager.shared setup:YES];
}
// 展示开屏广告
- (void)showAds {
    [self showOpenAd];
    self.hadShowAds = YES;
}

#pragma mark -- connect relations
// 是否可以连接
- (BOOL) canConnecting {
    
    // 无网络
    if (![AFNetworkReachabilityManager sharedManager].isReachable) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HomeNoNetwork", nil)];
        return NO;
    }
    
    // 无节点
    if (!QDConfigManager.shared.node) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HomeNoNodes", nil)];
        return NO;
    }
    
    // 设备没有激活
    if (!QDConfigManager.shared.activeModel) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Device_no_active", nil)];
        return NO;
    }
    
    // 被拦截、大陆用户不开放
    if (QDConfigManager.shared.activeModel.white_type == 1) {
        NSString* uid = @"-1";
        if (QDConfigManager.shared.activeModel) {
            uid = [NSString stringWithFormat:@"%ld", QDConfigManager.shared.activeModel.uid];
        }
        NSString* limitText = [NSString stringWithFormat:NSLocalizedString(@"Dialog_Warning_Limit", nil), uid];
        [QDDialogManager showDialog:NSLocalizedString(@"", nil) message:limitText ok:NSLocalizedString(@"Dialog_Ok", nil) cancel:nil okBlock:^{
        } cancelBlock:^{}];
        return NO;
    }
    
    // vip到期了
    if (QDConfigManager.shared.activeModel.member_type == 3) {
        [QDDialogManager showVIPExpired:^{
            self->_typeString = [self platformString];
            if ([self->_typeString isEqualToString:@"iPhone 6s"]||[self->_typeString isEqualToString:@"iPhone 6"]||[self->_typeString isEqualToString:@"iPhone 7"]||[self->_typeString isEqualToString:@"iPhone 8"]) {
                self.canShowAds = YES;
                QDPayViewController3* vc = [[QDPayViewController3 alloc]init];
                UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [rootViewController presentViewController:vc animated:YES completion:nil];

            }else{
                self.canShowAds = YES;
                QDPayViewController2* vc = [[QDPayViewController2 alloc]init];
                UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [rootViewController presentViewController:vc animated:YES completion:nil];
            }
            
            
        }];
        return NO;
    }
    return YES;
}

//获取ios设备号
- (NSString *)platformString {

    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";

    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";

    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";

   
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";

    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceString;


}



// 验证是否可以访问指定网址
- (void) verifyCanAccessUrl {
    NSString* testUrl = QDConfigManager.shared.node.test_url;
    if (testUrl&&![testUrl isEqual:@""]) {
        [QDTaskManager.shared add:QDTaskTypeNodeVerifyCode];
        [QDVPNConnectCheck canConnect:testUrl completed:^(BOOL result) {
            
            if (result) {
                [self doConnectSuccess];
            } else {
                
                [QDTrackManager track:QDTrackType_connect_fail_test_connect data:@{@"node_id":QDConfigManager.shared.node.nodeid}];

                [QDVPNManager.shared stop];

                // 连接失败
                [self doConnectFail:@"连接验证失败"];
            }
        }];
    } else {
        [self doConnectSuccess];
    }
}

- (void) updateConnectStatus {
    NEVPNStatus status = QDVPNManager.shared.status;
    switch (status) {
        case NEVPNStatusDisconnecting:
        {
            if (![QDTaskManager.shared hasTask]) {
                [QDTaskManager.shared add:QDTaskTypeDisconnected];
            }
        }
            break;
        case NEVPNStatusInvalid:
            break;
        case NEVPNStatusDisconnected:
        {
            // 任务状态
            if ([QDTaskManager.shared hasTaskByType:QDTaskTypeDisconnected]) {

                // 移除断开任务
                [QDTaskManager.shared remove:QDTaskTypeDisconnected];

                // 若存在连接任务，则执行
                if ([QDTaskManager.shared hasTaskByType:QDTaskTypeConnected]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 无任务执行
                        if (![QDTaskManager.shared hasTask]) return;
                        [QDTaskManager.shared remove:QDTaskTypeConnected];
//                        [self startConnnectVPN];
                    });
                }
            }
        }
            break;
        case NEVPNStatusConnecting:
            break;
        case NEVPNStatusConnected:
        {
            // 任务状态
            if ([QDTaskManager.shared hasTask]) {
                
                // 移除连接任务
                [QDTaskManager.shared removeAll];
                
//                // 验证网络是否可访问
//                [self verifyCanAccessUrl];
            }
            if (QDVPNManager.shared.status == NEVPNStatusConnected) {
                [self.connectButton updateUIStatus:status_button_connected];
            }
        }
            break;
        default:
            break;
    }
}

// 连接失败
- (void) doConnectFail:(NSString*)log {
    NSLog(@"doConnectFail====>%@", log);
    
    // 上报
    [QDModelManager requestConnectRecord:[QDDateUtils getNowDateString] pingResult:1 connectResult:0 completed:^(NSDictionary * _Nonnull dictionary) {
        
    }];
    
    // 清空任务
    [QDTaskManager.shared removeAll];
    
    if (QDConfigManager.shared.otherLinesNodes.count > 0) {
        QDNodeModel * node = [QDConfigManager.shared connectFailUpdateLines];
        if (node) {
//            [self startConnnectVPN];
            [self startPing];
            [self.lineButton updateNode:QDConfigManager.shared.node];
            return;;
        }
    }
    
    
    // 刷新页面
    [self.connectButton updateUI];
    
    // 取消定时执行
    [self cancelTimingPerform];

    [self.connectButton updateUIStatus:status_button_fail];
    
    // 连接失败
    [QDTrackManager track:QDTrackType_connect_fail data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
    
    if (QDVPNManager.shared.isReInstallerVPNConfig) {
        [QDDialogManager showDialog:NSLocalizedString(@"Connect_fail", nil) message:NSLocalizedString(@"Connect_refail_info", nil) ok:NSLocalizedString(@"Dialog_Ok", nil) cancel:nil okBlock:^{
            self.canShowAds = YES;
            QDFeedbackViewController* vc = [QDFeedbackViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } cancelBlock:^{
        }];
        return;
    }
    
    if (QDConfigManager.shared.otherLinesNodes.count == 0) {
        [QDDialogManager showDialog:NSLocalizedString(@"Connect_fail", nil) message:NSLocalizedString(@"Connect_fail_info", nil) ok:NSLocalizedString(@"Dialog_Ok", nil) cancel:nil okBlock:^{
            // 安装VPN config
            [QDVPNManager.shared reStartInstallConfig:^(NSError * _Nonnull error) {
                if (error) {
                    [QDTaskManager.shared removeAll];
                    [self.connectTipView stop];
                    [self.connectButton updateUI];
                } else {

                    // 显示插屏广告
                    [self showInsertAd];

                    // 移除安装配置任务
                    [QDTaskManager.shared remove:QDTaskTypeInstallConfig];

                    // 添加超时
                    [self performSelector:@selector(autoConnectFail) withObject:nil afterDelay:15];

                    [self startConnnectVPN];
                    
                    [self.connectButton updateUIStatus:status_button_connecting];
                }
            }];
        } cancelBlock:^{
            
        }];
    }
}

// 连接成功
- (void) doConnectSuccess {
    
    NSLog(@"doConnectSuccess--->%ld", [QDTaskManager.shared taskCount]);
    
    // 清空任务
    [QDTaskManager.shared removeAll];
    
    NSLog(@"doConnectSuccess1--->%ld", [QDTaskManager.shared taskCount]);
    
    // 刷新页面
    [self.connectButton updateUI];
    
    // 取消定时执行
    [self cancelTimingPerform];
    
    // 已连接
    SystemSoundID soundID = kSystemSoundID_Vibrate;
    AudioServicesPlaySystemSound(soundID);
    
    // 上报
    [QDModelManager requestConnectRecord:[QDDateUtils getNowDateString] pingResult:1 connectResult:1 completed:^(NSDictionary * _Nonnull dictionary) {
        NSLog(@"%@",dictionary);
    }];
    
    // 连接成功
    [QDTrackManager track:QDTrackType_connect_suc data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
    
    [[QDTimerManager shared] clearTime1];
    // 连接之后的动作
    [self doConnectAction];
    
    [QDTimerManager shared].startConnectTimer = YES;
    
//    [self.connectTipView showSuccess];
//    [self.connectStatusView updateConnectStatus:status_connected];
    [self.connectButton updateUIStatus:status_button_connected];
    
    if (QDConfigManager.shared.otherLinesNodes.count < 3 && ![QDConfigManager.shared.defaultCountry isEqualToString:QDConfigManager.shared.node.country]) {
        [QDDialogManager showDialog:NSLocalizedString(@"Connect_success", nil) message:NSLocalizedString(@"Connect_success_otherLine", nil) ok:NSLocalizedString(@"Connect_success_ok", nil) cancel:NSLocalizedString(@"Connect_success_no", nil) okBlock:^{

        } cancelBlock:^{
            if (QDConfigManager.shared.activeModel.member_type == 1) {
                self.canShowAds = YES;
                [QDTrackManager track_button:QDTrackButtonType_7];
                RefreshViewController2* vc = [RefreshViewController2 new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                self.canShowAds = YES;
                [QDTrackManager track_button:QDTrackButtonType_7];
                RefreshViewController* vc = [RefreshViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

// 连接之后的动作，非会员连接后弹出
- (void) doConnectAction {
    
//    // 防止重复弹出
//    for (UIViewController* vc in self.navigationController.viewControllers) {
//        if ([NSStringFromClass([vc class]) isEqual:@"QDNativeAdViewController"]) {
//            return;
//        }
//    }

//    if (!QDConfigManager.shared.activeModel || QDConfigManager.shared.activeModel.member_type != 1) {
//
//    }
    self.canShowAds = YES;
    QDNativeAdViewController* vc = [QDNativeAdViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    // 丢弃（不稳定，容易引起崩溃）
//    [QDStoreReviewManager.shared show];
}

- (void) autoConnectFail {
    if ([QDTaskManager.shared hasTask]) {
        [QDTrackManager track:QDTrackType_connect_timeout data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
        [self doConnectFail:@"超时失败"];
    }
}

// 取消定时执行
- (void) cancelTimingPerform {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoConnectFail) object:nil];
}

- (void) startConnnectVPNAnim {
    [QDTaskManager.shared add:QDTaskTypeInstallConfig];
    [self.connectButton updateUI];
//    [self.connectTipView show];
//    [self.connectStatusView updateConnectStatus:status_connecting];
    [self.connectButton updateUIStatus:status_button_connecting];
}

- (void) startConnnectVPN {
    
    [QDTaskManager.shared add:QDTaskTypeNodeRegister];
    [QDModelManager requestRegisterNode:QDConfigManager.shared.node.ip completed:^(NSDictionary * _Nonnull dictionary) {
        
        
        
        // 无任务执行
        if (![QDTaskManager.shared hasTask]) return;
        
        QDBaseResultModel* resultModel = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (resultModel.code == kHttpStatusCode200) {
            
            // 隧道最多维持30天，防止越界
            long mins = QDConfigManager.shared.remainMins;
            if (QDConfigManager.shared.remainMins > 30*24*60) {
                mins = 30*24*60;
            }
            NSDictionary* dict = @{@"remainMins":@(mins),@"host":QDConfigManager.shared.node.host, @"port":QDConfigManager.shared.node.port, @"password":QDConfigManager.shared.UUID};
            
            [QDTaskManager.shared add:QDTaskTypeConnected];
            [QDTaskManager.shared remove:QDTaskTypeNodeRegister];
            [QDVPNManager.shared start:dict completion:^(NSError * _Nonnull error) {
                if (error) {
                    
//                    if ([QDTaskManager.shared hasTask]) {
                        // 连接失败
                        [QDTrackManager track:QDTrackType_connect_fail_tunnel data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
                        [self doConnectFail:@"隧道连接失败"];
//                    }
                }else {
                    // 验证网络是否可访问
                    [self verifyCanAccessUrl];
                }
            }];
        } else {
            [QDTrackManager track:QDTrackType_connect_fail_node_register data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
            [self doConnectFail:@"节点注册失败"];
        }
    }];
}

- (void) stopVPN {
    if ([QDTaskManager.shared hasTask]) return;
    if (QDVPNManager.shared.status == NEVPNStatusConnected) {
        [QDVPNManager.shared stop];
        [QDTaskManager.shared add:QDTaskTypeDisconnected];
    }
    [self.connectButton updateUI];
    [[QDTimerManager shared] clearTime1];
    [self.connectButton updateUIStatus:status_button_disconnected];
//    [self.connectStatusView updateConnectStatus:status_disconnected];
}

#pragma mark -- click action
- (void) onScanButtonClicked {
    
    if (QDConfigManager.shared.activeModel.member_type == 1) {
        BOOL isBind = (QDConfigManager.shared.activeModel && ![QDConfigManager.shared.activeModel.email isEqual:@""]);
        if (!isBind) {
            [QDDialogManager showDialog:@"" message:NSLocalizedString(@"Scan_Guide_Message", nil) ok:NSLocalizedString(@"Scan_Guide_OK", nil) cancel:NSLocalizedString(@"Scan_Guide_Cancel", nil) okBlock:^{
                [self onBindAction];
            } cancelBlock:^{
                
            }];
            return;
        }
        self.canShowAds = YES;
        [QDTrackManager track_button:QDTrackButtonType_34];
        QDQRCodeViewController* vc = [QDQRCodeViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        self.canShowAds = YES;
        // 不是会员
        QDPayViewController3* vc = [[QDPayViewController3 alloc]init];
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

- (void)onsideButtonClick {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void) onBindAction {
    self.canShowAds = YES;
    QDRegisterViewController* vc = [QDRegisterViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void) onConnectAction {
    
    [QDTrackManager track_button:QDTrackButtonType_6];
    
    // 若还存在任务未执行，则不处理
    if ([QDTaskManager.shared hasTask]) {
        return;
    }
    
    // 不能连接
    if (![self canConnecting]) return;
    
    // 若处于连接状态，则断开
    if (QDVPNManager.shared.status == NEVPNStatusConnected) {
//        [self.connectStatusView updateConnectStatus:status_disconnecting];
        [self.connectButton updateUIStatus:status_button_disconnecting];
        [QDTimerManager shared].startConnectTimer = NO;
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        if ([QDTimerManager shared].connectedTimeValue >= 15 || [[userDefault objectForKey:@"ClickSatifsy"] isEqualToString:@"YES"]) {
            [self toRate];
        }
        if ([QDTimerManager shared].connectedTimeValue < 15 && [[userDefault objectForKey:@"ClickButton"] isEqualToString:@"NO"]) {
            self.canShowAds = YES;
            QDFeedbackViewController* vc = [QDFeedbackViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self stopVPN];
        });
    }
    
    // 若断开，则连接
    if (QDVPNManager.shared.status == NEVPNStatusInvalid || QDVPNManager.shared.status == NEVPNStatusDisconnected) {
        [self startPing];
    }
}

- (void)startPingWIthAction:(int)action complete:(void(^)(void))complete {
    
    [self.connectButton updateUIStatus:status_button_loading];
    NSArray * arr = @[QDConfigManager.shared.node.host];
    self.pingHelper = [[NENPingManager alloc] init];
    [self.pingHelper getFatestAddress:arr requestTimes:1 completionHandler:^(NSString * _Nonnull host, NSArray * _Nullable itemArr) {
        NSInteger delayTimes = [[[[itemArr firstObject] objectForKey:host] firstObject] integerValue];
        if (delayTimes == 10000) {
            [QDModelManager requestConnectRecord:[QDDateUtils getNowDateString] pingResult:0 connectResult:0 completed:^(NSDictionary * _Nonnull dictionary) {

            }];
            if (QDConfigManager.shared.otherLinesNodes.count > 0) {
                QDNodeModel * node = [QDConfigManager.shared connectFailUpdateLines];
                [self.lineButton updateNode:QDConfigManager.shared.node];
                if (action == 1) {
                    [self startPing];
                }else {
                    [self changeStartPing];
                }
            }else {
                [self.connectButton updateUIStatus:status_button_fail];
                [QDDialogManager showDialog:NSLocalizedString(@"Connect_fail", nil) message:NSLocalizedString(@"Ping_fail_info", nil) ok:NSLocalizedString(@"Connect_success_ok", nil) cancel:nil okBlock:^{
                    self.canShowAds = YES;
                    QDFeedbackViewController* vc = [QDFeedbackViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } cancelBlock:^{
                }];
            }
        }else {
            complete();
        }
    }];
    
    return;
    
    if (self.simplePingHelper) {
        self.simplePingHelper = nil;
    }
    // ping判断
    self.simplePingHelper = [[FFSimplePingHelper alloc] initWithHostName:QDConfigManager.shared.node.host];
    [self.simplePingHelper startPing];
    
    __strong typeof(self) strongSelf = self;
    self.simplePingHelper.resultStatus = ^(NSInteger result) {
        if (result == 10000) {
            [QDModelManager requestConnectRecord:[QDDateUtils getNowDateString] pingResult:0 connectResult:0 completed:^(NSDictionary * _Nonnull dictionary) {
                
            }];
            [strongSelf.simplePingHelper stopPing];
            if (QDConfigManager.shared.otherLinesNodes.count > 0) {
                QDNodeModel * node = [QDConfigManager.shared connectFailUpdateLines];
                [strongSelf.lineButton updateNode:QDConfigManager.shared.node];
                if (action == 1) {
                    [strongSelf startPing];
                }else {
                    [strongSelf changeStartPing];
                }
            }else {
                [strongSelf.connectButton updateUIStatus:status_button_fail];
                [QDDialogManager showDialog:NSLocalizedString(@"Connect_fail", nil) message:NSLocalizedString(@"Ping_fail_info", nil) ok:NSLocalizedString(@"Connect_success_ok", nil) cancel:nil okBlock:^{
                    strongSelf.canShowAds = YES;
                    QDFeedbackViewController* vc = [QDFeedbackViewController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                } cancelBlock:^{
                }];
            }
        }else {
            complete();
        }
    };
}

- (void)startPing {
    
    [self startPingWIthAction:1 complete:^{
        [QDTrackManager track:QDTrackType_connect_start data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
        [self startConnnectVPNAnim];
        
        // 安装VPN config
        [QDVPNManager.shared startInstallConfig:^(NSError * _Nonnull error) {
            if (error) {
                [QDTaskManager.shared removeAll];
                [self.connectTipView stop];
                [self.connectButton updateUI];
            } else {
                
                // 显示插屏广告
                [self showInsertAd];
                
                // 移除安装配置任务
                [QDTaskManager.shared remove:QDTaskTypeInstallConfig];
                
                // 添加超时
                [self performSelector:@selector(autoConnectFail) withObject:nil afterDelay:15];
                
                [self startConnnectVPN];
            }
        }];
    }];
}

# pragma mark - timer
- (void) startTimer {
    
    // 如果定时器开启，不重新开启
    if (nil != self.timer) return;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        // 检查时间
        if (QDConfigManager.shared.remainMins > 0) {
            QDConfigManager.shared.remainMins -= 1;
        } else {
            QDConfigManager.shared.remainMins = 0;
            [strongSelf requestUserInfo];
            [strongSelf stopTimer];
            [QDTaskManager.shared removeAll];
            [strongSelf stopVPN];
        }
        [strongSelf updateRemainTime];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self updateRemainTime];
}

- (void) updateRemainTime {
    [self.timeView updateTime:QDConfigManager.shared.remainMins];
}

- (void) stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -- notification actions
- (void) notifyLineRefresh {
    [self.lineButton updateNode:QDConfigManager.shared.node];
    // 显示节点
    [self.lineButton setHidden:NO];
}

- (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

- (NSTimeInterval)nowTimeInterval {
    // 现在的时间戳
    
    // 获取当前时间0秒后的时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    // *1000 是精确到毫秒，不乘就是精确到秒
    NSTimeInterval time = [date timeIntervalSince1970];
//    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];
    return time;
}

// 更新用户剩余时间
-(void)notifyUserActive {
    
    if (!QDConfigManager.shared.activeModel) return;
    
    // title
    [UIUtils showAppTitle:self.titleLabel];
    
    // 上报延迟
//    if (QDConfigManager.shared.nodes) {
//        for (QDNodeModel* node in QDConfigManager.shared.nodes) {
//            [QDPingManager.shared ping:node.host];
//        }
//    }
//    NSLog(@"-------------%@ ------%@",[self currentDateStr],[self nowTimeInterval]);
    QDConfigManager.shared.remainSeconds = QDConfigManager.shared.activeModel.member_validity_time - [QDDateUtils getNowUTCTimeTimestamp];
    QDConfigManager.shared.remainMins = (QDConfigManager.shared.activeModel.member_validity_time - [QDDateUtils getNowUTCTimeTimestamp])/60;
    if (QDConfigManager.shared.remainMins < 0) {
        QDConfigManager.shared.remainMins = 0;
        [self stopVPN];
    }
        
    if (QDConfigManager.shared.remainMins > 0) [self startTimer];
    
    // time
    [self updateTimeView];
    
//    // bindview
//    [self updateBindEmailTipView];
    
    // 更新视图
    [self updateFeedBackView];
    [self updateRecommandView];
    [self updateBannerView];
    [self updateScanButton];
    [self updateAnnualPayView];
    [self updateWatchADText];
    [self.premiumView updateStatus];
    [self updateRemainText];
}

// 更新线路
-(void)notifyLineChange {
    
    // 判断是否可以连接
    if (![self canConnecting]) return;
    
    // 获取两条备用线路
    [[QDConfigManager shared] getOtherTwoLinsWith:QDConfigManager.shared.node.ip];
    
    // 更新节点状态
    [self.lineButton updateNode:QDConfigManager.shared.node];
    
    // 若有任务
    if ([QDTaskManager.shared hasTask]) return;
    
    [self changeStartPing];
}

- (void)changeStartPing {
    [self startPingWIthAction:2 complete:^{
        [self InstallConfig];
    }];
}

- (void)InstallConfig {
    // 安装VPN config
    [QDTrackManager track:QDTrackType_connect_start data:@{@"node_id":QDConfigManager.shared.node.nodeid}];
    [self.connectButton updateUIStatus:status_button_connecting];
    [QDVPNManager.shared startInstallConfig:^(NSError * _Nonnull error) {
        if (error) {
            [QDTaskManager.shared removeAll];
            [self.connectTipView stop];
            [self.connectButton updateUI];
        } else {
            
            // 显示插屏广告
            [self showInsertAd];
            
            // 移除安装配置任务
            [QDTaskManager.shared remove:QDTaskTypeInstallConfig];
            
            // 添加超时
            [self performSelector:@selector(autoConnectFail) withObject:nil afterDelay:15];
            
            // 连接或断开上一个节点，重新连接新的节点
            if (QDVPNManager.shared.status == NEVPNStatusDisconnected || QDVPNManager.shared.status == NEVPNStatusInvalid) {
                [self startConnnectVPN];
            } else {
                [QDTaskManager.shared add:QDTaskTypeConnected];
                [QDTaskManager.shared add:QDTaskTypeDisconnected];
                [QDVPNManager.shared stop];
                [self changeStartPing];
            }
        }
    }];
}

- (void) notifyRecommandApp {
    if (self.recommandAdView.isHidden) return;
    NSString* ok = NSLocalizedString(@"Recommand_Dialog_Button", nil);
    [QDDialogView show:NSLocalizedString(@"Recommand_Dialog_Title", nil) message:NSLocalizedString(@"Recommand_Dialog_Text", nil) items:@[ok] hideWhenTouchOutside:YES cancel:NSLocalizedString(@"Dialog_Cancel", nil) callback:^(NSString *item) {
        if ([item isEqual:ok]) {
            [self.recommandAdView clickAction];
        }
    }];
}

// 网络状态发生变化
- (void) notifyNetworkChanged {
    if (AFNetworkReachabilityManager.sharedManager.isReachable) {
        [self requestUserInfo];
    } else {
//        [self stopVPN];
    }
}

// 配置安装开始
- (void) notifyConfigInstallStart {
    if (!self.configInstallGuideView) {
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        self.configInstallGuideView = [[QDConfigInstallGuideView alloc] initWithFrame:rootViewController.view.bounds];
        [rootViewController.view addSubview:self.configInstallGuideView];
        [self.configInstallGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootViewController.view);
        }];
    }
    [self.configInstallGuideView setHidden:NO];
}

// 配置安装失败
- (void) notifyConfigInstallFail {
    [self notifyConfigInstallEnd];
    if (self.configErrorView) [self.configErrorView show];
    [self.connectButton updateUIStatus:status_button_fail];
}

// 配置安装结束
- (void) notifyConfigInstallEnd {
    if (self.configInstallGuideView) [self.configInstallGuideView setHidden:YES];
}

// 通知配置更新
- (void) notifyConfigUpdate {
    
    // time
    [self updateTimeView];
    
    // recommand
    [self updateRecommandView];
    
    // 更新通知栏
    [self setupNotice];
}

// 显示插屏
- (void) showInsertAd {
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    if (QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
        BOOL show_interstitial_ad = [QDVersionManager.shared.versionConfig[@"show_interstitial_ad"] intValue] == 1;
        if (show_interstitial_ad) {
            [QDAdManager.shared showOpenAd];
            return;
        }
    }
}


// 显示插屏,每次进入首页显示
- (void) showInsertAds {
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    if (!isVIP) {
        BOOL show_interstitial_ad = [QDVersionManager.shared.versionConfig[@"show_interstitial_ad"] intValue] == 1;
        if (show_interstitial_ad) {
            [QDAdManager.shared showInterstitial];
            UnityOpenAds.shared.interstitialCallback = ^() {
            };
            return;
        }
    }
}


// 显示开屏
- (void) showOpenAd {
    
    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
    if (QDConfigManager.shared.isNoneFirstEnterApp && !isVIP) {
        BOOL show_open_ad = [QDVersionManager.shared.versionConfig[@"show_open_ad"] intValue] == 1;
        if (show_open_ad) {
            [QDAdManager.shared showOpenAd];
            return;
        }
    }
}

// 去评分
- (void)toRate {
    NSString * timeString = [self getNowTimeTimestamp];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kLastTime]) {
        NSString * timeStringLast = [userDefault objectForKey:kLastTime];
        NSString * time = [self getDurationStartTime:timeStringLast endTime:timeString];
        if ([time integerValue] >= 24*3600) {
            timeString = [NSString stringWithFormat:@"%ld",[timeStringLast integerValue]+3600];
            [userDefault setValue:timeString forKey:kLastTime];
            [userDefault synchronize];
        }else {
            return;
        }
    }else {
        [userDefault setValue:timeString forKey:kLastTime];
        [userDefault synchronize];
    }
    
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }else {
        NSString *str = @"https://itunes.apple.com/us/app/twitter/id1490819262?mt=8&action=write-review";

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]])//判断当前环境是否可以打开此url
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    
    return timeString;
}

- (NSString *)getDurationStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
//    NSString * dateString = [formatter stringFromDate:date1];
    NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];
//    NSString * dateString2 = [formatter stringFromDate:date2];
    
    NSTimeInterval value=[date2 timeIntervalSinceDate:date1];
    return [NSString stringWithFormat:@"%ld",(NSInteger)value];
}


@end
