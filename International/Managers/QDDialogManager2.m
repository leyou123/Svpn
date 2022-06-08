//
//  CSLYDialogView.m
//  StormVPN
//
//  Created by hzg on 2022/1/12.
//

#import "QDDialogManager2.h"
#import "UIUtils.h"

static int BOTTOM_TAG = 101;

@interface QDDialogManager2() <UITextViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong) UIButton* rootView;
@property(nonatomic, copy) OperateResultCallBack callback;
@property(nonatomic, strong) NSArray<NSString*>* items ;
@property(nonatomic, strong) NSArray<NSString*>* backImages ;

// feedback
@property(nonatomic, copy) void (^callback1)(NSString *email, NSString* content);
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UILabel  *placeHolder;
@property(nonatomic, strong) UILabel *textViewNumLabel;

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel     *textFieldLabel;

@property(nonatomic, strong) UIImageView* bk;

@end

@implementation QDDialogManager2


// 单例
+ (QDDialogManager2 *) shared {
    static dispatch_once_t onceToken;
    static QDDialogManager2 *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDDialogManager2 new];
    });
    return instance;
}

// 显示操作框
- (void) show:(NSString*)title message:(NSString*)message items:(NSArray<NSString*>*)items hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback {
    [self show:title message:message items:items backImages:@[] hideWhenTouchOutside:hideWhenTouchOutside cancel:cancel callback:callback];
}

// 显示操作框
- (void) show:(NSString*)title message:(NSString*)message items:(NSArray<NSString*>*)items backImages:(NSArray *)images  hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback {
    
    if (self.rootView) [self.rootView removeFromSuperview];
    self.rootView = nil;
    
    self.backImages = images;
    self.items = items;
    self.callback = callback;
    [self setupBack:hideWhenTouchOutside];
    [self setupAbove:title message:message cancel:cancel];
}

- (void) showTemplate1:(NSString*)message image:(NSString*)imageUrl items:(NSArray<NSString*>*)items hideWhenTouchOutside:(BOOL) hideWhenTouchOutside cancel:(NSString*)cancel callback:(OperateResultCallBack)callback {
    
    if (self.rootView) [self.rootView removeFromSuperview];
    self.rootView = nil;
    
    self.callback = callback;
    self.items = items;
    
    [self setupBack:hideWhenTouchOutside];
    
    // backview
    UIImageView* bk = [UIImageView new];
    bk.backgroundColor = [UIColor whiteColor];
    bk.layer.cornerRadius = 10;
    bk.layer.masksToBounds = YES;
    bk.userInteractionEnabled = YES;
    [self.rootView addSubview:bk];
    CGFloat w = 275, h = 300, top = 32;
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rootView);
        make.centerY.equalTo(self.rootView).offset(-50);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    // message
    UILabel* mesageLabel = [UILabel new];
    [bk addSubview:mesageLabel];
    mesageLabel.text = message;
    mesageLabel.numberOfLines = 0;
    mesageLabel.textAlignment = NSTextAlignmentCenter;
    mesageLabel.textColor = RGB_HEX(0x333333);
    mesageLabel.font = [UIFont boldSystemFontOfSize:14];
    [mesageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(240));
        make.top.equalTo(bk).offset(top);
    }];
    [mesageLabel sizeToFit];
    
    CGFloat width = 236, height = 44, blank = 12, imageW = 171, imageH = 165;
    // imge
    UIImageView* imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bk addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"telegram_image"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.bottom.equalTo(bk).offset(-48);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageH);
    }];
    
    // 按钮
    UIButton* button2 = [UIButton new];
    [self.rootView addSubview:button2];
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    button2.backgroundColor = RGB_HEX(0x46c354);
    [button2 addTarget:self action:@selector(itemAction1) forControlEvents:UIControlEventTouchUpInside];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(bk.mas_bottom).offset(blank*3);
    }];
    
    UILabel* label2 = [UILabel new];
    [button2 addSubview:label2];
    label2.text = self.items[0];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont boldSystemFontOfSize:14];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button2);
    }];
    
    // cancel
    UIButton* button = nil;
    if (cancel&&![cancel isEqualToString:@""]) {
        
        button = [UIButton new];
        [self.rootView addSubview:button];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bk);
            make.width.equalTo(@(80));
            make.height.equalTo(@(80));
            make.top.equalTo(button2.mas_bottom);
        }];
        
        UILabel* label = [UILabel new];
        [button addSubview:label];
        label.text = cancel;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
        }];
    }
    
    // 缓动效果
    [button setHidden:YES];
    [button2 setHidden:YES];
    
    bk.alpha = 0.5;
    bk.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        bk.transform = CGAffineTransformIdentity;
        bk.alpha = 1;
    } completion:^(BOOL finished) {
        bk.alpha = 1;
        [button2 setHidden:NO];
        [button setHidden:NO];
    }];
}

- (void) showTelegram:(NSString*)message
    items:(NSArray<NSString*>*)items
    hideWhenTouchOutside:(BOOL)hideWhenTouchOutside
    cancel:(NSString*)cancel
    callback:(OperateResultCallBack)callback {
    if (self.rootView) [self.rootView removeFromSuperview];
    self.rootView = nil;
    self.callback = callback;
    self.items = items;
    [self setupBack:hideWhenTouchOutside];
    
    // backview
    UIImageView* bk = [UIImageView new];
    bk.backgroundColor = [UIColor whiteColor];
    bk.layer.cornerRadius = 10;
    bk.layer.masksToBounds = YES;
    bk.userInteractionEnabled = YES;
    [self.rootView addSubview:bk];
    CGFloat w = 275, h = 400, top = 32;
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rootView);
        make.centerY.equalTo(self.rootView).offset(-50);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    // message
    UILabel* mesageLabel = [UILabel new];
    [bk addSubview:mesageLabel];
    mesageLabel.text = message;
    mesageLabel.numberOfLines = 0;
    mesageLabel.textAlignment = NSTextAlignmentCenter;
    mesageLabel.textColor = RGB_HEX(0x333333);
    mesageLabel.font = [UIFont boldSystemFontOfSize:14];
    [mesageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(240));
        make.top.equalTo(bk).offset(top);
    }];
    [mesageLabel sizeToFit];
    
    CGFloat width = 236, height = 44, blank = 12;
    // imge
    UIImageView* imageView = [UIImageView new];
    [bk addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"telegram_image"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.top.equalTo(mesageLabel.mas_bottom).offset(blank*2);
    }];
    
//    UILabel* sloglabel = [UILabel new];
//    [bk addSubview:sloglabel];
//    sloglabel.text = NSLocalizedString(@"Recommand_slog_text", nil);
//    sloglabel.textColor = RGB_HEX(0x333333);
//    sloglabel.font = [UIFont boldSystemFontOfSize:14];
//    [sloglabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bk);
//        make.top.equalTo(imageView.mas_bottom).offset(blank);
//    }];
    
    // 2个按钮
    UIButton* button2 = [UIButton new];
    [bk addSubview:button2];
    button2.layer.cornerRadius = 5;
    button2.layer.masksToBounds = YES;
    button2.backgroundColor = RGB_HEX(0x46c354);
    [button2 addTarget:self action:@selector(itemAction2) forControlEvents:UIControlEventTouchUpInside];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(imageView.mas_bottom).offset(blank*2);
    }];
    
    UILabel* label2 = [UILabel new];
    [button2 addSubview:label2];
    label2.text = self.items[1];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont boldSystemFontOfSize:12];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button2).offset(20);
        make.centerY.equalTo(button2);
    }];
    
    UIImageView* icon2 = [UIImageView new];
    [button2 addSubview:icon2];
    icon2.image = [UIImage imageNamed:@"whatsapp_icon"];
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label2.mas_left).offset(-11);
        make.centerY.equalTo(button2);
    }];
    
    // 1个按钮
    UIButton* button = [UIButton new];
    [bk addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.backgroundColor = RGB_HEX(0x3a64ff);
    [button addTarget:self action:@selector(itemAction1) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.top.equalTo(button2.mas_bottom).offset(blank);
    }];
    
    UILabel* label = [UILabel new];
    [button addSubview:label];
    label.text = self.items[0];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button).offset(20);
        make.centerY.equalTo(button);
    }];
    
    UIImageView* icon = [UIImageView new];
    [button addSubview:icon];
    icon.image = [UIImage imageNamed:@"telegram_icon"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-15);
        make.centerY.equalTo(button);
    }];
    
    
    // cancel
    UIButton* cancelButton = nil;
    if (cancel&&![cancel isEqualToString:@""]) {
        
        cancelButton = [UIButton new];
        [self.rootView addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bk);
            make.width.equalTo(@(80));
            make.height.equalTo(@(80));
            make.top.equalTo(bk.mas_bottom);
        }];
        
        UILabel* label = [UILabel new];
        [cancelButton addSubview:label];
        label.text = cancel;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cancelButton);
        }];
    }
    
    [cancelButton setHidden:YES];
    bk.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        bk.transform = CGAffineTransformIdentity;
        bk.alpha = 1;
    } completion:^(BOOL finished) {
        bk.alpha = 1;
        [cancelButton setHidden:NO];
    }];
}

- (void) showFeedback:(BOOL)hideWhenTouchOutside callback:(void (^)(NSString *email, NSString* content)) callback {
    
    if (self.rootView) [self.rootView removeFromSuperview];
    self.rootView = nil;
    
    self.callback1 = callback;
    [self setupBack:hideWhenTouchOutside];
    
    // backview
    UIImageView* bk = [UIImageView new];
    bk.backgroundColor = [UIColor whiteColor];
    bk.layer.cornerRadius = 10;
    bk.layer.masksToBounds = YES;
    bk.userInteractionEnabled = YES;
    [self.rootView addSubview:bk];
    CGFloat w = 340, h = 425;
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rootView);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    // close button
    UIButton* cancelButton = [UIButton new];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bk addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
        make.top.equalTo(@(16));
        make.left.equalTo(@(10));
    }];
    
    UIImageView* cancelIcon = [UIImageView new];
    cancelIcon.image = [[UIImage imageNamed:@"vip_premium_feature_close"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cancelIcon.tintColor = [UIColor blackColor];
    [cancelButton addSubview:cancelIcon];
    [cancelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cancelButton);
    }];
    
    // title
    UILabel* titleLabel = [UILabel new];
    [bk addSubview:titleLabel];
    titleLabel.text = NSLocalizedString(@"Feedback_issue_title", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(180));
        make.centerY.equalTo(cancelButton);
    }];
    
    // email content
    CGFloat top = 69;
    
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.textColor = [UIColor blackColor];
    self.textField.font = [UIFont systemFontOfSize:12];
    self.textField.placeholder = NSLocalizedString(@"Feedback_email_placeholder", nil);
    self.textField.returnKeyType = UIReturnKeyNext;
    [bk addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bk).offset(top);
        make.width.equalTo(@(w - 26));
        make.height.equalTo(@(44));
        make.centerX.equalTo(bk);
    }];
    if (QDConfigManager.shared.email && ![QDConfigManager.shared.email isEqualToString:@""]) self.textField.text = QDConfigManager.shared.email;
    
    top += (44 + 12);
    
    
    CGFloat height = 151, margin = 12;
    UIView* textBackView = [UIView new];
    textBackView.layer.cornerRadius = 4;
    textBackView.layer.masksToBounds = YES;
    textBackView.backgroundColor = RGB_HEX(0xf3f3f3);
    [bk addSubview:textBackView];
    [textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bk).offset(top);
        make.centerX.equalTo(bk);
        make.width.equalTo(@(w - 24));
        make.height.equalTo(@(height));
    }];
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.backgroundColor = RGB_HEX(0xf3f3f3);
    self.textView.textColor = [UIColor blackColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.font = [UIFont systemFontOfSize:12];
    [textBackView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(textBackView).offset(margin);
        make.right.bottom.equalTo(textBackView).offset(-margin);
    }];
    
//    BOOL isVIP = (QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1);
//    BOOL hasReward = !QDConfigManager.shared.isCommitIssue && !isVIP;
    UILabel *placeHolder = [UILabel new];
//    placeHolder.text = hasReward ? NSLocalizedString(@"Feedback_details_placeholder2", nil) : NSLocalizedString(@"Feedback_details_placeholder1", nil);
    placeHolder.text = NSLocalizedString(@"Feedback_details_placeholder1", nil);
    placeHolder.textColor = [UIColor lightGrayColor];
    placeHolder.numberOfLines = 0;
    placeHolder.font = [UIFont systemFontOfSize:12];
    [self.textView addSubview:placeHolder];
    [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(6);
        make.top.equalTo(self.textView).offset(10);
        make.width.equalTo(@(SCREEN_W - 24 - 24));
    }];
    self.placeHolder = placeHolder;
    
    
    self.textViewNumLabel = [UILabel new];
    self.textViewNumLabel.font = [UIFont systemFontOfSize:12];
    self.textViewNumLabel.text = @"0/300";
    self.textViewNumLabel.textColor = [UIColor lightGrayColor];
    [textBackView addSubview:self.textViewNumLabel];
    [self.textViewNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(textBackView).offset(-12);
    }];
    
    top += (height + 73);
    
    // send
    CGFloat buttonheight = 50;
    UIButton* commitButton = [UIButton new];
    commitButton.layer.cornerRadius = 4;
    commitButton.layer.masksToBounds = YES;
    commitButton.backgroundColor = RGB_HEX(0x3e9efa);
    [commitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [bk addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bk).offset(top);
        make.width.equalTo(@(w - 34));
        make.centerX.equalTo(bk);
        make.height.equalTo(@(buttonheight));
    }];
    
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Feedback_submit", nil);
    [commitButton addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(commitButton);
    }];
}


// 上层视图
- (void) setupAbove:(NSString*)title message:(NSString*)message cancel:(NSString*)cancel {
    
    // 多按钮, 最多支持2个
    NSInteger count = MIN(2, self.items.count);
    
    // backview
    UIImageView* bk = [UIImageView new];
    bk.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    bk.layer.cornerRadius = 10;
    bk.layer.masksToBounds = YES;
    bk.userInteractionEnabled = YES;
    [self.rootView addSubview:bk];
    _bk = bk;
    CGFloat w = 275, h = 278, top = 32;
    if (count < 2) h = 200;
    [bk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rootView);
        make.centerY.equalTo(self.rootView).offset(-60);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    // title
    if (title&&![title isEqualToString:@""]) {
        UILabel* titleLabel = [UILabel new];
        [bk addSubview:titleLabel];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bk);
            make.width.equalTo(@(180));
            make.top.equalTo(bk).offset(top);
        }];
        [titleLabel sizeToFit];
        top += (titleLabel.mj_h + 30);
    }
    
    // message
    UILabel* mesageLabel = [UILabel new];
    [bk addSubview:mesageLabel];
    mesageLabel.text = message;
    mesageLabel.numberOfLines = 0;
    mesageLabel.textAlignment = NSTextAlignmentCenter;
    mesageLabel.textColor = RGB_HEX(0x333333);
    mesageLabel.font = [UIFont systemFontOfSize:12];
    [mesageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bk);
        make.width.equalTo(@(180));
        make.top.equalTo(bk).offset(top);
    }];
    
    
    NSArray<NSString*>* selectorArr = @[@"itemAction1", @"itemAction2"];
    NSArray<UIColor*>* colors = @[RGB_HEX(0x3a64ff)];
    if (count > 1) colors = @[RGB_HEX(0x3e9efa),RGB_HEX(0x3a64ff)];
    CGFloat width = 236, height = 44, bottom = 27, blank = 10;
    for (NSInteger i = 0; i < count; i++) {
        UIButton* button = [UIButton new];
        [bk addSubview:button];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        if (self.backImages.count > 0) {
            [button setBackgroundImage:[UIImage imageNamed:self.backImages[i]] forState:UIControlStateNormal];
        }else {
            button.backgroundColor = colors[i];
        }
        [button addTarget:self action:NSSelectorFromString(selectorArr[i]) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bk);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
            make.bottom.equalTo(bk).offset(-(bottom + (count - i - 1)*(height+blank)));
        }];
        
        UILabel* label = [UILabel new];
        [button addSubview:label];
        label.text = self.items[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
        }];
    }

    // cancel
    if (cancel&&![cancel isEqualToString:@""]) {
        
        UIButton* button = [UIButton new];
        [self.rootView addSubview:button];
        [button addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bk);
            make.width.equalTo(@(80));
            make.height.equalTo(@(80));
            make.top.equalTo(self.bk.mas_bottom).offset(50);
        }];
        
        UILabel* label = [UILabel new];
        [button addSubview:label];
        label.text = cancel;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button);
        }];
    }
}

// 背景视图
- (void) setupBack:(BOOL) hideWhenTouchOutside {
    self.rootView = [UIButton new];
    self.rootView.backgroundColor = [UIColor clearColor];
    UIView* window = [UIApplication.sharedApplication delegate].window;
    [window addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    if (hideWhenTouchOutside) [self.rootView addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];

    // 透明图层
    UIView* transparent = [UIView new];
    transparent.userInteractionEnabled = NO;
    transparent.backgroundColor = [UIColor blackColor];
    transparent.alpha = 0.8;
    [self.rootView addSubview:transparent];
    [transparent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rootView);
    }];
}


// 隐藏操作框
- (void) hide:(NSString*)item {
    
    UIView* bottomView = [self.rootView viewWithTag:BOTTOM_TAG];
    CGFloat height = bottomView.bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.rootView);
            make.bottom.equalTo(self.rootView).offset(height);
            make.height.equalTo(@(height));
        }];
        [bottomView.superview layoutIfNeeded];
    }];
    
    // 延迟0.2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!item || [item isEqualToString:@""]) {
            self.callback = nil;
        }
        [self remove:item];
    });
    
}

// remove
- (void) remove:(NSString*)item {
    if (self.callback) self.callback(item);
    if (self.rootView) [self.rootView removeFromSuperview];
    self.rootView = nil;
    self.callback = nil;
}

// 取消
- (void) cancel {
    [self hide:@""];
}

// 点击操作1
- (void) itemAction1 {
    [self hide:self.items[0]];
}

// 点击操作2
- (void) itemAction2 {
    [self hide:self.items[1]];
}


// feedback
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
    self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
}

// 这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self submitAction];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

-(void)textViewEditChanged:(NSNotification *)obj{
    //获取正在输入的textView
    int maxLength = 300;
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textView.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength) {
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
    self.textViewNumLabel.text = [NSString stringWithFormat:@"%ld/%d", [textView.text length], maxLength];
}

//监听文本框的值的改变
- (void) textValueChanged:(NSNotification *)notice {
    BOOL isValid = NO;
    if (self.textField.text) isValid = [UIUtils isValidateEmail:self.textField.text];
    BOOL visiable = self.textField.text != nil && ![self.textField.text isEqual:@""] && !isValid;
    [self.textFieldLabel setHidden:!visiable];
}


//点击输入框界面跟随键盘上移
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
//    CGFloat offSet = IS_IPAD ? 352 : 270;
//    offSet = SCREEN_H - textField.frame.origin.y - offSet - 60 - [QDSizeUtils navigationHeight] - 44;
//
//    //iphone键盘高度为216.iped键盘高度为352
//    //将试图的Y坐标向上移动offset个单位，以使线面腾出开的地方用于软键盘的显示
//    if (offSet < 0) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.wrapView.mj_y = offSet;
//        }];
//    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.textView becomeFirstResponder];
    return YES;
}

- (void) submitAction {
    
    // 关闭键盘
    if (self.textView.isFirstResponder)
        [self.textView resignFirstResponder];
    if (self.textField.isFirstResponder)
        [self.textField resignFirstResponder];
    
    // TODO: 报错检查
    BOOL isValid = NO;
    if (self.textField.text) isValid = [UIUtils isValidateEmail:self.textField.text];
    
    if (!isValid) {
        return;
    }
    
}

@end
