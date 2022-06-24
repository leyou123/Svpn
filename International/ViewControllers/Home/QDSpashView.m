//
//  QDSpashView.m
//  International
//
//  Created by hzg on 2021/9/2.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDSpashView.h"
#import "QDVersionConfigResultModel.h"

@implementation QDSpashView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // spash view
    UIImageView *spashView = [UIImageView new];
    spashView.contentMode = UIViewContentModeScaleAspectFill;
    spashView.image = [UIImage imageNamed:@"SplashImage"];
    [self addSubview:spashView];
    [spashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 请求用户配置
    [QDTrackManager track:QDTrackType_connect_cms_start data:@{}];
    [QDModelManager requestVersionConfig:^(NSDictionary * _Nonnull dictionary) {
        QDVersionConfigResultModel* result = [QDVersionConfigResultModel mj_objectWithKeyValues:dictionary];
        if (result&&result.code == kHttpStatusCode200 && result.data) {
            QDVersionManager.shared.versionConfig = [result.data.json_config mj_JSONObject];
            QDVersionManager.shared.operator_switch = result.data.operator_switch;
            NSLog(@"versionConfig = %@", QDVersionManager.shared.versionConfig);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigUpdate object:nil];
            [QDTrackManager track:QDTrackType_connect_cms_suc data:@{}];
        } else {
            // 失败
            [QDTrackManager track:QDTrackType_connect_cms_fail data:@{}];
        }
        if (self.callback) self.callback();
        [self removeFromSuperview];
    }];
}

@end
