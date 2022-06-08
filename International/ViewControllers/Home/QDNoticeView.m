//
//  QDNoticeView.m
//  International
//
//  Created by hzg on 2021/8/24.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDNoticeView.h"

#define ROW_H  self.bounds.size.height

@interface QDNoticeView()

/// scrollView
@property (nonatomic, strong) UIScrollView *bgScrollView;
/// titleArr
@property (nonatomic, copy) NSArray *titleArr;
/// timer
@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation QDNoticeView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = [text componentsSeparatedByString:@";"];
        [self addSubview:self.bgScrollView];
        [self createBaseView];
        [self openTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = titles;
        [self addSubview:self.bgScrollView];
        [self createBaseView];
        [self openTimer];
    }
    return self;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _bgScrollView.scrollEnabled = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.backgroundColor = UIColor.whiteColor;
        _bgScrollView.userInteractionEnabled = NO;
    }
    return _bgScrollView;
}
 
// MARK: - 创建所有视图
- (void)createBaseView {
    
    // 安全判断
    if (self.titleArr.count == 0) {
      return;
    }
    UIButton* button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [button addTarget:self action:@selector(onNoticeTap) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(onNoticeTapCancel) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(onNoticeTapCancel) forControlEvents:UIControlEventTouchCancel];
    
    // 为了展示滑动过程的流畅性，重新处理数组
    NSMutableArray *dataMArray = [NSMutableArray arrayWithCapacity:0];
    [dataMArray addObjectsFromArray:_titleArr];
    [dataMArray addObject:_titleArr.firstObject];
    for (int i = 0; i<dataMArray.count; i++) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, ROW_H*(i%dataMArray.count), self.bgScrollView.bounds.size.width - 24, ROW_H)];
      label.text = dataMArray[i];
      label.font = [UIFont systemFontOfSize:15];
      label.textColor = [UIColor blackColor];
      label.numberOfLines = 0;
      [_bgScrollView addSubview:label];
    }
    _bgScrollView.contentSize = CGSizeMake(0, ROW_H*dataMArray.count);
}

// MARK: - 点击通知
- (void) onNoticeTap {
    [self closeTimer];
}

- (void) onNoticeTapCancel {
    [self openTimer];
}

// MARK: - 开启定时器
- (void)openTimer {
    if (self.titleArr.count < 2) return;
    if (!_scrollTimer) {
      _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerMoved) userInfo:nil repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    }
}
  
// MARK: - 关闭定时器
- (void)closeTimer {
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}

// MARK: - 定时器调用方法
- (void)timerMoved {
    CGFloat pageY = self.bgScrollView.contentOffset.y/ROW_H;
    int pageIntY = pageY;
    if (pageIntY >= self.titleArr.count) {
      [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
      [self.bgScrollView setContentOffset:CGPointMake(0, (pageIntY+1)*ROW_H) animated:YES];
    }
}
  
@end
