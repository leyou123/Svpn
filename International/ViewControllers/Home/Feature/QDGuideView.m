//
//  QDGuideView.m
//  Created by hzg on 2021/5/14.

#import "QDGuideView.h"
#import "QDFeatureBaseView.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"
#import "QDReceiptManager.h"
#import "QDLoginViewController.h"


static NSString * const kAppVersion = @"appVersion";

@interface QDGuideView() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel* nextLabel;
@property (nonatomic, strong) UIButton* enterButton;
@property (nonatomic, strong) UIButton* freeEnterButton;
@property (nonatomic, strong) NSArray *features;

@property (nonatomic, strong) UIScrollView *scrollView1;
@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic,strong) UILabel* priceLabel;


@property (nonatomic, strong)  UIButton* loginButton;


@end

@implementation QDGuideView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self build];
    }
    return self;
}

- (void)dealloc {
    [self unregisterFromKVO];
}

#pragma mark - Private Method
- (void)build {
    
    // notify
    [self registerForKVO];
    
    // root
    UIView *view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    // bk
    self.backgroundColor = [UIColor whiteColor];//RGB_HEX(0x091a47);
    
    // root scrollview1
    [self addSubview:self.scrollView1];
    [self.scrollView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.scrollViewHeight = [QDSizeUtils is_tabBarHeight] + 44 + 270 + 90;
    
    // features
    self.features = @[@"QDFeatureView0", @"QDFeatureView1", @"QDFeatureView2", @"QDFeatureView3"];
    
    
    // scrollView
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*self.features.count, self.scrollViewHeight);
    [self.scrollView1 addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView1);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(self.scrollViewHeight));
    }];

    for (int i=0; i<self.features.count; i++) {
        QDFeatureBaseView* feature = [[NSClassFromString(self.features[i]) alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollViewHeight)];
        [self.scrollView addSubview:feature];
    }
    
    // 构建下面部分
    [self buildBottom];
    
}

- (void) buildBottom {
    
    // 页码
    [self setupPagesOrNormalButton];
    
    // 7天免费&每月扣费提示&恢复按钮
    [self setupPayButtons];
    
    // note
    [self setupNote];
    
    // scrollView
    [self.scrollView1 setContentSize:CGSizeMake(kScreenWidth, self.scrollViewHeight)];
}

// 页码&General Button
- (void) setupPagesOrNormalButton {
    self.pageControlCurrentColor = RGB_HEX(0xff7200);
    self.pageControlNomalColor   = RGB_HEX(0xa7a7a7);
    self.pageControl.numberOfPages = self.features.count;
    self.pageControl.pageIndicatorTintColor = self.pageControlNomalColor;
    self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor;
    [self.scrollView1 addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.scrollViewHeight));
        make.centerX.equalTo(self.scrollView1);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(30));
    }];
    self.scrollViewHeight += 30;
    
    // free button
    self.freeEnterButton = [UIButton new];
    [self.freeEnterButton setImage:[UIImage imageNamed:@"feature_close_btn"] forState:UIControlStateNormal];
    [self.scrollView1 addSubview:self.freeEnterButton];
    [self.freeEnterButton addTarget:self action:@selector(enterFreeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.freeEnterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.left.equalTo(self).offset(12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.freeEnterButton setHidden:YES];
    
    
    self.loginButton = [UIButton new];
    [self.scrollView1 addSubview:self.loginButton];
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 12));
        make.right.equalTo(self).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    UILabel* label = [UILabel new];
    label.text          = NSLocalizedString(@"Login_Uppercase", nil);
    label.font          = [UIFont boldSystemFontOfSize:14];
    label.textColor     = [UIColor blackColor];
    [self.loginButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loginButton);
    }];
    [label sizeToFit];
    
    UIView* line = [UIView new];
    line.backgroundColor     = [UIColor blackColor];
    [self.loginButton addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(label.mj_w));
        make.bottom.equalTo(label.mas_bottom);
        make.height.equalTo(@(0.5));
        make.centerX.equalTo(self.loginButton);
    }];
    [self notifyUserActive];
}

// 设置付费框
- (void) setupPayButtons {
    
    self.scrollViewHeight += 20;
    
    // 免费7天试用
    UILabel* days_free_7 = [UILabel new];
    days_free_7.textColor = RGB_HEX(0x333333);
    days_free_7.font = kSFUITextFont(15);
    days_free_7.text = NSLocalizedString(@"VIPTrailDays7", nil);
    [self.scrollView1 addSubview:days_free_7];
    [days_free_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView1).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
    }];
    [days_free_7 sizeToFit];
    self.scrollViewHeight += days_free_7.mj_h;
    
    // 然后2.99每年
    self.priceLabel = [UILabel new];
    self.priceLabel.textColor = RGB_HEX(0xAAAAAA);
    self.priceLabel.font = kSFUITextFont(12);
    [self.scrollView1 addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView1).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
    }];
    [UIUtils showThenBillingPerYear:self.priceLabel];
    [self.priceLabel sizeToFit];
    
    self.scrollViewHeight += self.priceLabel.mj_h + 12;

    
    // 连接包月按钮
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMonth setBackgroundImage:[UIImage imageNamed:@"home_premium"] forState:UIControlStateNormal];
    [self.scrollView1 addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = kSFUIDisplayFont(20);
    buttonMonthLabel.textColor = [UIColor whiteColor];
    buttonMonthLabel.text = NSLocalizedString(@"Feature_Button_Next", nil);
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
    [self.scrollView1 addSubview:restoreButton];
    [restoreButton addTarget:self action:@selector(restoreAction) forControlEvents:UIControlEventTouchUpInside];
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.scrollViewHeight));
        make.centerX.equalTo(self.scrollView1);
        make.width.equalTo(@(50));
        make.height.equalTo(@(35));
    }];
    
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"VIPRestore", nil);
    label.font          = kSFUITextFont(12);
    label.textColor     = RGB_HEX(0xCCCCCC);
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

// note
- (void) setupNote {
    
    self.scrollViewHeight += 30;
    
    CGFloat maxWidth = MIN(kScreenWidth, kScreenHeight);
    UILabel* label = [UILabel new];
    [self.scrollView1 addSubview:label];
    [UIUtils showNote:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView1).offset(self.scrollViewHeight + 20);
        make.centerX.equalTo(self.scrollView1);
        make.width.equalTo(@(maxWidth - 80));
    }];
    
    NSDictionary *attr = @{NSFontAttributeName:label.font};
    CGRect rect = [label.attributedText.string boundingRectWithSize:CGSizeMake(maxWidth - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    self.scrollViewHeight += rect.size.height + 20;
    
    [self setupAgreement];
}

// Agreement
- (void) setupAgreement {
    
    // 按钮高度
    CGFloat height = 20;
    
    //用户协议
    UIButton* userAgreementButton = [UIButton new];
    [userAgreementButton addTarget:self action:@selector(onUserAgreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:userAgreementButton];
    [userAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView1).offset(self.scrollViewHeight + 20);
        make.centerX.equalTo(self.scrollView1);
        make.width.equalTo(@(200));
        make.height.equalTo(@(height));
    }];
    UILabel* label2 = [UILabel new];
    label2.textColor = RGB(49, 187, 242);
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = NSLocalizedString(@"VIPUserAgreement", nil);
    [userAgreementButton addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(userAgreementButton);
    }];
    
    //隐私政策
    UIButton* privacyButton = [UIButton new];
    [privacyButton addTarget:self action:@selector(onPrivacyAgreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:privacyButton];
    [privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userAgreementButton.mas_bottom);
        make.centerX.equalTo(self.scrollView1);
        make.width.equalTo(@(200));
        make.height.equalTo(@(height));
    }];
    UILabel* label3 = [UILabel new];
    label3.textColor = RGB(49, 187, 242);
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = NSLocalizedString(@"VIPPrivatePolicy", nil);
    [privacyButton addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(privacyButton);
    }];
    
    self.scrollViewHeight += (66 + 24 + [QDSizeUtils is_tabBarHeight]);
}

# pragma mark - actions
- (void) loginAction {
    UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    QDLoginViewController* vc = [QDLoginViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
//    vc.callback = ^{
//        if (self.callback) self.callback();
//        [self removeFromSuperview];
//    };
    // TODO: 
    [rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void) restoreAction {
    [QDTrackManager track_button:QDTrackButtonType_2];
    
    [QDReceiptManager.shared restore:^(BOOL success) {
        NSLog(@"success = %d", success);
        if (success) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VIPRestoreSuccess", nil)];
            [self hideGuidView];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VIPRestoreFail", nil)];
        }
    }];
}

- (void) onSubscriptionAgreementButtonClick {
    [self doAgreementAction:@"VIPSubscribeAgreement" url:SUBSCRIBE_AGREEMENT_URL];
}
- (void) onUserAgreementButtonClick {
    [QDTrackManager track_button:QDTrackButtonType_4];
    [self doAgreementAction:@"VIPUserAgreement" url:USER_AGREEMENT_URL];
}

- (void) onPrivacyAgreementButtonClick {
    [QDTrackManager track_button:QDTrackButtonType_5];
    [self doAgreementAction:@"VIPPrivatePolicy" url:PRIVATE_POLICY_URL];
}

- (void) doAgreementAction:(NSString*)title url:(NSString*)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}


- (void) updateNextButtonText {
    BOOL isLastPage = self.pageControl.currentPage == self.pageControl.numberOfPages - 1;
    self.nextLabel.text = @"Next";
//    if (isLastPage) {
//        self.nextLabel.text = @"Enjoy";
//    }
//    [self.pageControl setHidden:isLastPage];
    [self.freeEnterButton setHidden:!isLastPage];
}

-(void)hideGuidView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.callback) self.callback();
        [self removeFromSuperview];
    }];
}

-(BOOL)isScrolltoLeft:(UIScrollView *)scrollView
{
    return [scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0;
}

#pragma mark - Class Method

+ (instancetype)showGuide:(GuideFinishCallback)callback {
    QDGuideView *guideView = [QDGuideView new];
    guideView.callback = callback;
    return guideView;
}

#pragma mark - Response Event
- (void)enterAction {
    
    [QDTrackManager track_button:QDTrackButtonType_1];
    
    BOOL isLastPage = self.pageControl.currentPage == self.pageControl.numberOfPages - 1;
    if (isLastPage) {
        [QDReceiptManager.shared transaction_new:Year_Subscribe_Name completion:^(BOOL success){
            if(QDVersionManager.shared.versionConfig&&[QDVersionManager.shared.versionConfig[@"guide_induce_pay"] intValue]) {
                if (success) [self hideGuidView];
            } else {
                [self hideGuidView];
            }
        }];
        return;
    }
    
    self.pageControl.currentPage += 1;
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*kScreenWidth, 0)];
}

- (void)enterFreeAction {
    [QDTrackManager track_button:QDTrackButtonType_3];
    [self hideGuidView];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    if (cuttentIndex == self.features.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            return;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenWidth/2)/kScreenWidth;
    self.pageControl.currentPage = cuttentIndex;
    [self updateNextButtonText];
}

#pragma mark - KVO

- (void)registerForKVO {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserActive) name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyUserLoginSuccess) name:kNotificationUserLoginSuccess object:nil];
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLoginSuccess object:nil];
    
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

-(void)notifyUserActive {
//    [self.loginButton setHidden: QDConfigManager.shared.UID == -1];
    [self.loginButton setHidden: YES];
}

-(void)notifyUserLoginSuccess {
    if (self.callback) self.callback();
    [self removeFromSuperview];
}

- (NSArray *)observableKeypaths
{
    return @[@"pageControlCurrentColor",
             @"pageControlNomalColor",
             @"pageControlHidden"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"pageControlCurrentColor"]) {
        self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentColor;
    } else if ([keyPath isEqualToString:@"pageControlNomalColor"]) {
        self.pageControl.pageIndicatorTintColor = self.pageControlNomalColor;
    } else if ([keyPath isEqualToString:@"pageControlHidden"]) {
        self.pageControl.hidden = self.pageControlHidden;
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIScrollView *)scrollView1
{
    if (!_scrollView1) {
        _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView1.showsVerticalScrollIndicator = NO;
        _scrollView1.bounces = NO;
    }
    return _scrollView1;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.defersCurrentPageDisplay = YES;
    }
    return _pageControl;
}

@end
