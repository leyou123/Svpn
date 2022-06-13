//
//  QDPayViewController2.m
//  International
//
//  Created by LC on 2022/3/23.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDPayViewController2.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"

@interface QDPayViewController2 ()
{
    UIButton *buttonYear , *buttonMonth , *buttonWeek , *yearBtn , *monthBtn , *weekBtn;
    UIImageView *bk , *bk1 , *bk2 ,* offbk;
    NSString *typeStr;
    UILabel  *offLabel, *buttonYearLabel, *buttonYearLabel1, *yearPriceLB, *yearDurationLB, *buttonMonthLabel, *buttonMonthLabel1, *monthPriceLB, *monthDurationLB, *buttonWeekLabel, *buttonWeekLabel1, *weekPriceLB, *weekDurationLB;
}
@property (nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic, assign) CGFloat scrollViewHeight;

@property (nonatomic, strong) UILabel * contentDesLB;
@property (nonatomic, strong) UIImageView *titleIv;

@end

@implementation QDPayViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void) setup {
    
    // back
    self.view.backgroundColor = [UIColor whiteColor];
    
    typeStr = @"1";
    
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
        make.left.equalTo(@(5));
    }];
    
    UIImageView* cancelIcon = [UIImageView new];
    cancelIcon.image = [[UIImage imageNamed:@"LB_Back"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cancelIcon.tintColor = [UIColor blackColor];
    [cancelButton addSubview:cancelIcon];
    [cancelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cancelButton);
    }];
    
    // banner
    [self setupBanner];
}

-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // title
    [self setupTitle];
    
    // content
    [self setContentTitle];
    
    // form
    [self setupForm];
    
    // buttons
    [self setupPayButtons];
    
    // note
    [self setupNote];
    
    // scrollView
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.scrollViewHeight)];
}

// title
- (void) setupTitle {
    self.scrollViewHeight = [QDSizeUtils navigationHeight]+44;
//    UILabel* promationTitle = [UILabel new];
//    [_scrollView addSubview:promationTitle];
//    promationTitle.text = NSLocalizedString(@"VIPStoreTitle1", nil);
//    promationTitle.textColor = RGB_HEX(0x414fb6);
//    promationTitle.numberOfLines = 0;
//    promationTitle.textAlignment = NSTextAlignmentCenter;
//    promationTitle.font = [UIFont boldSystemFontOfSize:18];
//    [promationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(@([QDSizeUtils navigationHeight]));
//        make.width.equalTo(@(300));
//    }];
//    [promationTitle sizeToFit];

    self.titleIv = [[UIImageView alloc] init];
    self.titleIv.image = [UIImage imageNamed:@"home_crown"];
    [_scrollView addSubview:self.titleIv];
    [self.titleIv mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(3+[UIApplication sharedApplication].statusBarFrame.size.height);
        make.size.mas_equalTo(CGSizeMake(38, 38));
        
    }];
    
    self.scrollViewHeight += 38;
}

- (void)setContentTitle {
    
    self.scrollViewHeight += 73;
    
    UILabel * contentTitleLB = [[UILabel alloc] init];
    contentTitleLB.font = kSFUIDisplayFont(28);
    contentTitleLB.textColor = RGB_HEX(0x000000);
    contentTitleLB.textAlignment = NSTextAlignmentCenter;
    contentTitleLB.text = NSLocalizedString(@"VIPStoreContent_Title1", nil);
    [_scrollView addSubview:contentTitleLB];
    [contentTitleLB mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleIv.mas_bottom).offset(16);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(34);
    }];
    
    self.contentDesLB = [[UILabel alloc] init];
    self.contentDesLB.font = kSFUITextFont(13);
    self.contentDesLB.textColor = RGB_HEX(0x000000);
    self.contentDesLB.textAlignment = NSTextAlignmentCenter;
    self.contentDesLB.text = NSLocalizedString(@"VIPStoreContent_Desc1", nil);
    [_scrollView addSubview:self.contentDesLB];
    [self.contentDesLB mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(contentTitleLB.mas_bottom).offset(4);
        make.width.equalTo(self.view);
    }];
}

// form
- (void) setupForm {
    self.scrollViewHeight += 0;
    
    UIImageView* formImageView = [UIImageView new];
    formImageView.image = [UIImage imageNamed:@"组 61"];
    [_scrollView addSubview:formImageView];
    [formImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerX.equalTo(self.view);
        make.top.equalTo(self.contentDesLB.mas_bottom).offset(12);
        make.height.mas_equalTo(184*kScreenScale);
    }];
    [formImageView sizeToFit];
    
//    self.scrollViewHeight += formImageView.mj_h;
    self.scrollViewHeight += 184*kScreenScale;
}

- (void) setupPayButtons {
    
    [self setupPayMonthAndYear];
    
    // restore button
    [self setupRestoreButton];
}

// 非VIP推荐月度和年度
- (void) setupPayMonthAndYear {
    self.scrollViewHeight += 20;
    CGFloat stautsHeight = 40;

    CGFloat buttonHeight = 80, buttonWidth = 345;
    
    buttonYear = [UIButton new];
    buttonYear.tag = 0;
    buttonYear.backgroundColor = RGB_HEX(0x27A3EF);
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight-stautsHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    buttonYear.layer.cornerRadius = 12.0;
    buttonYear.layer.masksToBounds = YES;
    buttonYear.layer.borderColor = RGB_HEX(0x27A3EF).CGColor;
    buttonYear.layer.borderWidth = 1.0;
    

    
    bk = [UIImageView new];
    bk.image = [UIImage imageNamed:@"组件 43"];
    [buttonYear addSubview:bk];
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonYear).offset(12);
        make.centerY.equalTo(self->buttonYear);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    offbk = [UIImageView new];
    offbk.contentMode = UIViewContentModeScaleToFill;
    offbk.image = [UIImage imageNamed:@"common_off_bk"];
    [buttonYear addSubview:offbk];
    [offbk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->buttonYear);
        make.top.equalTo(self->buttonYear);
//        make.size.mas_equalTo(CGSizeMake(49, 30));
    }];
    
    offLabel = [UILabel new];
    offLabel.font = kSFUITextFont(13);
    offLabel.textColor = RGB_HEX(0x27A3EF);
    offLabel.text = @"60%off";
    offLabel.attributedText = [self getAttribute:@"60%off"];
    [offbk addSubview:offLabel];
    [offLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->offbk);
    }];
    
    CGFloat blank = 10;
    buttonYearLabel = [UILabel new];
    buttonYearLabel.font = kSFUITextFont(16);
    buttonYearLabel.textColor = [UIColor whiteColor];
    buttonYearLabel.text = NSLocalizedString(@"VIPPrice35", nil);
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self->buttonYear);
        make.left.equalTo(self->bk.mas_right).offset(8);
        make.centerY.equalTo(self->buttonYear).offset(blank);
    }];
    
    buttonYearLabel1 = [UILabel new];
    buttonYearLabel1.font = [UIFont fontWithName:@"SFUIText-Semibold" size:17.0];
    buttonYearLabel1.textColor = [UIColor whiteColor];
    buttonYearLabel1.text = @"1 Year";
    [buttonYear addSubview:buttonYearLabel1];
    [buttonYearLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonYearLabel);
        make.centerY.equalTo(self->buttonYear).offset(-blank);
    }];
    
    yearPriceLB = [UILabel new];
    yearPriceLB.font = [UIFont fontWithName:@"SFUIText-Semibold" size:17.0];
    yearPriceLB.textColor = [UIColor whiteColor];
    yearPriceLB.textAlignment = NSTextAlignmentRight;
    [buttonYear addSubview:yearPriceLB];
    [yearPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->buttonYear.mas_right).offset(-72);
        make.centerY.equalTo(self->buttonYearLabel1);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    yearDurationLB = [UILabel new];
    yearDurationLB.font = kSFUITextFont(16);
    yearDurationLB.textColor = [UIColor whiteColor];
    yearDurationLB.textAlignment = NSTextAlignmentRight;
    yearDurationLB.text = @"/Year";
    [buttonYear addSubview:yearDurationLB];
    [yearDurationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->yearPriceLB);
        make.centerY.equalTo(self->buttonYearLabel);
    }];
    
    [UIUtils showMoney:yearPriceLB subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name];
    
    self.scrollViewHeight += (buttonHeight + 10);
    
    buttonMonth = [UIButton new];
    buttonMonth.tag = 1;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight-stautsHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    buttonMonth.layer.cornerRadius = 12.0;
    buttonMonth.layer.masksToBounds = YES;
    buttonMonth.layer.borderColor = RGB_HEX(0x27A3EF).CGColor;
    buttonMonth.layer.borderWidth = 1.0;
    
    bk1 = [UIImageView new];
    bk1.image = [UIImage imageNamed:@"椭圆 48"];
    [buttonMonth addSubview:bk1];
    [bk1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonMonth).offset(12);
        make.centerY.equalTo(self->buttonMonth);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = kSFUITextFont(16);
    buttonMonthLabel.textColor = RGB_HEX(0x333333);
    buttonMonthLabel.text = NSLocalizedString(@"VIPPrice36", nil);
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->bk1.mas_right).offset(8);
        make.centerY.equalTo(self->buttonMonth).offset(blank);
    }];
    
    buttonMonthLabel1 = [UILabel new];
    buttonMonthLabel1.font = [UIFont fontWithName:@"SFUIText-Semibold" size:17.0];
    buttonMonthLabel1.textColor = RGB_HEX(0x333333);
    buttonMonthLabel1.text = @"1 Month";
    [buttonMonth addSubview:buttonMonthLabel1];
    [buttonMonthLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonMonthLabel);
        make.centerY.equalTo(self->buttonMonth).offset(-blank);
    }];
    
    monthPriceLB = [UILabel new];
    monthPriceLB.font = [UIFont fontWithName:@"SFUIText-Semibold" size:17.0];
    monthPriceLB.textColor = RGB_HEX(0x333333);
    monthPriceLB.textAlignment = NSTextAlignmentRight;
    [buttonMonth addSubview:monthPriceLB];
    [monthPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->buttonMonth.mas_right).offset(-72);
        make.centerY.equalTo(self->buttonMonthLabel1);
    }];
    
    monthDurationLB = [UILabel new];
    monthDurationLB.font = kSFUITextFont(16);
    monthDurationLB.textColor = RGB_HEX(0x333333);
    monthDurationLB.textAlignment = NSTextAlignmentRight;
    monthDurationLB.text = @"/Month";
    [buttonMonth addSubview:monthDurationLB];
    [monthDurationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->monthPriceLB);
        make.centerY.equalTo(self->buttonMonthLabel);
    }];
    
    [UIUtils showMoney:monthPriceLB subcribePrice:Month_Subscribe_Price subcribeName:Month_Subscribe_Name];
    
//    return;
//
//    buttonWeek = [UIButton new];
//    buttonWeek.tag = 2;
//    [self.scrollView addSubview:buttonWeek];
//    [buttonWeek addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
//    [buttonWeek mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight+buttonHeight-stautsHeight+10);
//        make.centerX.equalTo(self.scrollView);
//        make.width.equalTo(@(buttonWidth));
//        make.height.equalTo(@(buttonHeight));
//    }];
//
//    buttonWeek.layer.cornerRadius = 12.0;
//    buttonWeek.layer.masksToBounds = YES;
//    buttonWeek.layer.borderColor = RGB_HEX(0x27A3EF).CGColor;
//    buttonWeek.layer.borderWidth = 1.0;
//
//    bk2 = [UIImageView new];
//    bk2.image = [UIImage imageNamed:@"椭圆 48"];
//    [buttonWeek addSubview:bk2];
//    [bk2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self->buttonWeek).offset(12);
//        make.centerY.equalTo(self->buttonWeek);
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//    }];
//
//    buttonWeekLabel = [UILabel new];
//    buttonWeekLabel.font = kSFUITextFont(16);
//    buttonWeekLabel.textColor = RGB_HEX(0x333333);
//    buttonWeekLabel.text = NSLocalizedString(@"VIPPrice37", nil);
//    [buttonWeek addSubview:buttonWeekLabel];
//    [buttonWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self->bk2.mas_right).offset(8);
//        make.centerY.equalTo(self->buttonWeek).offset(blank);
//    }];
//
//    buttonWeekLabel1 = [UILabel new];
//    buttonWeekLabel1.font = [UIFont fontWithName:@"SFUIText-Semibold" size:15.0];
//    buttonWeekLabel1.textColor = RGB_HEX(0x333333);
//    buttonWeekLabel1.text = @"1 Week";
//    [buttonWeek addSubview:buttonWeekLabel1];
//    [buttonWeekLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self->buttonWeekLabel);
//        make.centerY.equalTo(self->buttonWeek).offset(-blank);
//    }];
//
//    weekPriceLB = [UILabel new];
//    weekPriceLB.font = [UIFont fontWithName:@"SFUIText-Semibold" size:17.0];
//    weekPriceLB.textColor = RGB_HEX(0x333333);
//    weekPriceLB.textAlignment = NSTextAlignmentRight;
//    [buttonWeek addSubview:weekPriceLB];
//    [weekPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self->buttonWeek.mas_right).offset(-72);
//        make.centerY.equalTo(self->buttonWeekLabel1);
//    }];
//
//    weekDurationLB = [UILabel new];
//    weekDurationLB.font = kSFUITextFont(16);
//    weekDurationLB.textColor = RGB_HEX(0x333333);
//    weekDurationLB.textAlignment = NSTextAlignmentRight;
//    weekDurationLB.text = @"/Week";
//    [buttonWeek addSubview:weekDurationLB];
//    [weekDurationLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self->weekPriceLB);
//        make.centerY.equalTo(self->buttonWeekLabel);
//    }];
//
//    [UIUtils showMoney:weekPriceLB subcribePrice:Week_Subscribe_Price subcribeName:Week_Subscribe_Name];

    
//    self.scrollViewHeight += buttonHeight;
    
    
    UIButton* subBtn = [UIButton new];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subBtn setTitle:@"Subscribe Now" forState:UIControlStateNormal];
    subBtn.backgroundColor = RGB(6, 165, 233);
    subBtn.layer.cornerRadius = 24;
    [self.scrollView addSubview:subBtn];
    [subBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight+buttonHeight+16-stautsHeight+10);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width-120));
        make.height.equalTo(@(48));
    }];

    
}

- (void) setupRestoreButton {
    self.scrollViewHeight += 120;
    
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
        [SVProgressHUD dismiss];
        
        if (success) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VIPRestoreSuccess", nil)];
        } else {
            NSString* getPremium = NSLocalizedString(@"VIPPromotionText2", nil);
            NSString* retry  = NSLocalizedString(@"Dialog_Retry", nil);
            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogManager showItemsDialog:[UIUtils getCurrentVC] title:NSLocalizedString(@"VIPRestoreFail", nil) message:NSLocalizedString(@"VIPRestoreFailDesc", nil) actionItems:@[getPremium, retry, cancel] callback:^(NSString *itemName) {
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

-(void)choseType:(UIButton *)sender
{
    if (sender.tag == 0) {
        typeStr = @"1";

        offLabel.textColor = [UIColor whiteColor];
        
        offbk.image = [UIImage imageNamed:@"common_off_bk"];
        offLabel.textColor = RGB_HEX(0x27A3EF);
        
        bk.image = [UIImage imageNamed:@"组件 43"];
        bk1.image = [UIImage imageNamed:@"椭圆 48"];
        bk2.image = [UIImage imageNamed:@"椭圆 48"];
        
        buttonYear.backgroundColor = RGB_HEX(0x027A3EF);
        buttonMonth.backgroundColor = [UIColor whiteColor];
        buttonWeek.backgroundColor = [UIColor whiteColor];
        
        yearPriceLB.textColor = [UIColor whiteColor];
        yearDurationLB.textColor = [UIColor whiteColor];
        monthPriceLB.textColor = RGB_HEX(0x333333);
        monthDurationLB.textColor = RGB_HEX(0x333333);
        weekPriceLB.textColor = RGB_HEX(0x333333);
        weekDurationLB.textColor = RGB_HEX(0x333333);
        
        buttonYearLabel1.textColor = [UIColor whiteColor];
        buttonYearLabel.textColor = [UIColor whiteColor];
        buttonMonthLabel.textColor = RGB_HEX(0x333333);
        buttonMonthLabel1.textColor = RGB_HEX(0x333333);
        buttonWeekLabel.textColor = RGB_HEX(0x333333);
        buttonWeekLabel1.textColor = RGB_HEX(0x333333);

    }else if (sender.tag == 1){
        typeStr = @"2";
        
        offbk.image = [UIImage imageNamed:@"矩形 35"];
        offLabel.textColor = [UIColor whiteColor];
        
        bk.image = [UIImage imageNamed:@"椭圆 48"];
        bk1.image = [UIImage imageNamed:@"组件 43"];
        bk2.image = [UIImage imageNamed:@"椭圆 48"];
        
        buttonYear.backgroundColor = [UIColor whiteColor];
        buttonMonth.backgroundColor = RGB_HEX(0x027A3EF);
        buttonWeek.backgroundColor = [UIColor whiteColor];
        
        yearPriceLB.textColor = RGB_HEX(0x333333);
        yearDurationLB.textColor = RGB_HEX(0x333333);
        monthPriceLB.textColor = [UIColor whiteColor];
        monthDurationLB.textColor = [UIColor whiteColor];
        weekPriceLB.textColor = RGB_HEX(0x333333);
        weekDurationLB.textColor = RGB_HEX(0x333333);
        
        buttonYearLabel1.textColor = RGB_HEX(0x333333);
        buttonYearLabel.textColor = RGB_HEX(0x333333);
        buttonMonthLabel.textColor = [UIColor whiteColor];
        buttonMonthLabel1.textColor = [UIColor whiteColor];
        buttonWeekLabel.textColor = RGB_HEX(0x333333);
        buttonWeekLabel1.textColor = RGB_HEX(0x333333);


    }else{
        typeStr = @"3";

        buttonYear.backgroundColor = [UIColor whiteColor];
        buttonMonth.backgroundColor = [UIColor whiteColor];
        buttonWeek.backgroundColor = RGB_HEX(0x027A3EF);
        
        offLabel.textColor =[UIColor whiteColor];
        offbk.image = [UIImage imageNamed:@"矩形 35"];
        
        bk.image = [UIImage imageNamed:@"椭圆 48"];
        bk1.image = [UIImage imageNamed:@"椭圆 48"];
        bk2.image = [UIImage imageNamed:@"组件 43"];
        
        yearPriceLB.textColor = RGB_HEX(0x333333);
        yearDurationLB.textColor = RGB_HEX(0x333333);
        monthPriceLB.textColor = RGB_HEX(0x333333);
        monthDurationLB.textColor = RGB_HEX(0x333333);
        weekPriceLB.textColor = [UIColor whiteColor];
        weekDurationLB.textColor = [UIColor whiteColor];
        
        buttonYearLabel1.textColor = RGB_HEX(0x333333);
        buttonYearLabel.textColor = RGB_HEX(0x333333);
        buttonMonthLabel.textColor = RGB_HEX(0x333333);
        buttonMonthLabel1.textColor = RGB_HEX(0x333333);
        buttonWeekLabel.textColor = [UIColor whiteColor];
        buttonWeekLabel1.textColor = [UIColor whiteColor];

    }
}

-(void)selectClick
{
    if ([typeStr isEqualToString:@"1"]) {
        [self yearSubcribeAction];
    }else if ([typeStr isEqualToString:@"2"]){
        [self monthSubcribeAction];
    }else{
        [self weekSubcribeAction];
    }
}

- (void) monthSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_19];
    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success){
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void) yearSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_22];
    [QDReceiptManager.shared transaction_new:Year_Subscribe_Name completion:^(BOOL success){
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

-(void) weekSubcribeAction {
    [QDTrackManager track_button:QDTrackButtonType_38];
    [QDReceiptManager.shared transaction_new:Week_Subscribe_Name completion:^(BOOL success){
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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

- (NSMutableAttributedString *)getAttribute:(NSString *)string {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIText-Medium" size:13.0] range:[string rangeOfString:@"60"]];
    return attributeString;
}


@end

