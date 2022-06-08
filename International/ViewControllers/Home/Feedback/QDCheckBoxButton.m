//
//  QDCheckBoxButton.m
//  International
//
//  Created by hzg on 2022/1/10.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDCheckBoxButton.h"

@interface QDCheckBoxButton()

@property(nonatomic, strong) UIButton* button;
@property(nonatomic, strong) UIImageView* backImageView;
@property(nonatomic, strong) UILabel* textLabel;

@end

@implementation QDCheckBoxButton

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:text];
    }
    return self;
}

- (void) setup:(NSString*)text {
    self.button = [UIButton new];
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.backImageView = [UIImageView new];
    self.backImageView.image = [UIImage imageNamed:@"feedback_btn_nor"];
    [self.button addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.button);
    }];
    
    self.textLabel = [UILabel new];
    self.textLabel.text = text;
    self.textLabel.textColor = RGB_HEX(0x333333);
    self.textLabel.font = [UIFont systemFontOfSize:12];
    [self.button addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.button);
    }];
    
    self.text = text;
}

- (void) clickAction {
    self.isSelected = !self.isSelected;
    self.backImageView.image = self.isSelected ? [UIImage imageNamed:@"feedback_btn_sel"] : [UIImage imageNamed:@"feedback_btn_nor"];
    self.textLabel.textColor = self.isSelected ? RGB_HEX(0x3e9efa) : RGB_HEX(0x333333);
}

@end
