//
//  QDConnectTipView.m
//  International
//
//  Created by hzg on 2021/7/15.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDConnectTipView.h"

@interface QDConnectTipView()

@property(nonatomic, strong) UILabel* tipLabel;
@property(nonatomic, strong) NSArray* array;
@property(nonatomic, assign) int index;
@property(nonatomic, assign) BOOL stopping;

@end

@implementation QDConnectTipView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.stopping = NO;
    self.array = @[NSLocalizedString(@"Connect_Tip1", nil),NSLocalizedString(@"Connect_Tip2", nil),NSLocalizedString(@"Connect_Tip3", nil)];
    self.tipLabel = [UILabel new];
    self.tipLabel.font = [UIFont systemFontOfSize:10];
    self.tipLabel.textColor = [UIColor colorWithRed:0.00 green:0.83 blue:0.94 alpha:1.00];
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void) show {
    self.stopping = NO;
    self.index = 0;
    [self showNext];
}

- (void) stop {
    self.stopping = YES;
}

- (void) showSuccess {
    self.stopping = YES;
    self.tipLabel.text = NSLocalizedString(@"Connected", nil);
    self.tipLabel.alpha = 1;
    [UIView animateWithDuration:2 animations:^{
        self.tipLabel.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void) showNext {
    if (self.stopping || self.index > self.array.count - 1) {
        return;
    }
    self.tipLabel.text = self.array[self.index++];
    self.tipLabel.alpha = 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            self.tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            if (!self.stopping) [self showNext];
        }];
    });
    
}

@end
