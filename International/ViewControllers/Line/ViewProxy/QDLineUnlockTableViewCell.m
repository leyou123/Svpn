//
//  QDLineUnlockTableViewCell.m
//  International
//
//  Created by hzg on 2022/2/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDLineUnlockTableViewCell.h"
#import "QDSizeUtils.h"
#import "YJAnimateUtils.h"

@implementation QDLineUnlockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    // desc
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel.textColor = RGB_HEX(0x27A3EF);
    self.descLabel.text = NSLocalizedString(@"LineUnlock", nil);
    self.descLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.descLabel sizeToFit];
    
    // 箭头
    _progressView = [UIImageView new];
    _progressView.image = [[UIImage imageNamed:@"arrow_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _progressView.tintColor = [UIColor blackColor];
    [self addSubview:_progressView];
    CGFloat tx = -(self.descLabel.mj_w/2 + 16);
    CGFloat ty = 0, th = 10;
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(tx);
    }];
    CGPoint startPoint = CGPointMake([QDSizeUtils is_width]/2 + tx, self.mj_h/2 - th/2);
    [self.progressView.layer addAnimation:[YJAnimateUtils translateAnimationForever:startPoint endPoint:CGPointMake(startPoint.x, self.mj_h/2 + th/2)] forKey:@"tanslateAnimation"];
}

- (void)configWithData:(id)data {
}

@end
