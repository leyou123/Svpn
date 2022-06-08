//
//  ProductCollectionViewCell.m
//  vpn
//
//  Created by hzg on 2021/1/15.
//

#import "QDProductCollectionViewCell.h"
#import "NSString+FormatFloat.h"
#import "UIUtils.h"

@implementation QDProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 外框
        UIImageView* frameImageView = [UIImageView new];
        [self.contentView addSubview:frameImageView];
        frameImageView.image = [UIImage imageNamed:@"vip_product_bk"];
        [frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.daysImageView = [UIImageView new];
        [frameImageView addSubview:self.daysImageView];
        [self.daysImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(16));
            make.centerX.equalTo(frameImageView);
        }];
        
        UIImageView* iconImageView = [UIImageView new];
        [frameImageView addSubview:iconImageView];
        iconImageView.image = [UIImage imageNamed:@"vip_day"];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.daysImageView.mas_bottom).offset(10);
            make.centerX.equalTo(frameImageView);
        }];
        
        _priceLabel = [UILabel new];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self.contentView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-35);
        }];
        
        self.hotImageView = [UIImageView new];
        [frameImageView addSubview:self.hotImageView];
        self.hotImageView.image = [UIImage imageNamed:@"vip_hot"];
        [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(frameImageView).offset(-4);
            make.top.equalTo(self.priceLabel.mas_bottom);
        }];
        UILabel* hotlabel = [UILabel new];
        hotlabel.text = NSLocalizedString(@"VIP_Hot", nil);
        hotlabel.textColor = [UIColor whiteColor];
        hotlabel.font = [UIFont systemFontOfSize:10];
        [self.hotImageView addSubview:hotlabel];
        [hotlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.hotImageView);
        }];
    }
    return self;
}
- (void)configCellWithModel:(id)model isSelected:(BOOL)isSelected {
    
    NSDictionary* dict = model;
    
    // hot
    BOOL isHot = [dict[@"isHot"] boolValue];
    [self.hotImageView setHidden:!isHot];
    
    // vip days
    self.daysImageView.image = [UIImage imageNamed:dict[@"days"]];
    
    // 价格
    [UIUtils showMoney:self.priceLabel subcribePrice:dict[@"price"] subcribeName:dict[@"product_id"] format:@"%@"];
    
    self.priceLabel.textColor = isSelected ? [UIColor orangeColor] : [UIColor colorWithRed:0.0/255.0 green:185.0/255.0 blue:236.0/255.0 alpha:1];
}

@end
