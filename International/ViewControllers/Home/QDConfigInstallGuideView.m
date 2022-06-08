//
//  QDConfigInstallGuideView.m
//
//  Created by hzg on 2021/6/18.
//

#import "QDConfigInstallGuideView.h"
#import "QDSizeUtils.h"
#import "YJAnimateUtils.h"

@interface QDConfigInstallGuideView()

@property(nonatomic, strong) UIImageView* progressView;

@end

@implementation QDConfigInstallGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // back
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //创建毛玻璃视图
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualView.frame = self.bounds;
    //添加到imageView上
    [self addSubview:visualView];
    
    // add
    UILabel* addLabel = [UILabel new];
    addLabel.numberOfLines = 0;
    addLabel.text = NSLocalizedString(@"Config_Add_Title", nil);
    addLabel.textColor = [UIColor blackColor];
    addLabel.font = [UIFont boldSystemFontOfSize:21];
    addLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([QDSizeUtils navigationHeight] + 100));
        make.centerX.equalTo(self);
        make.width.equalTo(@(300));
    }];
    
    // add tip
    UILabel* addTipLabel = [UILabel new];
    addTipLabel.numberOfLines = 0;
    addTipLabel.text = NSLocalizedString(@"Config_Add_Tip", nil);
    addTipLabel.textAlignment = NSTextAlignmentCenter;
    addTipLabel.textColor = RGB_HEX(0x888888);
    addTipLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:addTipLabel];
    [addTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addLabel.mas_bottom).offset(6);
        make.centerX.equalTo(self);
        make.width.equalTo(@(300));
    }];
    
    // desc tip
    UILabel* descLabel = [UILabel new];
    descLabel.numberOfLines = 0;
    descLabel.text = NSLocalizedString(@"Config_Desc", nil);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = RGB_HEX(0x888888);
    descLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(165);
    }];
    
    // 箭头
    _progressView = [UIImageView new];
    _progressView.image = [[UIImage imageNamed:@"arrow_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _progressView.tintColor = [UIColor blackColor];
    [self addSubview:_progressView];
    CGFloat tx = -65;
    CGFloat ty = 115;
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(ty);
        make.centerX.equalTo(self).offset(tx);
    }];
    CGPoint startPoint = CGPointMake([QDSizeUtils is_width]/2 + tx, [QDSizeUtils is_height]/2+ty);
    [self.progressView.layer addAnimation:[YJAnimateUtils translateAnimationForever:startPoint endPoint:CGPointMake(startPoint.x, startPoint.y - 10)] forKey:@"tanslateAnimation"];
    
    
}

@end
