//
//  QDRecommandAdView.m
//  International
//
//  Created by hzg on 2021/6/17.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDRecommandAdView.h"
#import "QDAdvertisingResultModel.h"

@interface QDRecommandAdView()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *desLabel;
@property (nonatomic, strong) NSString    *trackViewUrl;

@end

@implementation QDRecommandAdView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setData];
    }
    return self;
}

- (void) setData {
    self.iconImageView.image = [UIImage imageNamed:@"ad_icon"];
    self.desLabel.text = NSLocalizedString(@"Recommand_App_Text", nil);
    
    // 请求appinfo
    [QDHTTPManager.shared request:HTTPMethodTypeGet url:@"http://itunes.apple.com/lookup?id=1562835898" parameters:@{} completed:^(NSDictionary * _Nonnull dictionary) {
        if (!dictionary || [dictionary[@"resultCount"] integerValue] <= 0) {
            return;
        }
        self.trackViewUrl = [dictionary[@"results"][0] objectForKey:@"trackViewUrl"];
    }];
}


- (void) setup {
    
    
    // button
    UIButton* button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.backImageView = [UIImageView new];
    self.backImageView.backgroundColor = RGB(85, 48, 234);
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(button);
    }];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.cornerRadius = 6;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.left.equalTo(@(12));
        make.width.height.equalTo(@(40));
    }];
    
    self.desLabel = [UILabel new];
    self.desLabel.textColor = [UIColor whiteColor];
    self.desLabel.font = [UIFont systemFontOfSize:12];
    [button addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button);
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
        make.right.equalTo(button).offset(-6);
    }];
    [self.desLabel sizeToFit];
    
    UIButton* closeButton = [UIButton new];
    [self addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"shutDown"] forState:UIControlStateNormal];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-6);
        make.top.equalTo(self).offset(6);
    }];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) clickAction {
    [QDTrackManager track_button:QDTrackButtonType_8];
    if (!self.trackViewUrl) return;
    NSURL *url =[NSURL URLWithString:self.trackViewUrl];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void) closeAction {
    [QDTrackManager track_button:QDTrackButtonType_9];
    [self removeFromSuperview];
}


@end
