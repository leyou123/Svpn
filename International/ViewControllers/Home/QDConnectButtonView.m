//
//  QDConnectButtonView.m
//  International
//
//  Created by hzg on 2021/6/8.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDConnectButtonView.h"
#import "YJAnimateUtils.h"
#import "QDDeviceUtils.h"
#import "UIImage+GIF.h"

@interface QDConnectButtonView()<CAAnimationDelegate>

@property(nonatomic, copy) ClickBlock block;
@property(nonatomic, strong) UIButton* button;
@property(nonatomic, strong) UILabel* statusLB;
@property(nonatomic, strong) UIImageView* statusIv;
@property(nonatomic, strong) UIImageView* progressView;
@property(nonatomic, strong) UIImageView* disProgressView;
@property(nonatomic, strong) NSMutableArray* connectAnimationImages;
@property(nonatomic, strong) NSMutableArray* disconnectAnimationImages;
@property(nonatomic, strong) UIImageView * circle_noConnectBgIv;
@property(nonatomic, strong) UIImageView * buttonIv;
@end

@implementation QDConnectButtonView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(ClickBlock) block {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:block];
    }
    return self;
}

- (void) setup:(ClickBlock)block {
            
    // block
    _block = block;
    
    UIImageView * circleBgIv = [[UIImageView alloc] init];
    circleBgIv.image = [UIImage imageNamed:@"home_not_connect_circal"];
    circleBgIv.hidden = YES;
    [self addSubview:circleBgIv];
    _circle_noConnectBgIv = circleBgIv;
    [self.circle_noConnectBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.height.equalTo(self.mas_width);
    }];
    
    // button
    _button = [UIButton new];
//    [_button setImage:[UIImage imageNamed:@"home_not_connect"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(2.5*kScreenScale);
        if (IS_IPAD) {
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }else {
            make.size.mas_equalTo(CGSizeMake(165*kScreenScale, 165*kScreenScale));
        }
    }];
    
    UIImageView * buttonIv = [UIImageView new];
    buttonIv.image = [UIImage imageNamed:@"home_not_connect"];
    [_button addSubview:buttonIv];
    _buttonIv = buttonIv;
    [_buttonIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.button);
        if (IS_IPAD) {
            make.size.mas_equalTo(CGSizeMake(180, 180));
        }else {
            make.size.mas_equalTo(CGSizeMake(136*kScreenScale, 136*kScreenScale));
        }
    }];
    
    self.progressView = [UIImageView new];
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"home_connecting" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage * image = [UIImage sd_imageWithGIFData:imageData];
    _progressView.image = image;
    [_button addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.button);
        if (IS_IPAD) {
            make.size.mas_equalTo(CGSizeMake(180, 180));
        }else {
            make.size.mas_equalTo(CGSizeMake(136*kScreenScale, 136*kScreenScale));
        }
    }];
    self.progressView.hidden = YES;
    self.disProgressView = [UIImageView new];
    NSString *filePath1 = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"home_disconnecting" ofType:@"gif"];
    NSData *imageData1 = [NSData dataWithContentsOfFile:filePath1];
    UIImage * image1 = [UIImage sd_imageWithGIFData:imageData1];
    _disProgressView.image = image1;
    [_button addSubview:_disProgressView];
    [_disProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.button);
        if (IS_IPAD) {
            make.size.mas_equalTo(CGSizeMake(180, 180));
        }else {
            make.size.mas_equalTo(CGSizeMake(136*kScreenScale, 136*kScreenScale));
        }
    }];
    self.disProgressView.hidden = YES;
    
    [self layoutIfNeeded];
    
    CGFloat textW = [self getTextWidthWith:@"Connect"];
    CGFloat totalW = textW+20;
    CGFloat imageLeft = 95*kScreenScale - totalW/2;
    if (IS_IPAD) {
        imageLeft = 120 - totalW/2;
    }
    UIImageView * statusIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    statusIv.image = [UIImage imageNamed:@"home_status_connect"];
    [self addSubview:statusIv];
    _statusIv = statusIv;
    [_statusIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.left.equalTo(self).offset(imageLeft);
        make.bottom.equalTo(self);
    }];
    
    UILabel * statusLB = [[UILabel alloc] init];
    statusLB.textColor = RGB_HEX(0xAAAAAA);
    statusLB.font = kSFUITextFont(13.0);
    statusLB.text = @"Connect";
    [self addSubview:statusLB];
    _statusLB = statusLB;
    [_statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(statusIv);
        make.left.equalTo(statusIv.mas_right).offset(4);
        make.height.equalTo(statusIv.mas_height);
    }];
}

// 按钮点击
- (void)onClickAction:(UIButton *) sender {
    
    if (_block) _block();
}

- (void) updateUI {

}

- (void) updateUIStatus:(ConnectButtonStatus)status {
    if (status == status_button_disconnected) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.disProgressView.hidden = YES;
            self.progressView.hidden = YES;
            [self resetButtonImage:NO];

            self.statusIv.image = [UIImage imageNamed:@"home_status_connect"];
            self.statusLB.text = @"Connect";
            self.statusLB.textColor = RGB_HEX(0xAAAAAA);
            [self resetLayOut:self.statusLB.text];
        });
    }else if (status == status_button_connected) {
        [self resetButtonImage:YES];
        self.disProgressView.hidden = YES;
        self.progressView.hidden = YES;
        
        self.statusIv.image = [UIImage imageNamed:@"home_status_connected"];
        self.statusLB.text = @"Connected";
        self.statusLB.textColor = RGB_HEX(0x27A3EF);
    }else if (status == status_button_connecting) {
        self.progressView.hidden = NO;
        self.disProgressView.hidden = YES;
        
        self.statusIv.image = [UIImage imageNamed:@"home_status_connected"];
        self.statusLB.text = @"Connecting";
        self.statusLB.textColor = RGB_HEX(0x27A3EF);
    }else if (status == status_button_disconnecting) {
        self.disProgressView.hidden = NO;
        self.progressView.hidden = YES;
        
        self.statusIv.image = [UIImage imageNamed:@"home_status_connect"];
        self.statusLB.text = @"Disconnecting";
        self.statusLB.textColor = RGB_HEX(0xAAAAAA);
    }else if (status == status_button_fail) {
        self.progressView.hidden = YES;
        self.disProgressView.hidden = YES;
        [self resetButtonImage:NO];
        
        self.statusIv.image = [UIImage imageNamed:@"home_status_fail"];
        self.statusLB.text = @"Failed";
        self.statusLB.textColor = RGB_HEX(0xF04646);
    }else if (status == status_button_loading) {
        self.progressView.hidden = NO;
        self.disProgressView.hidden = YES;
        
        self.statusIv.image = [UIImage imageNamed:@"home_status_connected"];
        self.statusLB.text = @"Tunnel is opening";
        self.statusLB.textColor = RGB_HEX(0x27A3EF);
    }
    
    [self resetLayOut:self.statusLB.text];
}

// 是否连接
- (void)resetButtonImage:(BOOL)isLighting {
    NSString* buttonImageName = @"home_not_connect";
    if (isLighting) {
        buttonImageName = @"home_connect";
    }
    _buttonIv.image = [UIImage imageNamed:buttonImageName];
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

- (void)resetLayOut:(NSString *)text {
    CGFloat textW = [self getTextWidthWith:text];
    
    CGFloat totalW = textW+20;
    
    CGFloat imageLeft = 95*kScreenScale - totalW/2;
    
    if (IS_IPAD) {
        imageLeft = 120 - totalW/2;
    }
    
    [_statusIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.left.equalTo(self).offset(imageLeft);
        make.bottom.equalTo(self);
    }];

    [_statusLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.top.equalTo(self.statusIv);
        make.left.equalTo(self.statusIv.mas_right).offset(4);
        make.height.equalTo(self.statusIv.mas_height);
    }];
}

@end
