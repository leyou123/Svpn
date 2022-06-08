//
//  QDFeedBackButton.m
//  International
//
//  Created by hzg on 2022/1/8.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDFeedBackButton.h"
#import "QDFeedbackViewController.h"
#import "QDFeedbackViewController2.h"
#import "UIUtils.h"

@interface QDFeedBackButton()

//@property(nonatomic, strong) UIImageView* circleImageView;

@end

@implementation QDFeedBackButton

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    UIButton* button = [UIButton new];
    [self addSubview:button];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // bk
    UIImageView* bk = [UIImageView new];
    bk.image = [UIImage imageNamed:@"feedback"];
    [button addSubview:bk];
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
//    self.circleImageView = [UIImageView new];
//    self.circleImageView.layer.masksToBounds = YES;
//    self.circleImageView.layer.cornerRadius = 8;
//    self.circleImageView.backgroundColor = [UIColor redColor];
//    [button addSubview:self.circleImageView];
//    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.equalTo(button);
//        make.width.height.equalTo(@(16));
//    }];
//    UILabel* timeLabel = [UILabel new];
//    timeLabel.font = [UIFont boldSystemFontOfSize:7];
//    timeLabel.textColor = [UIColor whiteColor];
//    timeLabel.text = @"+1D";
//    [self.circleImageView addSubview:timeLabel];
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.circleImageView);
//    }];
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Feedback_Text", nil);
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button).offset(-2);
        make.centerX.equalTo(button);
    }];
}

- (void) clickAction {
    UIViewController* nav = [UIUtils getCurrentVC];
    QDFeedbackViewController* vc = [QDFeedbackViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [nav.navigationController pushViewController:vc animated:YES];
    
//    QDFeedbackViewController2* vc = [QDFeedbackViewController2 new];
//    vc.hidesBottomBarWhenPushed = YES;
//    [nav.navigationController pushViewController:vc animated:YES];
//    [self showTelegram];
}

- (void) showTelegram {
    NSString* message  = NSLocalizedString(@"Toast_Feedback_succ1", nil);
    NSString* telegram = @"Telegram";
    NSString* whatsapp = @"WhatsApp";
    NSString* telegram_url = @"https://t.me/+4MliG233smoxYjFl";
    NSString* whatsapp_url = @"https://chat.whatsapp.com/CwmwkQy7d0YB2FS3xhZaS5";
    if (QDVersionManager.shared.versionConfig != nil) {
        if (QDVersionManager.shared.versionConfig[@"link_telegram"]) {
            telegram_url = QDVersionManager.shared.versionConfig[@"link_telegram"];
        }
        if (QDVersionManager.shared.versionConfig[@"link_whatsapp"]) {
            whatsapp_url = QDVersionManager.shared.versionConfig[@"link_whatsapp"];
        }
    }
    
    [QDDialogView showTelegram:message items:@[telegram, whatsapp]
          hideWhenTouchOutside:YES cancel:NSLocalizedString(@"Dialog_Cancel", nil) callback:^(NSString *item) {
        if ([telegram isEqualToString:item]) {
            [UIUtils openURLWithString:telegram_url];
        } else if ([whatsapp isEqualToString:item]) {
            [UIUtils openURLWithString:whatsapp_url];
        }
    }];
}

- (void) updateView {
//    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
//    [self.circleImageView setHidden:QDConfigManager.shared.isCommitIssue || isVIP];
}

@end
