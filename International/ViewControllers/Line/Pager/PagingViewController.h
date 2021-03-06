//
//  OCExampleViewController.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "PagingViewTableHeaderView.h"
#import "ListViewController.h"
#import "JXCategoryTitleView.h"

static const CGFloat JXTableHeaderViewHeight = 0.01;
static const CGFloat JXheightForHeaderInSection = 40;

@interface PagingViewController : UIViewController <JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIView * sectionHeaderView;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL showSegment;
- (JXPagerView *)preferredPagingView;

@end
