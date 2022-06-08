//
//  RefreshViewController2.m
//  International
//
//  Created by LC on 2022/4/21.
//  Copyright © 2022 com. All rights reserved.
//

#import "RefreshViewController2.h"
#import "QDRefreshNormalHeader.h"
#import "QDPayButtonView.h"
#import "QDSizeUtils.h"
#import "UIImage+Utils.h"
#import "QDNodesResultModel.h"

@interface RefreshViewController2 ()
@property (nonatomic, assign) BOOL isHeaderRefreshed;
@property (nonatomic, strong) QDPayButtonView *payButtonView;
@end


@implementation RefreshViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void) setup {
    [self setupPageView];
    [self setupTop];
    [self setPayButton];
    [self setupBanner];
}

- (void) setupPageView {
    
    // pageview
    self.isNeedHeader = NO;
    self.isNeedFooter = NO;
    self.showSegment = NO;
    __weak typeof(self)weakSelf = self;
    self.pagerView.mainTableView.mj_header = [QDRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestNodes];
    }];
    
//    if (!QDConfigManager.shared.nodes || QDConfigManager.shared.nodes.count == 0) {
        [self.pagerView.mainTableView.mj_header beginRefreshing];
//    }
    
    // page
    self.categoryView.titles = @[NSLocalizedString(@"Premium", nil)];
    
    self.sectionHeaderView = nil;
    
    int page = 0;
    if (QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1) {
        page = 1;
    }
    self.pagerView.defaultSelectedIndex = page;
    [self.categoryView setDefaultSelectedIndex:page];
    
    // data
    [self reloadTableViewData];
}

- (void) setupTop {
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        appearance.shadowColor = [UIColor whiteColor];
        appearance.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
    } else {
        //导航栏
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView* backImage = [UIImageView new];
    backImage.image = [UIImage imageNamed:@"line_nav_back"];
//    backImage.tintColor = [UIColor whiteColor];
    [button addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIButton* refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-44, 0, 44, 44)];
    UIImageView* refreshImage = [UIImageView new];
    refreshImage.image = [UIImage imageNamed:@"line_refresh"];
//    refreshImage.tintColor = [UIColor whiteColor];
    [refreshBtn addSubview:refreshImage];
    [refreshImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(refreshBtn);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshBtn];
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = NSLocalizedString(@"LinePremium", nil);  //设置标题
    self.navigationItem.titleView = titleLabel;

}

- (void) setPayButton {
    BOOL isVIP = QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.member_type == 1;
    BOOL isAnnualMeal = [QDConfigManager.shared.activeModel.set_meal isEqualToString:Year_Subscribe_Name];
    if (isVIP&isAnnualMeal) return;
    
    [self.view addSubview:self.payButtonView];
    [self.payButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(240, 50));
        CGFloat toBottom = [QDSizeUtils isIphoneX] ? 34 : 0;
        toBottom += 60;
        make.bottom.equalTo(self.view).offset(-toBottom);
        
    }];
    [self.payButtonView updateText];
}

- (void) setupBanner {
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
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
        [self reloadTableViewData];
        [self.pagerView.mainTableView.mj_header endRefreshing];
    }];
}

- (void) reloadTableViewData {
    self.isHeaderRefreshed = YES;
    [self.categoryView reloadData];
    [self.pagerView reloadData];
}

- (QDPayButtonView*)payButtonView {
    if (!_payButtonView) {
        _payButtonView = [QDPayButtonView new];
        _payButtonView.backgroundColor = [UIColor clearColor];
        if (QDConfigManager.shared.activeModel.member_type == 1) {
            _payButtonView.hidden = YES;
        }else {
            _payButtonView.hidden = NO;
        }
    }
    return _payButtonView;
}

// close action
- (void) dismissAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshAction {
    [self.pagerView.mainTableView.mj_header beginRefreshing];
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (!self.isHeaderRefreshed) {
        return [super pagerView:pagerView initListAtIndex:index];
    }
    ListViewController *listView = [[ListViewController alloc] init];
    listView.isNeedHeader = self.isNeedHeader;
    listView.isNeedFooter = self.isNeedFooter;
    listView.tableViewProxy.dataArray = QDConfigManager.shared.vipNodes.mutableCopy;
    return listView;
}


@end
