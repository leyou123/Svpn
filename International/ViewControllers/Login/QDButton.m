//
//  QDButton.m
//  International
//
//  Created by hzg on 2021/9/3.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDButton.h"

@interface QDButton()
@property(nonatomic, copy) ClickBlock block;
@property(nonatomic, strong) UIView* backView;
@end

@implementation QDButton


- (instancetype) initWithFrame:(CGRect)frame title:(NSString*)title clickBlock:(ClickBlock) block {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame title:title clickBlock:block];
    }
    return self;
}

- (void) setup:(CGRect)frame title:(NSString*)title clickBlock:(ClickBlock) block {
    
    // callback
    _block = block;
    
    // back
    _backView = [UIView new];
    _backView.userInteractionEnabled = NO;
    _backView.layer.cornerRadius  = 4;
    _backView.layer.masksToBounds = YES;
    _backView.backgroundColor = RGB_HEX(0x3e9efa);
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // title
    UILabel* label = [UILabel new];
    label.text          = title;
    label.font          = [UIFont boldSystemFontOfSize:16];
    label.textColor     = [UIColor whiteColor];
    [_backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
    
    [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setIsButtonEnabled:(BOOL)isButtonEnabled {
    _backView.alpha = isButtonEnabled ? 1 : 0.5;
    _isButtonEnabled = isButtonEnabled;
}

- (void) clickAction {
    if (self.isButtonEnabled && _block) _block();
}


@end
