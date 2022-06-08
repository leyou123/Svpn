//
//  QDPayViewController.m
//  International
//
//  Created by hzg on 2021/6/28.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDPayViewController.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"
#import "QDSizeUtils.h"

@interface QDPayViewController ()

@property (nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void) setup {
    
    // back
    self.view.backgroundColor = [UIColor whiteColor];
    
    // scrollview
    [self setupScrollView];
    
    // close button
    UIButton* cancelButton = [UIButton new];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
        make.top.equalTo(@([QDSizeUtils navigationHeight]));
        make.left.equalTo(@(12));
    }];
    
    UIImageView* cancelIcon = [UIImageView new];
    cancelIcon.image = [[UIImage imageNamed:@"vip_premium_feature_close"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cancelIcon.tintColor = [UIColor blackColor];
    [cancelButton addSubview:cancelIcon];
    [cancelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cancelButton);
    }];
    
    // banner
    [self setupBanner];
}

- (void) setupBanner {
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

// scrollview
- (void) setupScrollView {
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.leading.bottom.equalTo(self.view);
    }];
        
    // baisc&premium
    [self setupBasic];
    [self setupPremium];
    
    // buttons
    [self setupPayButtons];
    
    // note
    [self setupNote];
    
    // scrollView
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.scrollViewHeight)];
}

- (void) setupBasic {
    self.scrollViewHeight = [QDSizeUtils navigationHeight] + 44;
    
    CGFloat cardHeight = 150;
    UIImageView* back = [UIImageView new];
    [self.scrollView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(@(self.scrollViewHeight));
        make.width.equalTo(@(375));
        make.height.equalTo(@(cardHeight));
    }];
    
    CGFloat top = 0;
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Basic", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = RGBA(0, 0, 0, 0.5);
    [back addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(back);
        make.top.equalTo(@(top));
    }];
    [titleLabel sizeToFit];
    top += (titleLabel.mj_h + 20);
    
    NSArray* featureArray = @[
        NSLocalizedString(@"BasicFeature0", nil),
        NSLocalizedString(@"BasicFeature1", nil),
        NSLocalizedString(@"BasicFeature2", nil),
        NSLocalizedString(@"BasicFeature3", nil)
    ];
    
    for (NSString* featureStr in featureArray) {
        UILabel* label = [UILabel new];
        label.text = featureStr;
        label.textColor = RGBA(0, 0, 0, 0.6);
        label.font = [UIFont systemFontOfSize:13];
        [back addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(top));
            make.centerX.equalTo(back);
        }];
        top += (label.mj_h + 5);
    }
    self.scrollViewHeight += cardHeight;
}

- (void) setupPremium {

    CGFloat cardHeight = 229;
    UIImageView* back = [UIImageView new];
    back.contentMode = UIViewContentModeScaleToFill;
    UIImage* image = [UIImage imageNamed:@"vip_premium_feature_bk"];
    back.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [self.scrollView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(@(self.scrollViewHeight));
        make.width.equalTo(@([QDSizeUtils is_width]));
        make.height.equalTo(@(cardHeight));
    }];
    
    CGFloat top = 34;
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = NSLocalizedString(@"Premium", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = RGBA(0, 0, 0, 1);
    [back addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(back);
        make.top.equalTo(@(top));
    }];
    [titleLabel sizeToFit];
    top += (titleLabel.mj_h + 20);
    
    NSArray* featureArray = @[
        NSLocalizedString(@"PremiumFeature0", nil),
        NSLocalizedString(@"PremiumFeature1", nil),
        NSLocalizedString(@"PremiumFeature2", nil),
        NSLocalizedString(@"PremiumFeature3", nil),
    ];
    
    for (NSString* featureStr in featureArray) {
        UILabel* label = [UILabel new];
        label.text = featureStr;
        label.textColor = RGBA(0, 0, 0, 1);
        label.font = [UIFont systemFontOfSize:13];
        [back addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(top));
            make.centerX.equalTo(back);
        }];
        top += (label.mj_h + 5);
    }
    self.scrollViewHeight += cardHeight;
}

- (void) setupPayButtons {
    
    if (!QDConfigManager.shared.activeModel.subscription) {
        [self setupPayMonth];
    } else {
        
        // VIP与非VIP
        if (QDConfigManager.shared.activeModel.member_type != 1) {
            [self setupPayMonthAndYear];
        } else {
            if ([QDConfigManager.shared.activeModel.set_meal isEqual:Month_Subscribe_Name]) {
//                [self setupPayQuarterAndYear];
                [self setupPayYear];
            } else if ([QDConfigManager.shared.activeModel.set_meal isEqual:Quarter_Subscribe_Name]) {
                // 季度
//                [self setupPayHalfAndYear];
                [self setupPayYear];
            } else if ([QDConfigManager.shared.activeModel.set_meal isEqual:HalfYear_Subscribe_Name]) {
                // 半年
                [self setupPayYear];
            } else if ([QDConfigManager.shared.activeModel.set_meal isEqual:Year_Subscribe_Name]) {
                // 年度
                [self setupOk];
            }
        }
    }
    
    // restore button
    [self setupRestoreButton];
}

// 新订阅引导
- (void) setupPayMonth {
    
    self.scrollViewHeight += 20;
    BOOL show_guide = [QDVersionManager.shared.versionConfig[@"show_guide"] intValue] == 1;
    
    // 免费7天试用
    UILabel* days_free_7 = [UILabel new];
    if (show_guide) {
        days_free_7.textColor = [UIColor blackColor];
        days_free_7.font = [UIFont systemFontOfSize:14];
    } else {
        days_free_7.textColor = RGB(141, 141, 141);
        days_free_7.font = [UIFont systemFontOfSize:12];
    }
    days_free_7.text = NSLocalizedString(@"VIPTrailDays7", nil);
    [self.scrollView addSubview:days_free_7];
    [days_free_7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
    }];
    [days_free_7 sizeToFit];
    self.scrollViewHeight += days_free_7.mj_h;
    
    // 然后2.99每月
    UILabel* priceLabel = [UILabel new];
    if (show_guide) {
        priceLabel.textColor = RGB(141, 141, 141);
        priceLabel.font = [UIFont systemFontOfSize:12];
    } else {
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
    }
    [self.scrollView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
    }];
    [UIUtils showThenBillingPerMonth:priceLabel];
    [priceLabel sizeToFit];
    
    
    
    self.scrollViewHeight += priceLabel.mj_h + 5;

    // 连接包月按钮
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMonth.backgroundColor = RGB_HEX(0x3e9efa);
    buttonMonth.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(monthSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonMonthLabel.textColor = [UIColor whiteColor];
    buttonMonthLabel.text = NSLocalizedString(@"Feature_Button_Subscribe", nil);
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonMonth);
    }];
    
    self.scrollViewHeight += buttonHeight;
}

// 非VIP推荐月度和年度
- (void) setupPayMonthAndYear {
    self.scrollViewHeight += 20;
    
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMonth.backgroundColor = RGB_HEX(0x3e9efa);
    buttonMonth.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(monthSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonMonthLabel.textColor = [UIColor whiteColor];
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonMonth);
    }];
    [UIUtils showMoney:buttonMonthLabel subcribePrice:Month_Subscribe_Price subcribeName:Month_Subscribe_Name format:NSLocalizedString(@"VIPPrice2", nil)];
    
    self.scrollViewHeight += (buttonHeight + 20);
    
    UIButton* buttonYear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonYear.backgroundColor = RGB_HEX(0x3e9efa);
    buttonYear.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(yearSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonYearLabel = [UILabel new];
    buttonYearLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonYearLabel.textColor = [UIColor whiteColor];
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonYear);
    }];
    [UIUtils showMoney:buttonYearLabel subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name format:NSLocalizedString(@"VIPPrice3", nil)];
    
    UILabel* saveMoneyLabel = [UILabel new];
    saveMoneyLabel.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel];
    [saveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonYear.mas_bottom).offset(5);
        make.centerX.equalTo(buttonYear);
    }];
    [UIUtils showSaveMoneyWithYearDetail:saveMoneyLabel];
    
    self.scrollViewHeight += buttonHeight;
}

// VIP推荐季度与年度
- (void) setupPayQuarterAndYear {
    self.scrollViewHeight += 20;
    
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMonth.backgroundColor = RGB_HEX(0x3e9efa);
    buttonMonth.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(quarterSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonMonthLabel.textColor = [UIColor whiteColor];
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonMonth);
    }];
    [UIUtils showMoney:buttonMonthLabel subcribePrice:Quarter_Subscribe_Price subcribeName:Quarter_Subscribe_Name format:NSLocalizedString(@"VIPPrice21", nil)];
    
    UILabel* saveMoneyLabel0 = [UILabel new];
    saveMoneyLabel0.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel0.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel0];
    [saveMoneyLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonMonth.mas_bottom).offset(5);
        make.centerX.equalTo(buttonMonth);
    }];
    [UIUtils showSaveMoneyWithQuarterDetail:saveMoneyLabel0];
    
    self.scrollViewHeight += (buttonHeight + 40);
    
    UIButton* buttonYear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonYear.backgroundColor = RGB_HEX(0x3e9efa);
    buttonYear.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(yearSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonYearLabel = [UILabel new];
    buttonYearLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonYearLabel.textColor = [UIColor whiteColor];
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonYear);
    }];
    [UIUtils showMoney:buttonYearLabel subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name format:NSLocalizedString(@"VIPPrice3", nil)];
    
    UILabel* saveMoneyLabel = [UILabel new];
    saveMoneyLabel.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel];
    [saveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonYear.mas_bottom).offset(5);
        make.centerX.equalTo(buttonYear);
    }];
    [UIUtils showSaveMoneyWithYearDetail:saveMoneyLabel];
    
    self.scrollViewHeight += buttonHeight;
}

// VIP推荐半年与年度
- (void) setupPayHalfAndYear {
    self.scrollViewHeight += 20;
    
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMonth.backgroundColor = RGB_HEX(0x3e9efa);
    buttonMonth.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(halfYearSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonMonthLabel.textColor = [UIColor whiteColor];
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonMonth);
    }];
    [UIUtils showMoney:buttonMonthLabel subcribePrice:HalfYear_Subscribe_Price subcribeName:HalfYear_Subscribe_Name format:NSLocalizedString(@"VIPPrice22", nil)];
    
    UILabel* saveMoneyLabel0 = [UILabel new];
    saveMoneyLabel0.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel0.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel0];
    [saveMoneyLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonMonth.mas_bottom).offset(5);
        make.centerX.equalTo(buttonMonth);
    }];
    [UIUtils showSaveMoneyWithHalfYearDetail:saveMoneyLabel0];
    
    self.scrollViewHeight += (buttonHeight + 40);
    
    UIButton* buttonYear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonYear.backgroundColor = RGB_HEX(0x3e9efa);
    buttonYear.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(yearSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonYearLabel = [UILabel new];
    buttonYearLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonYearLabel.textColor = [UIColor whiteColor];
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonYear);
    }];
    [UIUtils showMoney:buttonYearLabel subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name format:NSLocalizedString(@"VIPPrice3", nil)];
    
    UILabel* saveMoneyLabel = [UILabel new];
    saveMoneyLabel.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel];
    [saveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonYear.mas_bottom).offset(5);
        make.centerX.equalTo(buttonYear);
    }];
    [UIUtils showSaveMoneyWithYearDetail:saveMoneyLabel];
    
    self.scrollViewHeight += buttonHeight;
}

// VIP推荐年度
- (void) setupPayYear {
    self.scrollViewHeight += 20;
    
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* buttonYear = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonYear.backgroundColor = RGB_HEX(0x3e9efa);
    buttonYear.layer.cornerRadius = 6;
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(yearSubcribeAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* buttonYearLabel = [UILabel new];
    buttonYearLabel.font = [UIFont boldSystemFontOfSize:18];
    buttonYearLabel.textColor = [UIColor whiteColor];
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonYear);
    }];
    [UIUtils showMoney:buttonYearLabel subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name format:NSLocalizedString(@"VIPPrice3", nil)];
    
    UILabel* saveMoneyLabel = [UILabel new];
    saveMoneyLabel.font = [UIFont systemFontOfSize:12];
    saveMoneyLabel.textColor = RGB_HEX(0x3e9efa);
    [self.scrollView addSubview:saveMoneyLabel];
    [saveMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonYear.mas_bottom).offset(5);
        make.centerX.equalTo(buttonYear);
    }];
    [UIUtils showSaveMoneyWithYearDetail:saveMoneyLabel];
    
    self.scrollViewHeight += buttonHeight;
}

// 无推荐界面 点击关闭界面
- (void) setupOk {
    self.scrollViewHeight += 20;
    
    // ok button
    CGFloat buttonHeight = 40, buttonWidth = 200;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGB_HEX(0x3e9efa);
    button.layer.cornerRadius = 6;
    [self.scrollView addSubview:button];
    [button addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Feature_Button_Ok", nil);
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
    }];
    
    self.scrollViewHeight += buttonHeight;
}

- (void) setupRestoreButton {
    
    self.scrollViewHeight += 20;
    
    // restore button
    UIButton* restoreButton = [UIButton new];
    [self.scrollView addSubview:restoreButton];
    [restoreButton addTarget:self action:@selector(restoreAction) forControlEvents:UIControlEventTouchUpInside];
    [restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.scrollViewHeight));
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(50));
        make.height.equalTo(@(35));
    }];
    
    UILabel* label      = [UILabel new];
    label.text          = NSLocalizedString(@"VIPRestore", nil);
    label.font          = [UIFont systemFontOfSize:12];
    label.textColor     = RGB_HEX(0xb3b3b3);
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
    
    CGFloat maxWidth = [QDSizeUtils is_width];
    UILabel* label = [UILabel new];
    [self.scrollView addSubview:label];
    [UIUtils showNote:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight + 20);
        make.centerX.equalTo(self.scrollView);
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
    [self.scrollView addSubview:userAgreementButton];
    [userAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight + 20);
        make.centerX.equalTo(self.scrollView);
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
    [self.scrollView addSubview:privacyButton];
    [privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userAgreementButton.mas_bottom);
        make.centerX.equalTo(self.scrollView);
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
- (void) restoreAction {
    [QDTrackManager track_button:QDTrackButtonType_24];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"VIPRestoreStart", nil)];
    [QDReceiptManager.shared restore:^(BOOL success) {
        NSLog(@"success = %d", success);

        if (success) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VIPRestoreSuccess", nil)];
        } else {
            NSString* getPremium = NSLocalizedString(@"VIPPromotionText2", nil);
            NSString* retry  = NSLocalizedString(@"Dialog_Retry", nil);
            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogManager showItemsDialog:self title:NSLocalizedString(@"VIPRestoreFail", nil) message:NSLocalizedString(@"VIPRestoreFailDesc", nil) actionItems:@[getPremium, retry, cancel] callback:^(NSString *itemName) {
                if ([itemName isEqual:getPremium]) {
                    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success) {
                    }];
                    return;
                }
                
                if ([itemName isEqual:retry]) {
                    [self restoreAction];
                    return;
                }
            }];
        }
    }];
}

- (void) monthSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_19];
    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success){
        if (success) [self cancelAction];
    }];
}

- (void) quarterSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_20];
    [QDReceiptManager.shared transaction_new:Quarter_Subscribe_Name completion:^(BOOL success){
        if (success) [self cancelAction];
    }];
}

- (void) halfYearSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_21];
    [QDReceiptManager.shared transaction_new:HalfYear_Subscribe_Name completion:^(BOOL success){
        if (success) [self cancelAction];
    }];
}

- (void) yearSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_22];
    [QDReceiptManager.shared transaction_new:Year_Subscribe_Name completion:^(BOOL success){
        if (success) [self cancelAction];
    }];
}

- (void) okAction {
    [QDTrackManager track_button:QDTrackButtonType_23];
    [self cancelAction];
}

- (void) cancelAction {
    [QDTrackManager track_button:QDTrackButtonType_27];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSubscriptionAgreementButtonClick {
    [self doAgreementAction:@"VIPSubscribeAgreement" url:SUBSCRIBE_AGREEMENT_URL];
}
- (void) onUserAgreementButtonClick {
    [QDTrackManager track_button:QDTrackButtonType_25];
    [self doAgreementAction:@"VIPUserAgreement" url:USER_AGREEMENT_URL];
}

- (void) onPrivacyAgreementButtonClick {
    [QDTrackManager track_button:QDTrackButtonType_26];
    [self doAgreementAction:@"VIPPrivatePolicy" url:PRIVATE_POLICY_URL];
}

- (void) doAgreementAction:(NSString*)title url:(NSString*)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

@end
