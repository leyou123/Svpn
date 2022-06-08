//
//  QDUserTableCell.m
//  International
//
//  Created by LC on 2022/4/18.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDUserTableCell.h"

@implementation QDUserTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.cellIconIv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.cellIconIv];
    [self.cellIconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@24);
    }];
    // name
    self.cellNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cellNameLabel.textColor = [UIColor blackColor];
    self.cellNameLabel.font = kSFUITextFont(16);
    [self addSubview:self.cellNameLabel];
    [self.cellNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIconIv.mas_right).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(18));
    }];
    
    self.cellContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cellContentLabel.textColor = RGB_HEX(0x888888);
    self.cellContentLabel.textAlignment = NSTextAlignmentRight;
    self.cellContentLabel.font = kSFUITextFont(13.0);
    [self addSubview:self.cellContentLabel];
    [self.cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-24);
        make.left.equalTo(self.cellNameLabel.mas_right);
        make.centerY.equalTo(self);
//        make.width.equalTo(@(250));
    }];
    
    // next
    self.cellNextImageView = [UIImageView new];
    self.cellNextImageView.image = [UIImage imageNamed:@"line_next"];
    [self addSubview:self.cellNextImageView];
    [self.cellNextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-30);
        make.centerY.equalTo(self);
    }];
    
//    // line
//    UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
//    lineView.backgroundColor = RGB_HEX(0xECECEC);
//    [self addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.leading.equalTo(self);
//        make.height.equalTo(@(0.5));
//        make.bottom.equalTo(self);
//    }];
}

- (void)configWithData:(id)data {
    NSDictionary* model = data;
    if (!model) return;
    
    [self.cellNextImageView setHidden:YES];
    self.cellNameLabel.text = model[@"name"];
    self.cellContentLabel.text = model[@"content"];
    self.cellIconIv.image = [UIImage imageNamed:model[@"image"]];
    int type = [model[@"type"] intValue];
    CGFloat right = 30;
    BOOL isHidden = YES;
    switch (type) {
        case 0:
        case 1:
        case 2:
            break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        {
            isHidden = NO;
            right = 36;
        }
            break;
        case 20:
        case 21:
            break;
        case 22:
        case 23:
        case 24:
        {
            isHidden = NO;
            right = 36;
        }
            break;
        default:
            break;
    }
    [self.cellNameLabel sizeToFit];
    [self.cellNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIconIv.mas_right).offset(12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(18));
    }];
    right = isHidden ? 30 : 49;
    [self.cellNextImageView setHidden:isHidden];
    [self.cellContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-right);
        make.centerY.equalTo(self);
        make.width.equalTo(@(250));
    }];
}

- (CGSize)sizeWithFont:(CGFloat)fontSize textSizeWidht:(CGFloat)widht textSizeHeight:(CGFloat)height text:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kSFUITextFont(fontSize)} context:nil];
    return rect.size;
}
@end
