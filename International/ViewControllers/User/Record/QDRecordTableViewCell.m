//
//  LineTableViewCell.m
//  TZVideo
//
//  Created by Qeye Wang on 2018/4/10.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDRecordTableViewCell.h"
#import "QDOrderRecordModel.h"
#import "QDDateUtils.h"
#import "UIUtils.h"

@implementation QDRecordTableViewCell

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
    
    UIImage* image = [UIImage imageNamed:@"home_node_back"];
    UIImageView* backView = [UIImageView new];
    backView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        make.height.equalTo(@(45));
    }];
    
    // name
    self.productName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productName.textColor = [UIColor blackColor];
    self.productName.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.productName];
    [self.productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);
        make.centerY.equalTo(backView).offset(-10);
        make.height.equalTo(@(18));
    }];
    
    // date
    self.purchaseDate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.purchaseDate.textColor = [UIColor blackColor];
    self.purchaseDate.font = [UIFont boldSystemFontOfSize:10];
    [backView addSubview:self.purchaseDate];
    [self.purchaseDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);
        make.centerY.equalTo(backView).offset(10);
        make.height.equalTo(@(18));
    }];
    
    // price
    self.price = [[UILabel alloc] initWithFrame:CGRectZero];
    self.price.textColor = [UIColor blackColor];
    self.price.font = [UIFont systemFontOfSize:20];
    [backView addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(backView).offset(-20);
        make.centerY.equalTo(backView);
    }];
    
    // line
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = RGB_HEX(0xECECEC);
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20);
        make.trailing.equalTo(self).offset(-20);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(self);
    }];
}

- (void)configWithData:(id)data {
    QDOrderRecordModel* model = (QDOrderRecordModel*)data;
    if (!model) return;
    
    // productName
    self.productName.text = model.product_name;
    
    // price
    [UIUtils showMoney:self.price subcribePrice:model.total_amount subcribeName:model.product_id format:@"%@"];
//    self.price.text = model.total_amount;
    
    // time
    self.purchaseDate.text = [QDDateUtils formatYYMMDDHHMMSSFromUTCTimestamp:model.product_time/1000];
    
//    // line
//    [self.lineView setHidden:!model.showline];
}


@end
