//
//  QDConnectedRateView.m
//  International
//
//  Created by hzg on 2021/7/14.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDConnectedRateView.h"

static int RateViewStartTag = 100;

@interface QDConnectedRateView()

@property(nonatomic, strong) NSMutableArray* rateViewArray;
@property(nonatomic, strong) UIView* rateView;

@end

@implementation QDConnectedRateView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    [self setupConnectTip];
    [self setupConnectRate];
}

- (void) setupConnectTip {
    UILabel* label = [UILabel new];
    label.text = NSLocalizedString(@"NativeAd_Connected", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:21.0f];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
    }];
}

- (void) setupConnectRate {
    
    // view
    UIView* view = [UIView new];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.equalTo(@(40));
    }];
    
    // label
    UILabel* label = [UILabel new];
    label.text = NSLocalizedString(@"NativeAd_Connected_Rate", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(20);
        make.centerY.equalTo(view);
    }];
    
    // rate
    self.rateViewArray = [NSMutableArray new];
    CGFloat rateW = 30;
    CGFloat right = -rateW*4 - 20;
    for (int i = 0; i < 5; i++) {
        UIView* imageView = [UIView new];
        imageView.tag = RateViewStartTag + i;
        [view addSubview:imageView];
        
        UIImageView* icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"rate_nor"];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageView);
        }];
        [self.rateViewArray addObject:icon];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRateTap:)];
        [imageView addGestureRecognizer:singleTap];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(rateW));
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(right);
        }];
        right += rateW;
    }
    
    self.rateView = view;
}

- (void)onRateTap:(UIGestureRecognizer *)gestureRecognizer {
    self.userInteractionEnabled = NO;
    long index = gestureRecognizer.view.tag - RateViewStartTag;
    for (long i = 0; i <= index; i++) {
        UIImageView* imageView = self.rateViewArray[i];
        imageView.image = [UIImage imageNamed:@"rate_down"];
    }
    
    // 节点评分
    [QDTrackManager track_rate_node:QDConfigManager.shared.node.name rate:(int)(index+1)];
    
    // 停留2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void) hide {
    self.rateView.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.rateView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.rateView removeFromSuperview];
    }];
}

@end
