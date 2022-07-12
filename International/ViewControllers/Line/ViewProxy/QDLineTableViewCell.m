//
//  LineTableViewCell.m
//  TZVideo
//
//  Created by Qeye Wang on 2018/4/10.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDLineTableViewCell.h"
#import "QDNodeModel.h"

@implementation QDLineTableViewCell

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
        make.height.mas_equalTo(61);
        make.top.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    // flag
    self.flagImageView = [[UIImageView alloc] init];
    self.flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageBgIv addSubview:self.flagImageView];
    self.flagImageView.layer.shadowColor = RGB_HEX(0xcccccc).CGColor;
    self.flagImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.flagImageView.layer.shadowOpacity = 1;
    self.flagImageView.layer.shadowRadius = 1;
    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageBgIv).offset(15);
        make.centerY.equalTo(imageBgIv);
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    
    // name
    self.nodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeName.textColor = [UIColor blackColor];
    self.nodeName.font = [UIFont boldSystemFontOfSize:14];
    [imageBgIv addSubview:self.nodeName];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImageView).offset(50);
        make.top.equalTo(imageBgIv).offset(12);
        make.height.mas_equalTo(18);
    }];
    
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
    self.descLabel.textColor = RGB_HEX(0x888888);
    self.descLabel.font = [UIFont systemFontOfSize:12];
    [imageBgIv addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.delayImageView.mas_right).offset(8);
        make.centerY.equalTo(self.delayImageView);
        make.height.mas_equalTo(14);
    }];
    [self.descLabel sizeToFit];

//    self.tagView = [UIView new];
//    [self addSubview:self.tagView];
//    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(-32);
//        make.centerY.equalTo(self.nodeName);
//        make.left.equalTo(self.nodeName.mas_right).offset(6);
//        make.height.equalTo(@(16));
//    }];
//
//    // delay
//    self.delayImageView = [UIImageView new];
//    [self addSubview:self.delayImageView];
//    [self.delayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(-32);
//        make.centerY.equalTo(self);
//        make.width.equalTo(@(15));
//        make.height.equalTo(@(15));
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

}

- (void)configWithData:(id)data {
    QDNodeModel* model = (QDNodeModel*)data;
    if (!model) return;
    
    // select
    if ([model.nodeid isEqual:QDConfigManager.shared.node.nodeid]) {
        self.selectIcon.image = [UIImage imageNamed:@"line_connect"];
    }else {
        self.selectIcon.image = [UIImage imageNamed:@"line_not_connect"];
    }
    
    // flag
    [self.flagImageView sd_setImageWithURL:[NSURL URLWithString:model.circle_image_url] placeholderImage:[UIImage imageNamed:@"line_flag_default"]];
    
    // name
    self.nodeName.text = model.name;

    // desc
    self.descLabel.text = [model.des isEqualToString:@""] ? @"Click to start connecting" : model.des;
//    CGFloat offset = ![model.des isEqual:@""] ? -8 : 0;
//    [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.flagImageView).offset(50);
//        make.centerY.equalTo(self).offset(offset);
//    }];
    
    // delay
//    self.delayImageView.image = [QDLineTableViewBaseCell getDelayImage:model.weights];
    
//    self.delayImageView.image = [QDLineTableViewBaseCell getSpeedImage:model.pingResult];
    if (model.pingResult == 1) {
        self.delayImageView.image = [QDLineTableViewBaseCell getDelayImage:model.weights];
    }else {
        self.delayImageView.image = [QDLineTableViewBaseCell getSpeedImage:model.pingResult];
    }
    
    // tag
    for (UIView* v in self.tagView.subviews) {
        [v removeFromSuperview];
    }
    
    // 显示标签
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
