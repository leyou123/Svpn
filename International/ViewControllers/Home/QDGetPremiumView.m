//
//  QDGetPremiumView.m
//  International
//
//  Created by LC on 2022/4/20.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDGetPremiumView.h"

@interface QDGetPremiumView()

@property (nonatomic, copy) ClickActionBlock clickBlock;

@property (nonatomic, strong) UIImageView * leftIv;

@property (nonatomic, strong) UILabel * topLB;

@property (nonatomic, strong) UILabel * bottomLB;
// 1 多端登录  2 会员  3 非会员
@property (nonatomic, assign) int clickStatus;

@property (nonatomic, copy) NSString * imageName;

@property (nonatomic, copy) NSString * title;

@end

@implementation QDGetPremiumView

- (instancetype)initWithFrame:(CGRect)frame clickAction:(ClickActionBlock)block {
    self = [self initWithFrame:frame leftImage:@"" title:@"" clickAction:block];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame leftImage:(NSString *)imageName title:(NSString *)title clickAction:(ClickActionBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.clickBlock = block;
        self.imageName = imageName;
        self.title = title;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIButton * premiumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [premiumBtn setBackgroundImage:[UIImage imageNamed:@"home_premium"] forState:UIControlStateNormal];
    [premiumBtn addTarget:self action:@selector(premiumAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:premiumBtn];
    
    [premiumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self);
    }];
    
    UIImageView * leftIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    leftIv.image = [UIImage imageNamed:self.imageName];
    [premiumBtn addSubview:leftIv];
    _leftIv = leftIv;
    [leftIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(premiumBtn).offset(25);
        make.centerY.equalTo(premiumBtn);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    UIImageView * arrowIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    arrowIv.image = [UIImage imageNamed:@"home_premium_arrow"];
    [premiumBtn addSubview:arrowIv];
    [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(premiumBtn).offset(-20);
        make.centerY.equalTo(premiumBtn);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    UILabel * topLB = [[UILabel alloc] initWithFrame:CGRectZero];
    topLB.textColor = [UIColor whiteColor];
    topLB.font = kSFUITextFont(13.0);
    [premiumBtn addSubview:topLB];
    _topLB = topLB;
    
    UILabel * bottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLB.textColor = [UIColor whiteColor];
    bottomLB.font = kSFUITextFont(11.0);
    [premiumBtn addSubview:bottomLB];
    _bottomLB = bottomLB;
    
    if (self.title.length > 0) {
        topLB.font = kSFUITextFont(15.0);
        topLB.text = self.title;
        [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftIv.mas_right).offset(14);
            make.top.equalTo(premiumBtn).offset(7);
            make.right.equalTo(arrowIv.mas_left);
            make.centerY.equalTo(premiumBtn);
        }];
        self.bottomLB.hidden = YES;
    }else {
        topLB.font = kSFUITextFont(13.0);
        topLB.text = @"";
        [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftIv.mas_right).offset(14);
            make.top.equalTo(premiumBtn).offset(7);
            make.right.equalTo(arrowIv.mas_left);
            make.height.mas_equalTo(18);
        }];

        self.bottomLB.hidden = NO;
        [bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftIv.mas_right).offset(14);
            make.top.equalTo(topLB.mas_bottom).offset(0);
            make.right.equalTo(arrowIv.mas_left);
            make.height.mas_equalTo(18);
        }];
    }
}

- (void)updateStatus {
    int status = QDConfigManager.shared.activeModel.member_type;
    if (status == 1) {
        if (QDConfigManager.shared.activeModel.email.length > 0) {
            self.leftIv.image = [UIImage imageNamed:@"home_multi"];
            self.topLB.text = @"Multi terminal login";
            self.bottomLB.text = @"Android&Web&Mac";
            self.clickStatus = 1;
        }else {
            self.leftIv.image = [UIImage imageNamed:@"home_bind_mailBox"];
            self.topLB.text = @"Bind E_Mail";
            self.bottomLB.text = @"Android&Web&Mac";
            self.clickStatus = 2;
        }
    }else {
        self.leftIv.image = [UIImage imageNamed:@"home_crown"];
        self.topLB.text = @"Get Premium";
        self.bottomLB.text = @"Start 7-days free trial";
        self.clickStatus = 3;
    }
}

//    1 多端登录 2 会员未绑定 3 非会员
- (void)premiumAction:(UIButton *)btn {
    self.clickBlock(self.clickStatus);
}

@end
