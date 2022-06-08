//
//  QDPasswordView.m
//  International
//
//  Created by hzg on 2021/9/8.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDPasswordView.h"

@interface QDPasswordView()

@property(nonatomic, strong) UILabel* simpleLabel;
@property(nonatomic, strong) UILabel* mediumLabel;
@property(nonatomic, strong) UILabel* complexLabel;

@property(nonatomic, strong) UIView* simpleView;
@property(nonatomic, strong) UIView* mediumView;
@property(nonatomic, strong) UIView* complexView;

@end

@implementation QDPasswordView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // tip
    UILabel* tipLabel = [UILabel new];
    tipLabel.text = NSLocalizedString(@"Password_Tip", nil);
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = RGB_HEX(0xbfbfbf);
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
    
    
    // w h
    CGFloat w = (self.frame.size.width - 2)/3;
    CGFloat h = 6;
    self.simpleView = [UIView new];
    self.simpleView.layer.cornerRadius = 3;
    [self addSubview:self.simpleView];
    [self.simpleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tipLabel.mas_top).offset(-16);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    self.mediumView = [UIView new];
    self.mediumView.layer.cornerRadius = 3;
    [self addSubview:self.mediumView];
    [self.mediumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tipLabel.mas_top).offset(-16);
        make.left.equalTo(self.simpleView.mas_right).offset(1);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    self.complexView = [UIView new];
    self.complexView.layer.cornerRadius = 3;
    [self addSubview:self.complexView];
    [self.complexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tipLabel.mas_top).offset(-16);
        make.left.equalTo(self.mediumView.mas_right).offset(1);
        make.width.equalTo(@(w));
        make.height.equalTo(@(h));
    }];
    
    // simipe
    self.simpleLabel = [UILabel new];
    self.simpleLabel.font = [UIFont systemFontOfSize:14];
    self.simpleLabel.text = NSLocalizedString(@"Password_Simple", nil);
    self.simpleLabel.textColor = RGB_HEX(0xF4F4F4);
    [self addSubview:self.simpleLabel];
    [self.simpleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.simpleView);
    }];
    
    // medium
    self.mediumLabel = [UILabel new];
    self.mediumLabel.font = [UIFont systemFontOfSize:14];
    self.mediumLabel.text = NSLocalizedString(@"Password_Medium", nil);
    self.mediumLabel.textColor = RGB_HEX(0xF4F4F4);
    [self addSubview:self.mediumLabel];
    [self.mediumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.mediumView);
    }];
    
    // complex
    self.complexLabel = [UILabel new];
    self.complexLabel.font = [UIFont systemFontOfSize:14];
    self.complexLabel.text = NSLocalizedString(@"Password_Complex", nil);
    self.complexLabel.textColor = RGB_HEX(0x41d21a);
    [self addSubview:self.complexLabel];
    [self.complexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.complexView);
    }];
    
    // 设置密码
    self.password = @"";
}

// 设置密码
- (void)setPassword:(NSString *)password {
    NSUInteger passwordLevel = 0;
    NSUInteger length = [password length];
    
    if (length >= 6) {
        NSMutableDictionary* typeDict = [NSMutableDictionary new];
        for (int i = 0; i < length; i++) {
            char c = [password characterAtIndex:i];
            NSString *temp = [password substringWithRange:NSMakeRange(i,1)];
            const char *u8Temp = [temp UTF8String];
            if (3==strlen(u8Temp)){
                NSLog(@"字符串中含有中文");
                typeDict[@"c_1"] = @(YES);
            }else if((c>64)&&(c<91)){
                typeDict[@"c_2"] = @(YES);
                NSLog(@"字符串中含有大写英文字母");
            }else if((c>96)&&(c<123)){
                typeDict[@"c_3"] = @(YES);
                NSLog(@"字符串中含有小写英文字母");
            }else if((c>47)&&(c<58)){
                typeDict[@"c_4"] = @(YES);
                NSLog(@"字符串中含有数字");
            }else{
                typeDict[@"c_5"] = @(YES);
                NSLog(@"字符串中含有非法字符");
            }
        }
        passwordLevel = typeDict.allKeys.count;
    }
    
    UIColor* emptyColor = RGB_HEX(0xbfbfbf);
    self.simpleView.backgroundColor  = emptyColor;
    self.mediumView.backgroundColor  = emptyColor;
    self.complexView.backgroundColor = emptyColor;
    [self.simpleLabel setHidden:YES];
    [self.mediumLabel setHidden:YES];
    [self.complexLabel setHidden:YES];
    
    if (passwordLevel >= 3) {
        // complex
        UIColor* color = self.complexLabel.textColor;
        self.simpleView.backgroundColor  = color;
        self.mediumView.backgroundColor  = color;
        self.complexView.backgroundColor = color;
        [self.complexLabel setHidden:NO];
    } else if (passwordLevel >= 2) {
        // medium
        UIColor* color = self.mediumLabel.textColor;
        self.simpleView.backgroundColor  = color;
        self.mediumView.backgroundColor  = color;
        [self.mediumLabel setHidden:NO];
    } else if (passwordLevel >= 1) {
        UIColor* color = self.simpleLabel.textColor;
        self.simpleView.backgroundColor  = color;
        [self.simpleLabel setHidden:NO];
    }
}

@end
