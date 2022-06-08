//
//  CSLYPurchaseNotifyViewController.m
//  StormVPN
//
//  Created by hzg on 2021/11/30.
//

#import "QDPurchaseNotifyViewController.h"
#import "QDSizeUtils.h"
#import "QDReceiptManager.h"

// 购买推送界面
@interface QDPurchaseNotifyViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDPurchaseNotifyViewController

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
    
    // bk
    self.view.backgroundColor = [UIColor whiteColor];
    
    // sv
    [self setupSV];
    
    // feature
    [self setupFeature];
    
    // bottom
    [self setupBottom];
    
    UIButton* closeButton = [UIButton new];
    [self.scrollView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void) setupFeature {
    self.scrollViewHeight = [QDSizeUtils is_tabBarHeight] + 44 + 270 + 90;
    NSArray* features = @[@"QDFeatureView0", @"QDFeatureView1", @"QDFeatureView2", @"QDFeatureView3"];
    NSString* randName = features[(int)(arc4random() % features.count)];
    UIView* feature = [[NSClassFromString(randName) alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollViewHeight)];
    [self.scrollView addSubview:feature];
}

- (void) setupBottom {
    
    // 7天免费&每月扣费提示&恢复按钮
    [self setupPayButtons];
    
    // scrollView
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.scrollViewHeight)];
}

// 设置付费框
- (void) setupPayButtons {
    
    self.scrollViewHeight += 20;
    
    // 连接包月按钮
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMonth.backgroundColor = RGB_HEX(0x3e9efa);
    buttonMonth.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonMonthLabel.textColor = [UIColor whiteColor];
    buttonMonthLabel.text = NSLocalizedString(@"VIPPromotionText2", nil);
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonMonth);
    }];
    
    self.scrollViewHeight += buttonHeight;
    
    // restore button
    [self setupRestoreButton];
}

- (void) setupRestoreButton {
    
    self.scrollViewHeight += 10;
    
    // restore button
    UIButton* restoreButton = [UIButton new];
    [self.scrollView addSubview:restoreButton];
    [restoreButton addTarget:self action:@selector(restoreAction) forControlEvents:UIControlEventTouchUpInside];
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.scrollViewHeight));
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(50));
        make.height.equalTo(@(35));
    }];
    
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"VIPRestore", nil);
    label.font          = [UIFont systemFontOfSize:12];
    label.textColor     = RGB_HEX(0xb3b3b3);
    [restoreButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(restoreButton);
    }];
    [label sizeToFit];
    
    UIView* line = [UIView new];
    line.backgroundColor     = RGB_HEX(0xb3b3b3);
    [restoreButton addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(label.mj_w));
        make.bottom.equalTo(label.mas_bottom);
        make.height.equalTo(@(0.5));
        make.centerX.equalTo(restoreButton);
    }];
}

# pragma mark - actions
- (void) payAction {
    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success) {
        if (success) [self closeAction];
    }];
}

- (void) closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) restoreAction {
    [QDReceiptManager.shared restore:^(BOOL success) {
        if (success) [self closeAction];
    }];
}

@end
