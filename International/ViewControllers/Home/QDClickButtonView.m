//
//  QDClickButtonView.m
//  International
//
//  Created by LC on 2022/4/19.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDClickButtonView.h"
#import "QDDateUtils.h"
#import "QDBaseResultModel.h"
#import "QDPayViewController3.h"
#import "QDPayViewController2.h"
#import "QDDeviceUtils.h"

@interface QDClickButtonView()

@property (nonatomic, strong) UILabel * textLB;

@end

@implementation QDClickButtonView

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName text:(NSString *)text attributeString:(NSString *)atring Action:(ClickAction)action {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpWithimage:imageName text:text attributeString:atring action:action];
    }
    return self;
}

- (void)setUpWithimage:(NSString *)imageName text:(NSString *)text attributeString:(NSString *)atring action:(ClickAction)action {
    
    self.title = text;
    self.action = action;
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(self);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = NO;
    [bottomBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomBtn);
        make.left.equalTo(bottomBtn);
        make.width.height.mas_equalTo(40);
    }];
    
    UILabel * textLB = [[UILabel alloc] initWithFrame:CGRectZero];
    textLB.userInteractionEnabled = NO;
    textLB.textColor = [UIColor whiteColor];
    textLB.font = kSFUITextFont(13.0);
    textLB.numberOfLines = 0;
    [bottomBtn addSubview:textLB];
    _textLB = textLB;
    [textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right);
        make.right.equalTo(bottomBtn);
        make.top.height.equalTo(bottomBtn);
    }];
    if (atring && atring.length > 0) {
        textLB.attributedText = [self getAttributeString:text attributeString:atring];
    }else {
        textLB.text = text;
    }
}

- (NSMutableAttributedString *)getAttributeString:(NSString *)text attributeString:(NSString *)atring {
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:atring];
    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]} range:range];
    return attributeString;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title isEqualToString:NSLocalizedString(@"Home_Share", nil)]) {
        _textLB.text = title;
    }else {
        _textLB.attributedText = [self getAttributeString:title attributeString:NSLocalizedString(@"Home_GetTimeADsP_desc", nil)];
    }
}

- (void)clickAction:(UIButton *)btn {
    if ([self.title isEqualToString:NSLocalizedString(@"Home_ConnectSupport", nil)]) {
        self.action();
    }else if ([self.title isEqualToString:NSLocalizedString(@"Home_Share", nil)]) {
        self.action();
    }else {
        [self watchAd];
    }
}

- (void)watchAd {
    [self clickAction];
    self.watch();
}

- (void) clickAction {
    
    [QDTrackManager track_button:QDTrackButtonType_31];

    if (QDActivityManager.shared.activityResultModel.watchAdTimes <= 0) {
        NSString* zeroTime = [QDDateUtils getTime:0 andMinute:0];
        NSString* limit1 = NSLocalizedString(@"Ad_Play_Limit", nil);
//        NSString* limit2 = [NSString stringWithFormat:NSLocalizedString(@"Home_Ad_RefreshTime", nil), zeroTime];
//        NSString* limit = [NSString stringWithFormat:@"%@\n%@", limit1, limit2];
        // 次数达到上限
        [SVProgressHUD showErrorWithStatus:limit1];
    } else {
        if (!QDAdManager.shared.isRVAvailable) {

            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogView show:NSLocalizedString(@"Ad_Request_Fail", nil) message:NSLocalizedString(@"Ad_Request_Text", nil) items:@[NSLocalizedString(@"Ad_Request_ToVip", nil)]  backImages:@[@"home_premium"] hideWhenTouchOutside:NO cancel:cancel callback:^(NSString *item) {
                [self doPayAction];
            }];
            [QDAdManager.shared loadVideo];
        } else {
            [QDAdManager.shared showVideo:^(BOOL result) {
                if (result) [self doRewardAction];
            }];
        }
    }
}

// 调转至支付界面
- (void) doPayAction {
    if ([QDDeviceUtils deviceIs678]) {
        QDPayViewController3* vc = [QDPayViewController3 new];
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootViewController presentViewController:vc animated:YES completion:nil];
    }else{
        QDPayViewController2* vc = [QDPayViewController2 new];
        UIViewController* rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootViewController presentViewController:vc animated:YES completion:nil];

    }
}

// 奖励
- (void) doRewardAction {
    // 奖励
    [SVProgressHUD show];
    [QDModelManager requestUserAddTimeNew:4 time:30*60 completed:^(NSDictionary * _Nonnull dictionary) {
        NSLog(@"dictionary = %@", dictionary);
        QDBaseResultModel* result = [QDBaseResultModel mj_objectWithKeyValues:dictionary];
        if (result.code == kHttpStatusCode200) {
            
            [QDActivityManager.shared watchAdComplete];
            
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserChange object:nil];
            
            NSString* watchAd = NSLocalizedString(@"Ad_reward_watch", nil);
            NSString* rmAd = NSLocalizedString(@"Ad_rm", nil);
            NSString* cancel = NSLocalizedString(@"Dialog_Cancel", nil);
            [QDDialogView show:NSLocalizedString(@"Ad_reward_suc", nil) message:NSLocalizedString(@"Ad_reward_text", nil) items:@[rmAd] backImages:@[@"home_premium"] hideWhenTouchOutside:NO cancel:cancel callback:^(NSString *item) {
                if ([item isEqual:watchAd]) {
                    [self clickAction];
                } else if ([item isEqual:rmAd]) {
                    [self doPayAction];
                }
            }];
            
        } else {
            [SVProgressHUD showWithStatus:result.message];
            [SVProgressHUD dismissWithDelay:HUDDISMISSTIME];
        }
    }];
}




@end
