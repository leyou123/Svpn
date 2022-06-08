//
//  QDConnectSuccessView.m
//  International
//
//  Created by LC on 2022/4/25.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDConnectSuccessView.h"
#import "QDGetPremiumView.h"
#import "UIUtils.h"
#import "QDTimerManager.h"

@interface QDConnectSuccessView()

@property (nonatomic, strong) UIView * view1;
@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UIView * view3;

@property (nonatomic, strong) UIImageView * logoIv;
@property (nonatomic, strong) QDGetPremiumView * resultView;
@property (nonatomic, strong) UIButton * supportBtn;

@property (nonatomic, assign) int timeValue;

@property (nonatomic, strong) UILabel * timeLB1;
@property (nonatomic, strong) UILabel * timeLB2;
@property (nonatomic, strong) UILabel * timeLB3;

@end

@implementation QDConnectSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        self.timeValue = 0;
        self.status = StatusConnect;
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"NO" forKey:@"ClickSatifsy"];
        [userDefault setObject:@"NO" forKey:@"ClickButton"];
        [userDefault synchronize];
    }
    return self;
}

- (void)setUpUI {
    {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:view1];
        _view1 = view1;
        [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.top.bottom.equalTo(self);
        }];
        
        CGSize size = [self sizeWithFont:20.0 textSizeWidht:MAXFLOAT textSizeHeight:30 text:@"Connected"];
        CGFloat leftW = kScreenWidth/2-(size.width+30)/2;
        UIImageView *iconIv = [[UIImageView alloc] init];
        iconIv.image = [UIImage imageNamed:@"home_status_connected"];
        [view1 addSubview:iconIv];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftW);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.equalTo(self).offset(75);
        }];
        
        UILabel * statusLB = [[UILabel alloc] init];
        statusLB.textColor = RGB_HEX(0x27A3EF);
        statusLB.font = kSFUITextFont(20);
        statusLB.text = @"Connected";
        [view1 addSubview:statusLB];
        [statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(8);
            make.centerY.equalTo(iconIv);
        }];
        
        UILabel * timeLB = [[UILabel alloc] init];
        timeLB.textColor = RGB_HEX(0x333333);
        timeLB.font = kSFUITextFont(12);
        timeLB.textAlignment = NSTextAlignmentRight;
        [view1 addSubview:timeLB];
        _timeLB1 = timeLB;
        [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(statusLB);
            make.top.equalTo(statusLB.mas_bottom);
        }];
    }
    
    {
        CGFloat btnLeftW = (kScreenWidth-240-54)/2.0;
        CGFloat gaps = 27;
        UIView * view2 = [[UIView alloc] initWithFrame:CGRectZero];
        view2.hidden = YES;
        [self addSubview:view2];
        _view2 = view2;
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.top.bottom.equalTo(self);
        }];

        UILabel * tipsLB = [[UILabel alloc] init];
        tipsLB.font = [UIFont fontWithName:@"SFUIText-Semibold" size:22.0];
        tipsLB.textColor = RGB_HEX(0x333333);
        tipsLB.textAlignment = NSTextAlignmentCenter;
        NSString * text = NSLocalizedString(@"NativeAd_Rate_Title", nil);
        tipsLB.attributedText = [self getattributeStringWith:text Range:[text rangeOfString:@"with this connection?"]];
        [view2 addSubview:tipsLB];
        [tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.equalTo(self);
            make.top.equalTo(self).offset(45);
            make.height.equalTo(@26);
        }];

        UIButton * satifsyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [satifsyBtn addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventTouchUpInside];
        [satifsyBtn setTitle:NSLocalizedString(@"NativeAd_Rate_Satisfy", nil) forState:UIControlStateNormal];
        [satifsyBtn setTitleColor:RGB_HEX(0x666666) forState:UIControlStateNormal];
        satifsyBtn.titleLabel.font = kSFUITextFont(12);
        satifsyBtn.layer.cornerRadius = 13;
        satifsyBtn.layer.masksToBounds = YES;
        satifsyBtn.layer.borderColor = RGB_HEX(0xCCCCCC).CGColor;
        satifsyBtn.layer.borderWidth = 1;
        satifsyBtn.tag = 800001;
        [view2 addSubview:satifsyBtn];
        [satifsyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(btnLeftW);
            make.top.equalTo(tipsLB.mas_bottom).offset(24);
            make.height.equalTo(@26);
            make.width.equalTo(@80);
        }];

        UIButton * sosoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sosoBtn addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventTouchUpInside];
        [sosoBtn setTitle:NSLocalizedString(@"NativeAd_Rate_Soso", nil) forState:UIControlStateNormal];
        [sosoBtn setTitleColor:RGB_HEX(0x666666) forState:UIControlStateNormal];
        sosoBtn.titleLabel.font = kSFUITextFont(12);
        sosoBtn.layer.cornerRadius = 13;
        sosoBtn.layer.masksToBounds = YES;
        sosoBtn.layer.borderColor = RGB_HEX(0xCCCCCC).CGColor;
        sosoBtn.layer.borderWidth = 1;
        sosoBtn.tag = 800002;
        [view2 addSubview:sosoBtn];
        [sosoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(satifsyBtn.mas_right).offset(gaps);
            make.top.equalTo(satifsyBtn);
            make.height.equalTo(@26);
            make.width.equalTo(@80);
        }];

        UIButton * unSatifsyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [unSatifsyBtn addTarget:self action:@selector(rateAction:) forControlEvents:UIControlEventTouchUpInside];
        [unSatifsyBtn setTitle:NSLocalizedString(@"NativeAd_Rate_UnSatisfy", nil) forState:UIControlStateNormal];
        [unSatifsyBtn setTitleColor:RGB_HEX(0x666666) forState:UIControlStateNormal];
        unSatifsyBtn.titleLabel.font = kSFUITextFont(12);
        unSatifsyBtn.layer.cornerRadius = 13;
        unSatifsyBtn.layer.masksToBounds = YES;
        unSatifsyBtn.layer.borderColor = RGB_HEX(0xCCCCCC).CGColor;
        unSatifsyBtn.layer.borderWidth = 1;
        unSatifsyBtn.tag = 800003;
        [view2 addSubview:unSatifsyBtn];
        [unSatifsyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sosoBtn.mas_right).offset(gaps);
            make.top.equalTo(sosoBtn);
            make.height.equalTo(@26);
            make.width.equalTo(@80);
        }];

        UIImageView *iconIv = [[UIImageView alloc] init];
        iconIv.image = [UIImage imageNamed:@"home_status_connected"];
        [view2 addSubview:iconIv];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
            make.bottom.equalTo(self).offset(-5);
        }];

        UILabel * statusLB = [[UILabel alloc] init];
        statusLB.textColor = RGB_HEX(0x27A3EF);
        statusLB.font = kSFUITextFont(13);
        statusLB.text = @"Connected";
        [view2 addSubview:statusLB];
        [statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(8);
            make.centerY.equalTo(iconIv);
        }];

        UILabel * timeLB = [[UILabel alloc] init];
        timeLB.textColor = RGB_HEX(0x333333);
        timeLB.font = kSFUITextFont(12);
        timeLB.textAlignment = NSTextAlignmentRight;
        [view2 addSubview:timeLB];
        _timeLB2 = timeLB;
        [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconIv);
            make.right.equalTo(self).offset(-15);
        }];
    }
    
    {
        UIView * view3 = [[UIView alloc] initWithFrame:CGRectZero];
        view3.hidden = YES;
        [self addSubview:view3];
        _view3 = view3;
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.top.bottom.equalTo(self);
        }];

        UILabel * tipsLB = [[UILabel alloc] init];
        tipsLB.font = [UIFont fontWithName:@"SFUIText-Semibold" size:22.0];
        tipsLB.textColor = RGB_HEX(0x333333);
        tipsLB.textAlignment = NSTextAlignmentCenter;
        tipsLB.text = @"Thanks for your feedback.";
        [view3 addSubview:tipsLB];
        [tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerX.equalTo(self);
            make.top.equalTo(self).offset(45);
            make.height.equalTo(@26);
        }];

        UIImageView * logoIv = [[UIImageView alloc] init];
        logoIv.image = [UIImage imageNamed:@"home_connect_smile"];
        [view3 addSubview:logoIv];
        _logoIv = logoIv;
        [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(tipsLB.mas_bottom).offset(24);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        QDGetPremiumView * resultView = [[QDGetPremiumView alloc] initWithFrame:CGRectZero leftImage:@"home_connect_share" title:@"Share with Friends" clickAction:^(NSInteger memberType) {
            self.shareCallback();
        }];
        resultView.hidden = YES;
        [view3 addSubview:resultView];
        _resultView = resultView;
        [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view3);
            make.width.equalTo(@240);
//            make.left.equalTo(view3).offset(68);
            make.height.equalTo(@50);
            make.top.equalTo(tipsLB.mas_bottom).offset(24);
        }];
        
//        UIButton * supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [supportBtn setBackgroundImage:[UIImage imageNamed:@"home_premium"] forState:UIControlStateNormal];
//        [supportBtn setTitle:@"Support Connect" forState:UIControlStateNormal];
//        supportBtn.titleLabel.font = kSFUITextFont(15);
//        [supportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [supportBtn addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
//        supportBtn.hidden = YES;
//        [view3 addSubview:supportBtn];
//        _supportBtn = supportBtn;
//        [supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(resultView);
//        }];

        UIImageView *iconIv = [[UIImageView alloc] init];
        iconIv.image = [UIImage imageNamed:@"home_status_connected"];
        [view3 addSubview:iconIv];
        [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
            make.bottom.equalTo(self).offset(-5);
        }];

        UILabel * statusLB = [[UILabel alloc] init];
        statusLB.textColor = RGB_HEX(0x27A3EF);
        statusLB.font = kSFUITextFont(13);
        statusLB.text = @"Connected";
        [view3 addSubview:statusLB];
        [statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIv.mas_right).offset(8);
            make.centerY.equalTo(iconIv);
        }];

        UILabel * timeLB = [[UILabel alloc] init];
        timeLB.textColor = RGB_HEX(0x333333);
        timeLB.font = kSFUITextFont(12);
        timeLB.textAlignment = NSTextAlignmentRight;
        [view3 addSubview:timeLB];
        _timeLB3 = timeLB;
        [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconIv);
            make.right.equalTo(self).offset(-15);
        }];
    }
}

- (void)rateAction:(UIButton *)button {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if (button.tag == 800001) {
        self.resultView.hidden = NO;
        self.logoIv.hidden = YES;
        self.supportBtn.hidden = YES;
        [userDefault setObject:@"YES" forKey:@"ClickSatifsy"];
        [userDefault setObject:@"YES" forKey:@"ClickButton"];
        [userDefault synchronize];
    }else if (button.tag == 800002) {
        self.resultView.hidden = YES;
        self.logoIv.hidden = NO;
        self.supportBtn.hidden = YES;
        [userDefault setObject:@"NO" forKey:@"ClickSatifsy"];
        [userDefault setObject:@"YES" forKey:@"ClickButton"];
        [userDefault synchronize];
    }else {
        self.feedbackCallback();
        [userDefault setObject:@"NO" forKey:@"ClickSatifsy"];
        [userDefault setObject:@"YES" forKey:@"ClickButton"];
        [userDefault synchronize];
    }
    [self updateSuccessStatu:StatusRateResult];
}

- (void)updateSuccessStatu:(Status)status {
    self.status = status;
    if (status == StatusRate) {
        _view1.hidden = YES;
        _view2.hidden = NO;
        _view3.hidden = YES;
    }else if (status == StatusRateResult) {
        _view1.hidden = YES;
        _view2.hidden = YES;
        _view3.hidden = NO;
    }else {
        _view1.hidden = NO;
        _view2.hidden = YES;
        _view3.hidden = YES;
    }
}

- (NSMutableAttributedString *)getattributeStringWith:(NSString *)text Range:(NSRange)range {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttributes:@{NSFontAttributeName:kSFUITextFont(13),NSForegroundColorAttributeName:RGB_HEX(0x333333)} range:range];
    return attributeString;
}

- (void)updateTime:(long)times {
    
    long seconds = times;
    long h   = seconds / 3600;
    long min   = (seconds - h * 3600) / 60;
    long s   = seconds - h*3600 - min*60;

    NSString * time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",h,min,s];
 
    if (seconds == 6) {
        [self updateSuccessStatu:StatusRate];
    }
    if (self.status == StatusConnect) {
        self.timeLB1.text = [NSString stringWithFormat:@"time:%@",time];
    }else if (self.status == StatusRate) {
        self.timeLB2.text = [NSString stringWithFormat:@"time:%@",time];
    }else {
        self.timeLB3.text = [NSString stringWithFormat:@"time:%@",time];
    }
}


- (CGSize)sizeWithFont:(CGFloat)fontSize textSizeWidht:(CGFloat)widht textSizeHeight:(CGFloat)height text:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kSFUITextFont(fontSize)} context:nil];
    return rect.size;
}

@end
