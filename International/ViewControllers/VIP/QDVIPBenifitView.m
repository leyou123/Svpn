//
//  QDVIPBenifitView.m
//  International
//
//  Created by hzg on 2021/12/7.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDVIPBenifitView.h"
#import "QDSizeUtils.h"
#import "QDRegisterViewController.h"
#import "UIUtils.h"

@interface QDVIPBenifitView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@property (nonatomic, strong) UIImageView* stepImageImage;
@property (nonatomic, strong) UILabel* muti_subtitleLabel;

@end

@implementation QDVIPBenifitView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void) doInit {
    
    // back
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    [self setupTitle];
    [self setupScrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

# pragma mark - ui
- (void) setupTitle {
    UIView* parentView = [UIView new];
    [self addSubview:parentView];
    CGFloat height = [QDSizeUtils navigationHeight] + 44;
    [parentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(height));
    }];
    parentView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Benefits_Title", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset([QDSizeUtils navigationHeight] + 10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(25);
    }];
}

- (void) setupScrollView {
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 44));
        make.bottom.equalTo(self).offset(-[QDSizeUtils is_tabBarHeight]);
        make.left.right.equalTo(self);
    }];
    
    [self setupGeneralGuide];
    [self setupPlatformsGuide];
    [self setupStableGuide];
    [self setupSecureGuide];
    [self updateStepAndMutiSubtitleText];
    
    self.scrollViewHeight += 12;
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth, self.scrollViewHeight)];
}

- (void) setupGeneralGuide {
    self.scrollViewHeight = 20;
    self.stepImageImage = [UIImageView new];
    [self.scrollView addSubview:self.stepImageImage];
    [self.stepImageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(@(22));
    }];
    
    self.scrollViewHeight += (22+5);
    
    CGFloat x       = 108;
    CGFloat start_x = -(2*x);
    NSArray* steps = @[NSLocalizedString(@"Benefits_Step_0", nil), NSLocalizedString(@"Benefits_Step_1", nil), NSLocalizedString(@"Benefits_Step_2", nil)];
    for (NSString* step in steps) {
        UILabel* label = [UILabel new];
        label.text = step;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor blackColor];
        [self.scrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
            make.centerX.equalTo(self.scrollView).offset(start_x+x);
            make.height.equalTo(@(22));
        }];
        start_x += x;
    }
    self.scrollViewHeight += 22;
}

- (void) setupPlatformsGuide {
    self.scrollViewHeight += 10;
    
    CGFloat width  = 345;
    CGFloat height = 352;
    UIView* card = [UIView new];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 6;
    card.layer.masksToBounds = YES;
    [self.scrollView addSubview:card];
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.scrollViewHeight += height;
    
    CGFloat top = 20;
    
    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Benefits_Platform_0", nil);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [card addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    UIButton* bindButton = [UIButton new];
    [bindButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:bindButton];
    [bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card);
        make.centerX.equalTo(card);
        make.width.equalTo(@(width));
        make.height.equalTo(@(64));
    }];
    
    top += (14+10);

    self.muti_subtitleLabel = [UILabel new];
    self.muti_subtitleLabel.font = [UIFont systemFontOfSize:10];
    [card addSubview:self.muti_subtitleLabel];
    [self.muti_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    top += (10+20);
    
    UIImageView* iv = [UIImageView new];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:@"vip_benifit_muti_devices"];
    [card addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.centerX.equalTo(card);
        make.width.equalTo(@(width));
        make.height.equalTo(@(215));
    }];
    top += 215;
    
    UIButton* moreButton = [UIButton new];
    [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.centerX.equalTo(card);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height - top));
    }];
    UILabel* moreLabel = [UILabel new];
    moreLabel.text = NSLocalizedString(@"Benefits_Platform_2", nil);
    moreLabel.textColor = [UIColor blackColor];
    moreLabel.font = [UIFont systemFontOfSize:14];
    [moreButton addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreButton);
        make.left.equalTo(moreButton).offset(20);
    }];
    
    UIImageView* nextiv = [UIImageView new];
    nextiv.image = [UIImage imageNamed:@"line_next"];
    [moreButton addSubview:nextiv];
    [nextiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moreButton);
        make.right.equalTo(moreButton).offset(-20);
    }];
}

- (void) updateStepAndMutiSubtitleText {
    
    // 是否绑定邮箱
    BOOL isBindEmail = QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.email && ![QDConfigManager.shared.activeModel.email isEqual:@""];
    
    NSString* stepImageName = isBindEmail ? @"vip_benifit_step" : @"vip_benifit_step_1";
    self.stepImageImage.image = [UIImage imageNamed:stepImageName];
    
    NSString* str1 = NSLocalizedString(@"Benefits_Platform_1", nil);
    NSString* str2 = NSLocalizedString(@"Benefits_Platform_1_Format", nil);
    NSString* mutableString = [NSString stringWithFormat:str1, str2];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mutableString];
    if (!isBindEmail) {
        NSRange range = [mutableString rangeOfString:str2];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:RGB(37, 176, 247)
                        range:range];
    }
    self.muti_subtitleLabel.textColor = [UIColor blackColor];
    self.muti_subtitleLabel.attributedText = attrStr;
    self.muti_subtitleLabel.textAlignment = NSTextAlignmentLeft;
}

- (void) setupStableGuide {
    self.scrollViewHeight += 12;
    
    CGFloat width  = 345;
    CGFloat height = 321;
    UIView* card = [UIView new];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 6;
    card.layer.masksToBounds = YES;
    [self.scrollView addSubview:card];
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.scrollViewHeight += height;
    
    CGFloat top = 20;
    
    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Benefits_Line_0", nil);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [card addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    top += (14+10);
    
    UILabel* subtitleLabel = [UILabel new];
    subtitleLabel.text = NSLocalizedString(@"Benefits_Line_1", nil);
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.font = [UIFont systemFontOfSize:10];
    [card addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    top += (10+20);
    
    UIImageView* iv = [UIImageView new];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:@"vip_benifit_speed"];
    [card addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.centerX.equalTo(card);
        make.width.equalTo(@(width));
    }];
}

- (void) setupSecureGuide {
    self.scrollViewHeight += 12;
    
    CGFloat width  = 345;
    CGFloat height = 321;
    UIView* card = [UIView new];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 6;
    card.layer.masksToBounds = YES;
    [self.scrollView addSubview:card];
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.scrollViewHeight += height;
    
    CGFloat top = 20;
    
    // title
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Benefits_Privacy_0", nil);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [card addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    top += (14+10);
    
    UILabel* subtitleLabel = [UILabel new];
    subtitleLabel.text = NSLocalizedString(@"Benefits_Privacy_1", nil);
    subtitleLabel.textColor = [UIColor blackColor];
    subtitleLabel.font = [UIFont systemFontOfSize:10];
    [card addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.left.equalTo(card).offset(20);
        make.width.equalTo(@(width));
    }];
    
    top += (10+20);
    
    UIImageView* iv = [UIImageView new];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = [UIImage imageNamed:@"vip_benifit_safe"];
    [card addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(card).offset(top);
        make.centerX.equalTo(card);
        make.width.equalTo(@(width));
    }];
}

- (void) updateStatus {
    [self updateStepAndMutiSubtitleText];
}

#pragma mark -- button actions
- (void) loginAction {
    BOOL isBindEmail = QDConfigManager.shared.activeModel&&QDConfigManager.shared.activeModel.email && ![QDConfigManager.shared.activeModel.email isEqual:@""];
    if (isBindEmail) return;
    QDRegisterViewController* vc = [QDRegisterViewController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UIViewController* nav = [UIUtils getCurrentVC];
    [nav presentViewController:vc animated:YES completion:nil];
}

- (void) moreAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEBSITE_URL] options:@{} completionHandler:nil];
}

@end
