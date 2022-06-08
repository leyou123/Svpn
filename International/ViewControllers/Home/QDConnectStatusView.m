//
//  QDConnectStatusView.m
//  International
//
//  Created by LC on 2022/4/20.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDConnectStatusView.h"

@interface QDConnectStatusView()

@property (nonatomic, strong) UIImageView * statusIv;

@property (nonatomic, strong) UILabel * statusLB;

@end

@implementation QDConnectStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    CGFloat textW = [self getTextWidthWith:@"Connect"];
    
    CGFloat totalW = textW+20;
    
    CGFloat imageLeft = kScreenWidth/2 - totalW/2;
    
    UIImageView * statusIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    statusIv.image = [UIImage imageNamed:@"home_status_connect"];
    [self addSubview:statusIv];
    _statusIv = statusIv;
    [_statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self).offset(imageLeft);
    }];
    
    UILabel * statusLB = [[UILabel alloc] init];
    statusLB.textColor = RGB_HEX(0xAAAAAA);
    statusLB.font = kSFUITextFont(13.0);
    statusLB.text = @"Connect";
    [self addSubview:statusLB];
    _statusLB = statusLB;
    [_statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(statusIv.mas_right).offset(4);
        make.height.equalTo(statusIv.mas_height);
    }];
}


- (CGFloat)getTextWidthWith:(NSString *)str
{
    if (str.length < 1) {
        return 0;
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    CGFloat width = rect.size.width + 1;
    return width;
}

-(void)updateConnectStatus {
// i9 -
}

-(void)updateConnectStatus:(ConnectStatus)status {
    if (status == status_disconnected) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.statusIv.image = [UIImage imageNamed:@"home_status_connect"];
            self.statusLB.text = @"Connect";
            self.statusLB.textColor = RGB_HEX(0xAAAAAA);
            [self resetLayOut:self.statusLB.text];
        });
    }else if (status == status_connected) {
        self.statusIv.image = [UIImage imageNamed:@"home_status_connected"];
        self.statusLB.text = @"Connected";
        self.statusLB.textColor = RGB_HEX(0x27A3EF);
    }else if (status == status_connecting) {
        self.statusIv.image = [UIImage imageNamed:@"home_status_connected"];
        self.statusLB.text = @"Connecting";
        self.statusLB.textColor = RGB_HEX(0x27A3EF);
    }else if (status == status_disconnecting) {
        self.statusIv.image = [UIImage imageNamed:@"home_status_connect"];
        self.statusLB.text = @"Disconnecting";
        self.statusLB.textColor = RGB_HEX(0xAAAAAA);
        [self resetLayOut:self.statusLB.text];
    }else if (status == status_fail) {
        self.statusIv.image = [UIImage imageNamed:@"home_status_fail"];
        self.statusLB.text = @"Failed";
        self.statusLB.textColor = RGB_HEX(0xF04646);
    }
    [self resetLayOut:self.statusLB.text];
}

- (void)resetLayOut:(NSString *)text {
    CGFloat textW = [self getTextWidthWith:text];
    
    CGFloat totalW = textW+20;
    
    CGFloat imageLeft = kScreenWidth/2 - totalW/2;
    
    [_statusIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self).offset(imageLeft);
    }];

    [_statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self);
        make.left.equalTo(self.statusIv.mas_right).offset(4);
        make.height.equalTo(self.statusIv.mas_height);
    }];
}

@end
