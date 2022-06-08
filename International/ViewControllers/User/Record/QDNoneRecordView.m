//
//  NoneRecordView.m
//  vpn
//
//  Created by hzg on 2020/12/24.
//

#import "QDNoneRecordView.h"

@interface QDNoneRecordView()
@property(nonatomic, copy) ClickBlock block;
@end

@implementation QDNoneRecordView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(ClickBlock) block {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:block];
    }
    return self;
}

- (void) setup:(ClickBlock) block {
    _block = block;
    
    // 透明
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView* icon = [[UIImageView alloc] init];
    icon.image        = [UIImage imageNamed:@"user_no_record"];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
    }];
    
    UILabel* buttonText = [UILabel new];
    buttonText.text = NSLocalizedString(@"Record_No", nil);
    buttonText.font = [UIFont boldSystemFontOfSize:20];
    buttonText.textColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:247.0/255.0 alpha:1];
    [self addSubview:buttonText];
    [buttonText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];

}

- (void) clickAction {
    if (_block) _block();
}



@end
