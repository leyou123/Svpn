//
//  QDFeedbackViewController2.m
//  International
//
//  Created by hzg on 2022/2/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDFeedbackViewController2.h"
#import "QDSizeUtils.h"
#import "QDCheckBoxButton2.h"

@interface QDFeedbackViewController2 ()

@property (nonatomic, strong) UIView *wrapView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation QDFeedbackViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupBanner];
}

- (void) setupBanner {
    CGFloat toBottom = [QDSizeUtils isIphoneX] ? -34 : 0;
    [QDAdManager.shared showBanner:self toBottom:toBottom];
}

- (void) setup {
    self.wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.wrapView];
    [self setupScrollView];
    [self setupTitle:NSLocalizedString(@"Feedback_Text", nil)];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - [QDSizeUtils navigationHeight] - 44)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void) setupScrollView {
    
    // root scrollview
    [self.wrapView addSubview:self.scrollView];
    
    [self setupIssue];
    [self setupMutiChoices];
    
    // banner 50
    self.scrollViewHeight += 10; //blank
    self.scrollViewHeight += 50;
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_W, self.scrollViewHeight)];
}

- (void) setupIssue {
    
    self.scrollViewHeight += 30;
    
    CGFloat height = 75;
    
    // imge
    UIImageView* imageView = [UIImageView new];
    [self.scrollView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"feedback_service"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
    }];
    
    UILabel* textLabel = [UILabel new];
    textLabel.text = NSLocalizedString(@"Feedback_issue", nil);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:12];
    [imageView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView).offset(18);
        make.centerY.equalTo(imageView);
    }];
    
    self.scrollViewHeight += height;
}

- (void) setupMutiChoices {
    
    self.scrollViewHeight += 50;
    
    NSArray<NSString*>* dataArr = @[
        NSLocalizedString(@"Feedback_failconnect", nil),
        NSLocalizedString(@"Feedback_slowspeed", nil),
        NSLocalizedString(@"Feedback_lackline", nil),
        NSLocalizedString(@"Feedback_Disconnect_Game", nil),
        NSLocalizedString(@"Feedback_somethings_else", nil)
    ];
    
    CGFloat w = 161, h = 38, blank = 10;
    for (NSString* str in dataArr) {
        QDCheckBoxButton2* button = [[QDCheckBoxButton2 alloc] initWithFrame:CGRectZero text:str callback:^(NSString * _Nonnull text) {
            [QDDialogView showFeedback:NO callback:^(NSString *email, NSString *content) {
                
            }];
        }];
        [self.scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(self.scrollViewHeight);
            make.height.equalTo(@(h));
            make.width.equalTo(@(w));
            make.centerX.equalTo(self.scrollView);
        }];

        self.scrollViewHeight += (h + blank);
    }
}

@end
