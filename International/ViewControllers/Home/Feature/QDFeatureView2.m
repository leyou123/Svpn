//
//  FeatureView2.m
//  vpn
//
//  Created by hzg on 2021/5/14.
//

#import "QDFeatureView2.h"
#import "QDSizeUtils.h"

@implementation QDFeatureView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
//    // bg
//    UIImageView* view = [UIImageView new];
//    view.image = [UIImage imageNamed:@"feature_bk"];
//    [self addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    // image
    UIImageView* image = [UIImageView new];
    image.image = [UIImage imageNamed:@"feature_private"];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([QDSizeUtils navigationHeight]+44);
        make.centerX.equalTo(self);
    }];
    
    UILabel* label = [UILabel new];
    label.text          = NSLocalizedString(@"Feature_Title_2", nil);
    label.textColor     = RGB_HEX(0x27A3EF);
    label.font = kSFUIDisplayFont(Feature_Font_Size);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(350));
        make.centerX.equalTo(self);
        make.top.equalTo(image.mas_bottom).offset(48);
    }];
    [label sizeToFit];
    
    UILabel* label1 = [UILabel new];
    label1.text          = NSLocalizedString(@"Feature_Title_Sub_2", nil);
    label1.textColor     = RGB_HEX(0x333333);
    label1.numberOfLines = 0;
//    label1.alpha         = 0.9;
    label1.font          = kSFUITextFont(Feature_Font_Sub_Size);
    label1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(250));
        make.centerX.equalTo(self);
        make.top.equalTo(label.mas_bottom).offset(4);
    }];
    [label1 sizeToFit];
}

@end
