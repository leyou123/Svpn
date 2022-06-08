//
//  LineOptimalTableViewCell.m
//  vpn
//
//  Created by hzg on 2020/12/23.
//

#import "QDLineOptimalTableViewCell.h"

@implementation QDLineOptimalTableViewCell

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
        make.centerX.equalTo(self);
        make.height.mas_equalTo(61);
        make.top.equalTo(self);
    }];
    
    // 自动推荐标志
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
    
    // auto
    self.nodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeName.textColor = [UIColor blackColor];
    self.nodeName.font = kSFUITextFont(15);
    [imageBgIv addSubview:self.nodeName];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImageView).offset(50);
        make.top.equalTo(imageBgIv).offset(12);
        make.height.mas_equalTo(18);
    }];
    [self.nodeName sizeToFit];
    
    // delay
    self.delayImageView = [UIImageView new];
    [imageBgIv addSubview:self.delayImageView];
    [self.delayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nodeName.mas_bottom).offset(4);
        make.left.equalTo(self.nodeName);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    // desc
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel.textColor = RGB_HEX(0xAAAAAA);
    self.descLabel.font = kSFUITextFont(12);
    [imageBgIv addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.delayImageView.mas_right).offset(8);
//        make.top.equalTo(self.nodeName.mas_bottom);
        make.centerY.equalTo(self.delayImageView);
        make.height.mas_equalTo(14);
    }];
    [self.descLabel sizeToFit];
    
//// 非会员显示标签
//    self.tagView = [UIView new];
//    [self addSubview:self.tagView];
//    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(-32);
//        make.centerY.equalTo(self.nodeName);
//        make.left.equalTo(self.nodeName.mas_right).offset(6);
//        make.height.equalTo(@(16));
//    }];
    

    
    // 选中标志
    self.selectIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.selectIcon.image = [UIImage imageNamed:@"line_not_connect"];
    self.selectIcon.tintColor = [UIColor whiteColor];
    [imageBgIv addSubview:self.selectIcon];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageBgIv);
        make.right.equalTo(imageBgIv).offset(-15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    // 会员标签
    self.memberLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.memberLogo.image = [UIImage imageNamed:@"home_crown"];
    self.memberLogo.tintColor = [UIColor whiteColor];
    [imageBgIv addSubview:self.memberLogo];
    [self.memberLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageBgIv);
        make.right.equalTo(self.selectIcon.mas_left).offset(-12);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)configWithData:(id)data {
    QDNodeModel* model = (QDNodeModel*)data;
    if (!model) return;
    
    // 选中标志
//    [self.selectIcon setHidden:![model.nodeid isEqual:QDConfigManager.shared.node.nodeid]];
    if ([model.nodeid isEqual:QDConfigManager.shared.node.nodeid]) {
        self.selectIcon.image = [UIImage imageNamed:@"line_connect"];
    }else {
        self.selectIcon.image = [UIImage imageNamed:@"line_not_connect"];
    }
    
    // flag
    [self.flagImageView sd_setImageWithURL:[NSURL URLWithString:model.circle_image_url] placeholderImage:[UIImage imageNamed:@"line_flag_default"]];
    
//    NSString* nodeNameString = NSLocalizedString(@"LineAuto", nil);
//    NSString* nodeNameDesc = [model.name isEqualToString:@""] ? @"Click to start connecting" : model.name;
    
    NSString* nodeNameString = model.name;
    NSString* nodeNameDesc = [model.des isEqualToString:@""] ? @"Click to start connecting" : model.des;
    
    if (model.node_type != 1) {
        nodeNameString = model.name;
        nodeNameDesc = [model.des isEqualToString:@""] ? @"Click to start connecting" : model.des;
        self.descLabel.textColor = RGB_HEX(0xFFCA00);
        self.memberLogo.hidden = NO;
    }else {
        self.descLabel.textColor = RGB_HEX(0xAAAAAA);
        self.memberLogo.hidden = YES;
    }
    
    // name&desc
    self.nodeName.text = nodeNameString;
    self.descLabel.text = nodeNameDesc;
//    if (![nodeNameDesc isEqual:@""]) {
//        [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.flagImageView).offset(50);
//            make.centerY.equalTo(self).offset(-8);
//        }];
//    }
    
    // delay
    self.delayImageView.image = [QDLineTableViewBaseCell getDelayImage:model.weights];
    
    // tag
    for (UIView* v in self.tagView.subviews) {
        [v removeFromSuperview];
    }
    
//    // 非会员显示标签
//    if (QDConfigManager.shared.activeModel && ![model.tag isEqual:@""]) {
////        NSString* autoTag = @"Trail, 0";
//        NSArray* tags = [model.tag componentsSeparatedByString:@";"];
//        NSInteger gap = 0;
//        for (NSString* tag in tags) {
//            NSArray* tmp_tags = [tag componentsSeparatedByString:@","];
//            if (tmp_tags&&tmp_tags.count == 2) {
//                NSString* tag_des = tmp_tags[0];
//                int tag_type = [tmp_tags[1] intValue];
//                NSString* tag_img_name = @"line_icon_vip";
//                UIColor* color = [UIColor whiteColor];
//                switch (tag_type) {
//                    case 0:
//                        tag_img_name = @"line_icon_basic";
//                        color = [UIColor blackColor];
//                        break;
//                    case 1:
//                        tag_img_name = @"line_icon_new";
//                        break;
//                    case 2:
//                    default:
//                        break;
//                }
//                UIImageView* tagImageView = [UIImageView new];
//                tagImageView.image = [UIImage imageNamed:tag_img_name];
//                [self.tagView addSubview:tagImageView];
//                [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(@(gap));
//                    make.centerY.equalTo(self.tagView);
//                }];
//                [tagImageView sizeToFit];
//                UILabel* label = [UILabel new];
//                label.text = tag_des;
//                label.font = [UIFont boldSystemFontOfSize:10];
//                [tagImageView addSubview:label];
//                [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.center.equalTo(tagImageView);
//                }];
//                gap += (tagImageView.mj_w + 6);
//            }
//        }
//    }
}


@end
