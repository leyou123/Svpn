//
//  CSLYLineExpandTableViewCell.m
//  StormVPN
//
//  Created by hzg on 2021/6/10.
//

#import "QDLineExpandTableViewCell.h"

@implementation QDLineExpandTableViewCell

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
    
    UIImageView * imageBgIv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"line_item_bg"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:0];
    imageBgIv.image = image;
    [self addSubview:imageBgIv];
    [imageBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(61);;
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    // flag
    self.flagImageView = [[UIImageView alloc] init];
    self.flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.flagImageView.layer.shadowColor = RGB_HEX(0xcccccc).CGColor;
    self.flagImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.flagImageView.layer.shadowOpacity = 1;
    self.flagImageView.layer.shadowRadius = 1;
    [imageBgIv addSubview:self.flagImageView];
    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgIv).offset(15);
        make.centerY.equalTo(imageBgIv);
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    
    // name
    self.nodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeName.textColor = [UIColor blackColor];
    self.nodeName.font = kSFUITextFont(15);
    [imageBgIv addSubview:self.nodeName];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImageView).offset(50);
        make.top.equalTo(imageBgIv).offset(15);
        make.height.mas_equalTo(18);
    }];
    
    // location count
    self.nodeLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeLocation.textColor = RGB_HEX(0xFFCA00);
    self.nodeLocation.font = kSFUITextFont(12);
    [imageBgIv addSubview:self.nodeLocation];
    [self.nodeLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nodeName);
        make.top.equalTo(self.nodeName.mas_bottom);
        make.height.mas_equalTo(14);
    }];
    
    // expand
    self.nextImageView = [UIImageView new];
    self.nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageBgIv addSubview:self.nextImageView];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(imageBgIv).offset(-15);
        make.centerY.equalTo(imageBgIv);
    }];
    
    // 会员标签
    self.memberLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.memberLogo.image = [UIImage imageNamed:@"home_crown"];
    self.memberLogo.tintColor = [UIColor whiteColor];
    [imageBgIv addSubview:self.memberLogo];
    [self.memberLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageBgIv);
        make.right.equalTo(self.nextImageView.mas_left).offset(-12);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)configWithData:(id)data {
    QDNodeModel* model = (QDNodeModel*)data;
    if (!model) return;
    
    // flag
    [self.flagImageView sd_setImageWithURL:[NSURL URLWithString:model.circle_image_url] placeholderImage:[UIImage imageNamed:@"line_flag_default"]];
    
    // name
    self.nodeName.text = model.name;
    
    self.nodeLocation.text = [NSString stringWithFormat:@"%ld Location",model.subNodes.count];
    
    // next
    NSString* nextName = model.cell_expand ? @"line_icon_down" : @"line_next";
    self.nextImageView.image = [UIImage imageNamed:nextName];
}

@end
