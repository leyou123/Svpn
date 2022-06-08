//
//  QDCheckBoxButton2.m
//  International
//
//  Created by hzg on 2022/2/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDCheckBoxButton2.h"

@interface QDCheckBoxButton2()

@property(nonatomic, strong) UIButton* button;
@property(nonatomic, strong) UIImageView* backImageView;
@property(nonatomic, strong) UILabel* textLabel;
@property(nonatomic, strong) NSString* text;
@property(nonatomic, copy) void (^callback)(NSString *text);

@end

@implementation QDCheckBoxButton2

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text callback:(void (^)(NSString *text)) callback {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:text callback:callback];
    }
    return self;
}

- (void) setup:(NSString*)text callback:(void (^)(NSString *text)) callback {
    
    self.callback = callback;
    
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
    if (self.callback) self.callback(self.text);
}

@end
