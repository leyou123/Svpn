//
//  ProtocolView.m
//  International
//
//  Created by a on 2020/3/19.
//  Copyright © 2020 com. All rights reserved.
//

#import "ProtocolView.h"
#import "QDSizeUtils.h"
#import "QDVersionConfigResultModel.h"

@implementation ProtocolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self protocolViewUI];
    }
    return self;
}

- (void)protocolViewUI{
    
    UIImageView *lanBottomImage = [UIImageView new];
    lanBottomImage.image = [UIImage imageNamed:@"common_blue_back"];
    [self addSubview:lanBottomImage];
    [lanBottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // title
    CGFloat labelWidth = 300;
    UILabel* titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = NSLocalizedString(@"Privacy_Title", nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelWidth));
        make.centerX.equalTo(self);
        make.top.equalTo(@([QDSizeUtils is_tabBarHeight] + 80));
    }];
    [titleLabel sizeToFit];
    

    // label1
    UILabel* label1 = [UILabel new];
    label1.numberOfLines = 0;
    label1.textColor = [UIColor whiteColor];
    label1.text = NSLocalizedString(@"Privacy_Content0", nil);
    label1.font = [UIFont systemFontOfSize:14];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelWidth));
        make.centerX.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    NSArray* arr = @[
        NSLocalizedString(@"Privacy_Content1", nil),
        NSLocalizedString(@"Privacy_Content2", nil),
        NSLocalizedString(@"Privacy_Content3", nil),
        NSLocalizedString(@"Privacy_Content4", nil)
    ];
    
    // labels
    CGFloat top = 5;
    UIView* aboveView = label1;
    for (NSString* str in arr) {
        UILabel* label = [UILabel new];
        label.numberOfLines = 0;
        label.text = str;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(labelWidth));
            make.centerX.equalTo(self);
            make.top.equalTo(aboveView.mas_bottom).offset(top);
        }];
        aboveView = label;
        [label sizeToFit];
    }

    UIButton* button = [UIButton new];
    button.layer.cornerRadius = 6;
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(acceptButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(200));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self);
        make.bottom.equalTo(@(-[QDSizeUtils is_tabBarHeight] - 100));
    }];
    
    UILabel* text = [UILabel new];
    [button addSubview:text];
    text.textColor = RGB(12, 73, 166);
    text.font = [UIFont systemFontOfSize:18];
    text.text = NSLocalizedString(@"Privacy_Content5", nil);
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
    }];
    
}

- (void)acceptButtonClick{
    [QDTrackManager track_button:QDTrackButtonType_0];
    if (self.callback) self.callback();
    [self removeFromSuperview];
}

@end
