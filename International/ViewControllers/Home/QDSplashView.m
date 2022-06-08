//
//  QDSplashView.m
//  International
//
//  Created by hzg on 2021/9/6.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDSplashView.h"
#import "QDVersionConfigResultModel.h"

@implementation QDSplashView

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
    spashView.image = [UIImage imageNamed:@"SplashImage"];
    spashView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:spashView];
    [spashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 请求用户配置
    [QDModelManager requestVersionConfig:^(NSDictionary * _Nonnull dictionary) {
        QDVersionConfigResultModel* result = [QDVersionConfigResultModel mj_objectWithKeyValues:dictionary];
        if (result&&result.code == kHttpStatusCode200 && result.data) {
            QDVersionManager.shared.versionConfig = [result.data.json_config mj_JSONObject];
            NSLog(@"versionConfig = %@", QDVersionManager.shared.versionConfig);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationConfigUpdate object:nil];
        }
        if (self.callback) self.callback();
        [self removeFromSuperview];
    }];
}

@end
