//
//  QDUserCopyTableViewCell.m
//  International
//
//  Created by hzg on 2021/9/14.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDUserCopyTableViewCell.h"

@implementation QDUserCopyTableViewCell

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
    
    // name
    self.cellNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.cellNameLabel.textColor = [UIColor blackColor];
    self.cellNameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.cellNameLabel];
    [self.cellNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.centerY.equalTo(self);
        make.width.equalTo(@(80));
        make.height.equalTo(@(18));
    }];
    
    self.cellContentLabel = [[QDCopyLabel alloc] initWithFrame:CGRectZero];
    self.cellContentLabel.textColor = RGB_HEX(0x888888);
    self.cellContentLabel.textAlignment = NSTextAlignmentRight;
    self.cellContentLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.cellContentLabel];
    [self.cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-24);
        if (!IS_IPAD) make.left.equalTo(self.cellNameLabel.mas_right).offset(24);
        make.centerY.equalTo(self.contentView);
//        make.width.equalTo(@(250));
    }];
    
    // next
    self.cellNextImageView = [UIImageView new];
    self.cellNextImageView.image = [UIImage imageNamed:@"line_next"];
    [self addSubview:self.cellNextImageView];
    [self.cellNextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-32);
        make.centerY.equalTo(self);
    }];
    
    // line
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = RGB_HEX(0xECECEC);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self);
    }];
}

- (void)configWithData:(id)data {
    NSDictionary* model = data;
    if (!model) return;
    
    [self.cellNextImageView setHidden:YES];
    self.cellNameLabel.text = model[@"name"];
    self.cellContentLabel.text = model[@"content"];
    
//    int type = [model[@"type"] intValue];
//    CGFloat right = 24;
//    BOOL isHidden = YES;
//    switch (type) {
//        case 0:
//        case 1:
//        case 2:
//            break;
//        case 3:
//        case 4:
//        case 5:
//        case 6:
//        case 7:
//        case 8:
//        {
//            isHidden = NO;
//            right = 42;
//        }
//            break;
//        case 20:
//        case 21:
//            break;
//        case 22:
//        case 23:
//        case 24:
//        {
//            isHidden = NO;
//            right = 42;
//        }
//            break;
//        default:
//            break;
//    }
//    [self.cellNextImageView setHidden:isHidden];
//    [self.cellContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.cellNameLabel.mas_right).offset(24);
//        make.right.equalTo(self).offset(-right);
//        make.centerY.equalTo(self);
//        make.width.equalTo(@(250));
//    }];
}

@end
