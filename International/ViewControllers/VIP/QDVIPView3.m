//
//  QDVIPView3.m
//  International
//
//  Created by LC on 2022/3/22.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDVIPView3.h"
#import "QDSizeUtils.h"
#import "UIUtils.h"

@interface QDVIPView3()
{
    UIButton *buttonYear , *buttonMonth , *buttonWeek , *yearBtn , *monthBtn , *weekBtn;
    UIImageView *bk , *bk1 , *bk2 ,* offbk;
    NSString *typeStr;
    UILabel  *offLabel , *buttonYearLabel1 , *buttonMonthLabel , *buttonYearLabel , *buttonWeekLabel , *buttonWeekLabel1 , *buttonMonthLabel1;
}
@property (nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDVIPView3
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // back
    self.backgroundColor = [UIColor whiteColor];
    
    // scrollview
    [self setupScrollView];
    


    
}




// scrollview
- (void) setupScrollView {
    
    _scrollView = [UIScrollView new];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.leading.bottom.equalTo(self);
    }];
    
    // title
    [self setupTitle];
    
    // form
    [self setupForm];
    
    // buttons
    [self setupPayButtons];
    
    // note
    [self setupNote];
    
    // scrollView
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, self.scrollViewHeight)];
    

}

// title
- (void) setupTitle {
    
    
    self.scrollViewHeight = [QDSizeUtils navigationHeight]+60;
    UILabel* promationTitle = [UILabel new];
    [_scrollView addSubview:promationTitle];
    promationTitle.text = NSLocalizedString(@"VIPStoreTitle1", nil);
    promationTitle.textColor = RGB_HEX(0x414fb6);
    promationTitle.numberOfLines = 0;
    promationTitle.textAlignment = NSTextAlignmentCenter;
    promationTitle.font = [UIFont boldSystemFontOfSize:20];
    [promationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@([QDSizeUtils navigationHeight]));
        make.width.equalTo(@(300));
    }];
    [promationTitle sizeToFit];
    
    self.scrollViewHeight += promationTitle.mj_h;
    

}



// form
- (void) setupForm {

    self.scrollViewHeight += 0;
    UIImageView* formImageView = [UIImageView new];
    formImageView.contentMode = UIViewContentModeScaleToFill;
    formImageView.image = [UIImage imageNamed:@"组 61"];
    [_scrollView addSubview:formImageView];
    [formImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@(self.scrollViewHeight-20));
        make.height.equalTo(@(192));
        make.width.equalTo(@(345));
    }];
    [formImageView sizeToFit];

    self.scrollViewHeight += formImageView.mj_h;
}

- (void) setupPayButtons {
    
    [self setupPayMonthAndYear];
    
    // restore button
    [self setupRestoreButton];
}

// 非VIP推荐月度和年度
- (void) setupPayMonthAndYear {
    typeStr = @"1";

    self.scrollViewHeight += 20;
    CGFloat stautsHeight = 40;

    CGFloat buttonHeight = 80, buttonWidth = 345;
    
    buttonYear = [UIButton new];
    buttonYear.tag = 0;
    [self.scrollView addSubview:buttonYear];
    [buttonYear addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight-stautsHeight);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    

    
    bk = [UIImageView new];
    UIImage* image = [UIImage imageNamed:@"矩形 34"];
    bk.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [buttonYear addSubview:bk];
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->buttonYear);
    }];
    
    
    
    yearBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, buttonHeight/2-7.5, 15, 15)];
    [yearBtn setImage:[UIImage imageNamed:@"椭圆 47"] forState:UIControlStateNormal];
    [bk addSubview:yearBtn];


    
    CGFloat top = 8;
    offbk = [UIImageView new];
    offbk.contentMode = UIViewContentModeScaleToFill;
    offbk.image = [UIImage imageNamed:@"common_off_bk"];
    [buttonYear addSubview:offbk];
    [offbk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->buttonYear).offset(-top+4);
        make.top.equalTo(self->buttonYear).offset(top-6);
    }];
    
    offLabel = [UILabel new];
    offLabel.font = [UIFont systemFontOfSize:12];
    offLabel.textColor = [UIColor whiteColor];
    offLabel.text = @"60% off";
    [offbk addSubview:offLabel];
    [offLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self->offbk);
    }];
    
    CGFloat blank = 10;
    buttonYearLabel = [UILabel new];
    buttonYearLabel.font = [UIFont systemFontOfSize:14];
    buttonYearLabel.textColor = RGB(255, 0, 67);
    [buttonYear addSubview:buttonYearLabel];
    [buttonYearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->buttonYear);
        make.centerY.equalTo(self->buttonYear).offset(blank);
    }];
    
    buttonYearLabel1 = [UILabel new];
    buttonYearLabel1.font = [UIFont boldSystemFontOfSize:19];
    buttonYearLabel1.textColor = RGB(255, 0, 67);
    buttonYearLabel1.text = @"1 Year";
    [buttonYear addSubview:buttonYearLabel1];
    [buttonYearLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonYearLabel);
        make.centerY.equalTo(self->buttonYear).offset(-blank);
    }];
    
    [UIUtils showMoney:buttonYearLabel subcribePrice:Year_Subscribe_Price subcribeName:Year_Subscribe_Name format:NSLocalizedString(@"VIPPrice32", nil)];
    
    self.scrollViewHeight += (buttonHeight + 10);
    
    buttonMonth = [UIButton new];
    buttonMonth.tag = 1;
    [self.scrollView addSubview:buttonMonth];
    [buttonMonth addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight-stautsHeight-5);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    bk1 = [UIImageView new];
    UIImage* image1 = [UIImage imageNamed:@"common_cornel_bk"];
    bk1.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
    [buttonMonth addSubview:bk1];
    [bk1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->buttonMonth);
    }];
    
    monthBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, buttonHeight/2-7.5, 15, 15)];
    [monthBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
    [bk1 addSubview:monthBtn];

    
    buttonMonthLabel = [UILabel new];
    buttonMonthLabel.font = [UIFont systemFontOfSize:14];
    buttonMonthLabel.textColor = RGB(84, 148, 255);
    [buttonMonth addSubview:buttonMonthLabel];
    [buttonMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->buttonMonth);
        make.centerY.equalTo(self->buttonMonth).offset(blank);
    }];
    
    buttonMonthLabel1 = [UILabel new];
    buttonMonthLabel1.font = [UIFont boldSystemFontOfSize:19];
    buttonMonthLabel1.textColor = RGB(84, 148, 255);
    buttonMonthLabel1.text = @"1 Month";
    [buttonMonth addSubview:buttonMonthLabel1];
    [buttonMonthLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonMonthLabel);
        make.centerY.equalTo(self->buttonMonth).offset(-blank);
    }];
    
    [UIUtils showMoney:buttonMonthLabel subcribePrice:Month_Subscribe_Price subcribeName:Month_Subscribe_Name format:NSLocalizedString(@"VIPPrice33", nil)];
    
    
    buttonWeek = [UIButton new];
    buttonWeek.tag = 2;
    [self.scrollView addSubview:buttonWeek];
    [buttonWeek addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight+buttonHeight+5-stautsHeight-5);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    bk2 = [UIImageView new];
    bk2.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
    [buttonWeek addSubview:bk2];
    [bk2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->buttonWeek);
    }];
    
    weekBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, buttonHeight/2-7.5, 15, 15)];
    [weekBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
    [bk2 addSubview:weekBtn];

    
    buttonWeekLabel = [UILabel new];
    buttonWeekLabel.font = [UIFont systemFontOfSize:14];
    buttonWeekLabel.textColor = RGB(84, 148, 255);
    [buttonWeek addSubview:buttonWeekLabel];
    [buttonWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->buttonWeek);
        make.centerY.equalTo(self->buttonWeek).offset(blank);
    }];
    
    buttonWeekLabel1 = [UILabel new];
    buttonWeekLabel1.font = [UIFont boldSystemFontOfSize:19];
    buttonWeekLabel1.textColor = RGB(84, 148, 255);
    buttonWeekLabel1.text = @"1 Week";
    [buttonWeek addSubview:buttonWeekLabel1];
    [buttonWeekLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->buttonWeekLabel);
        make.centerY.equalTo(self->buttonWeek).offset(-blank);
    }];
    [UIUtils showMoney:buttonWeekLabel subcribePrice:Week_Subscribe_Price subcribeName:Week_Subscribe_Name format:NSLocalizedString(@"VIPPrice34", nil)];

    
    self.scrollViewHeight += buttonHeight;
    
    
    UIButton* subBtn = [UIButton new];
    subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subBtn setTitle:@"Subscribe Now" forState:UIControlStateNormal];
    subBtn.backgroundColor = RGB(6, 165, 233);
    subBtn.layer.cornerRadius = 24;
    [self.scrollView addSubview:subBtn];
    [subBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight+buttonHeight+16-stautsHeight-5);
        make.centerX.equalTo(self.scrollView);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width-120));
        make.height.equalTo(@(48));
    }];

    
}

- (void) setupRestoreButton {
    self.scrollViewHeight += 95;
    
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
        UIImage *image = [UIImage imageNamed:@"矩形 34"];
        UIImage *image1 = [UIImage imageNamed:@"common_cornel_bk"];

        bk.image = [UIImage imageNamed:@"矩形 34"];
        bk1.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk2.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        bk1.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image.size.height*0.5];
        bk2.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
        [yearBtn setImage:[UIImage imageNamed:@"椭圆 47"] forState:UIControlStateNormal];
        [monthBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
        [weekBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];

        offLabel.textColor = [UIColor whiteColor];
        buttonYearLabel1.textColor = RGB(255, 0, 67);
        buttonYearLabel.textColor = RGB(255, 0, 67);
        offbk.image = [UIImage imageNamed:@"common_off_bk"];
        
        buttonMonthLabel.textColor = RGB(84, 148, 255);
        buttonMonthLabel1.textColor = RGB(84, 148, 255);
        buttonWeekLabel.textColor = RGB(84, 148, 255);
        buttonWeekLabel1.textColor = RGB(84, 148, 255);

    }else if (sender.tag == 1){
        typeStr = @"2";
        [yearBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
        [monthBtn setImage:[UIImage imageNamed:@"椭圆 47"] forState:UIControlStateNormal];
        [weekBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];

        UIImage *image = [UIImage imageNamed:@"矩形 34"];
        UIImage *image1 = [UIImage imageNamed:@"common_cornel_bk"];

        bk.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk1.image = [UIImage imageNamed:@"矩形 34"];
        bk2.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
        bk1.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        bk2.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
        
        
        offLabel.textColor = [UIColor whiteColor];
        buttonYearLabel1.textColor = RGB(84, 148, 255);;
        buttonYearLabel.textColor = RGB(84, 148, 255);;
        offbk.image = [UIImage imageNamed:@"矩形 35"];
        
        buttonMonthLabel.textColor = RGB(255, 0, 67);
        buttonMonthLabel1.textColor = RGB(255, 0, 67);
        buttonWeekLabel.textColor = RGB(84, 148, 255);;
        buttonWeekLabel1.textColor = RGB(84, 148, 255);;


    }else{
        typeStr = @"3";
        [yearBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
        [monthBtn setImage:[UIImage imageNamed:@"椭圆 48"] forState:UIControlStateNormal];
        [weekBtn setImage:[UIImage imageNamed:@"椭圆 47"] forState:UIControlStateNormal];

        UIImage *image = [UIImage imageNamed:@"矩形 34"];
        UIImage *image1 = [UIImage imageNamed:@"common_cornel_bk"];

        bk.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk1.image = [UIImage imageNamed:@"common_cornel_bk"];
        bk2.image = [UIImage imageNamed:@"矩形 34"];
        
        bk.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
        bk1.image = [image1 stretchableImageWithLeftCapWidth:image1.size.width*0.5 topCapHeight:image1.size.height*0.5];
        bk2.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];

        
        offLabel.textColor =[UIColor whiteColor];
        buttonYearLabel1.textColor = RGB(84, 148, 255);;
        buttonYearLabel.textColor = RGB(84, 148, 255);;
        offbk.image = [UIImage imageNamed:@"矩形 35"];
        
        buttonMonthLabel.textColor = RGB(84, 148, 255);;
        buttonMonthLabel1.textColor = RGB(84, 148, 255);;
        buttonWeekLabel.textColor = RGB(255, 0, 67);
        buttonWeekLabel1.textColor = RGB(255, 0, 67);

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
    QDAdManager.shared.forbidAd = YES;
    [QDTrackManager track_button:QDTrackButtonType_19];
    [QDReceiptManager.shared transaction_new:Month_Subscribe_Name completion:^(BOOL success){
        
    }];
}

- (void) yearSubcribeAction {
    QDAdManager.shared.forbidAd = YES;
    [QDTrackManager track_button:QDTrackButtonType_22];
    [QDReceiptManager.shared transaction_new:Year_Subscribe_Name completion:^(BOOL success){
    }];
}

-(void) weekSubcribeAction {
    QDAdManager.shared.forbidAd = YES;
    [QDTrackManager track_button:QDTrackButtonType_38];
    [QDReceiptManager.shared transaction_new:Week_Subscribe_Name completion:^(BOOL success){
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


@end
