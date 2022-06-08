//
//  OCExampleViewController.m
//  JXPagerView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "PagingViewController.h"
#import "JXCategoryView.h"
#import "ListViewController.h"
#import "QDSizeUtils.h"

@interface PagingViewController () <JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation PagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _titles = @[NSLocalizedString(@"Basic", nil),NSLocalizedString(@"Premium", nil)];

    _userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectZero];

    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(1, 1, [UIScreen mainScreen].bounds.size.width-32, JXheightForHeaderInSection-2)];
    self.categoryView.collectionView.frame = CGRectMake(15, 0, kScreenWidth-30, 0);
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor blackColor];
    self.categoryView.titleColor = RGB(153, 153, 153);
    self.categoryView.titleFont = [UIFont systemFontOfSize:14];
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = NO;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
//    UIView* bottomLineView = [UIView new];
//    bottomLineView.backgroundColor = RGB_HEX(0xcccccc);
//    bottomLineView.alpha = 0.5;
//    [self.categoryView addSubview:bottomLineView];
//    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@(20));
//        make.trailing.equalTo(@(-20));
//        make.bottom.equalTo(self.categoryView);
//        make.height.equalTo(@0.5);
//    }];
//
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
//    lineView.indicatorWidth = 30;
//    self.categoryView.indicators = @[lineView];
    
    self.categoryView.cellSpacing = 0;
//    self.categoryView.contentEdgeInsetLeft = 15;
//    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.cellWidth = CGRectGetWidth(self.categoryView.frame)/_titles.count;
    
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleSelectedFont = kSFUITextFont(17);
    
    self.categoryView.titleColor = RGB_HEX(0x27A3EF);
    self.categoryView.titleFont = kSFUITextFont(16);
    
    self.categoryView.cellBackgroundColorGradientEnabled = YES;
    self.categoryView.cellBackgroundSelectedColor = RGB_HEX(0x27A3EF);
    self.categoryView.cellBackgroundUnselectedColor = [UIColor whiteColor];
    
    _pagerView = [self preferredPagingView];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection+20)];
    UIView * categoryBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 16, [UIScreen mainScreen].bounds.size.width-30, JXheightForHeaderInSection)];
    [self.sectionHeaderView addSubview:categoryBgView];
    categoryBgView.backgroundColor = RGB_HEX(0x27A3EF);
    [categoryBgView addSubview:self.categoryView];
    
    categoryBgView.layer.cornerRadius = 20;
    categoryBgView.layer.masksToBounds = YES;
    
    self.categoryView.layer.cornerRadius = 19;
    self.categoryView.layer.masksToBounds = YES;
    
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
//    [self.pagerView.listContainerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

//    self.pagerView.frame = self.view.bounds;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    if (self.showSegment) {
        return JXheightForHeaderInSection+16;
    }else {
        return 0.00001;
    }
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
//    return self.categoryView;
    return self.sectionHeaderView;;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    ListViewController *list = [[ListViewController alloc] init];
    list.title = self.titles[index];
    list.isNeedHeader = self.isNeedHeader;
    list.isNeedFooter = self.isNeedFooter;
    return list;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    // 统计数据
    QDTrackType type = index == 0 ? QDTrackType_select_trial_tab : QDTrackType_select_vip_tab;
    [QDTrackManager track:type data:@{}];
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end


