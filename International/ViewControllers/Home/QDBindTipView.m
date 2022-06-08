//
//  QDBindTipView.m
//  International
//
//  Created by hzg on 2021/9/17.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDBindTipView.h"
#import "YJAnimateUtils.h"
#import "QDSizeUtils.h"

@interface QDBindTipView()

@property(nonatomic, strong) UILabel* label;

@end

@implementation QDBindTipView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // color
    self.backgroundColor = RGB(53, 250, 251);
    
    // label1
    self.label = [UILabel new];
    self.label.font = [UIFont boldSystemFontOfSize:16];
    self.label.textColor = RGB_HEX(0x1e40a3);
    self.label.text = NSLocalizedString(@"Associate_Email_Reward", nil);
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.label sizeToFit];
    
    // icon
    UIImageView* icon1 = [UIImageView new];
    icon1.image = [UIImage imageNamed:@"icon_bind"];
    [self addSubview:icon1];
    CGFloat tx = -(self.label.mj_w/2) - 16;
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(-6);
        make.centerY.equalTo(self);
    }];
    CGPoint startPoint = CGPointMake(self.frame.size.width/2 + tx, self.frame.size.height/2);
    [icon1.layer addAnimation:[YJAnimateUtils translateAnimationForever:startPoint endPoint:CGPointMake(startPoint.x + 6, startPoint.y)] forKey:@"tanslateAnimation"];
}

- (void) updateView {
    NSString* text = NSLocalizedString(@"Associate_Email", nil);
    if (!QDActivityManager.shared.activityResultModel.isBindEmail) {
        text = NSLocalizedString(@"Associate_Email_Reward", nil);
    }
    self.label.text = text;
    [self.label sizeToFit];
}

@end
