//
//  CSLYErrorView.m
//
//  Created by hzg on 2021/6/24.
//

#import "QDErrorView.h"
#import <AVFoundation/AVFoundation.h>


@implementation QDErrorView


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    // color
    self.backgroundColor = RGB(217, 86, 94);
    
    // label1
    UILabel* label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = NSLocalizedString(@"Config_Install_Fail_Tip", nil);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(10);
    }];
    
    // icon
    UIImageView* icon1 = [UIImageView new];
    icon1.image = [UIImage imageNamed:@"common_error_icon"];
    [self addSubview:icon1];
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-6);
        make.centerY.equalTo(self);
    }];
}

- (void) show {

    SystemSoundID soundID = kSystemSoundID_Vibrate;
    AudioServicesPlayAlertSound(soundID);
    
    [self setHidden:NO];
    self.alpha = 0.5;
    [UIView animateWithDuration:0.2 animations:^{
                    self.alpha = 1;
                } completion:^(BOOL finished) {
                    int seconds = 3;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self hide];
                    });
                }];
    
}

- (void) hide {
    [UIView animateWithDuration:0.5 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self setHidden:YES];
                }];
}

@end
