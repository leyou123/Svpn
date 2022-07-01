//
//  QDLineButtonView.m
//  International
//
//  Created by hzg on 2021/6/8.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLineButtonView.h"
#import "QDLineTableViewBaseCell.h"
#import "QDSizeUtils.h"

@interface QDLineButtonView()
@property(nonatomic, copy) NodeClickBlock block;
@property (nonatomic,strong)UIImageView *flagImageView;
@property (nonatomic,strong)UILabel     *nodeName;
@property (nonatomic,strong)UIView      *lineView;

// 节点延迟
@property (nonatomic,strong)UIImageView *delayImageView;
@property (nonatomic,strong)UIImageView *nextImageView;

@property (nonatomic,strong)UILabel     *descLabel;
@property (nonatomic,strong)UIView      *tagView;

@property (nonatomic,strong)UIImageView * flagBgIv;

@property (nonatomic, strong) UIButton* button;

@end

@implementation QDLineButtonView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(NodeClickBlock) block {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame clickBlock:block];
    }
    return self;
}

- (void) setup:(CGRect)frame clickBlock:(NodeClickBlock)block {
    
//    self.layer.cornerRadius = 10.0;
//    self.layer.masksToBounds = YES;
//    self.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.layer.borderWidth = 1.0;

    _block = block;
    
    // button
    UIButton* button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"home_line_bg"] forState:UIControlStateNormal];
    [self addSubview:button];
    _button = button;
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    // select
//    UIImageView* backImageView = [UIImageView new];
//    UIImage* image = [UIImage imageNamed:@"line_back"];
//    backImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
//    [button addSubview:backImageView];
//    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(button);
//    }];
    
//    // location
//    UIImageView* locationImageView = [UIImageView new];
//    locationImageView.image = [UIImage imageNamed:@"line_icon_location"];
//    [button addSubview:locationImageView];
//    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(24);
//        make.centerY.equalTo(self);
//        make.width.equalTo(@(19));
//        make.height.equalTo(@(24));
//    }];
    
    UIImageView * flagBgIv = [[UIImageView alloc] init];
    flagBgIv.image = [UIImage imageNamed:@"home_flagBg"];
    flagBgIv.layer.cornerRadius = 10;
    flagBgIv.layer.masksToBounds = YES;
    [self addSubview:flagBgIv];
    _flagBgIv = flagBgIv;
    [self.flagBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(27*kScreenScale);
        make.centerY.equalTo(self);
        if (IS_IPAD) {
            make.width.height.equalTo(@(70));
        }else {
            make.width.height.equalTo(@(50*kScreenScale));
        }
    }];
    
    // flag
    self.flagImageView = [[UIImageView alloc] init];
    self.flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.flagImageView.layer.shadowColor = RGB_HEX(0xcccccc).CGColor;
    self.flagImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.flagImageView.layer.shadowOpacity = 1;
    self.flagImageView.layer.shadowRadius = 1;
    [flagBgIv addSubview:self.flagImageView];
    [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(flagBgIv);
        if (IS_IPAD) {
            make.width.height.equalTo(@(50));
        }else {
            make.width.height.equalTo(@(30*kScreenScale));
        }
    }];
    
    // name
    self.nodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeName.textColor = [UIColor whiteColor];
    self.nodeName.font = kSFUITextFont(16);
    [self addSubview:self.nodeName];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagBgIv.mas_right).offset(16);
        make.centerY.equalTo(self);
        make.right.equalTo(@(-70));
        make.height.equalTo(@(18));
    }];
    
    // desc
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.descLabel.textColor = RGB_HEX(0x888888);
    self.descLabel.textColor = RGB_HEX(0xFFFFFF);
    self.descLabel.font = kSFUITextFont(12);
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nodeName);
        make.top.equalTo(self.nodeName.mas_bottom).offset(2);
        make.right.equalTo(@(-70));
    }];
    [self.descLabel sizeToFit];
    
    // delay
    self.delayImageView = [UIImageView new];
    [button addSubview:self.delayImageView];
    [self.delayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-47*kScreenScale);
        make.centerY.equalTo(self);
        make.width.equalTo(@(20*kScreenScale));
        make.height.equalTo(@(20*kScreenScale));
    }];
    
    // next
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.image = [UIImage imageNamed:@"home_arrow"];
    [button addSubview:_nextImageView];
    [_nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(button).offset(-20*kScreenScale);
        make.centerY.equalTo(button);
    }];
    
//    // line
//    UIView* lineView = [[UIView alloc] initWithFrame:CGRectZero];
//    lineView.backgroundColor = RGB_HEX(0xe5eff0);
//    [button addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(button).offset(24);
//        make.trailing.equalTo(button).offset(-24);
//        make.height.equalTo(@(0.5));
//        make.bottom.equalTo(button);
//    }];
}

- (void) clickAction {
    if (_block) _block();
}

// 更新节点
- (void) updateNode:(QDNodeModel*)model {
    
    if (!model) return;
    
    // flag
    [self.flagImageView sd_setImageWithURL:[NSURL URLWithString:model.circle_image_url] placeholderImage:[UIImage imageNamed:@"line_flag_default"]];
    
    NSString* nodeName;
    NSString* des;
    if (model.cell_type == 0) {
        nodeName = @"Optimal Location";
        des = model.name;
    }else {
        nodeName = @"Current Location";
        des =  model.name;
    }
//    NSString* nodeName = model.cell_type == 0 ? @"Optimal Location" : @"Current Location";
//    NSString* des = model.cell_type == 0 ? model.name : model.des;
    
    // name
    self.nodeName.text = nodeName;
    if (![des isEqual:@""]) {
        [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagBgIv.mas_right).offset(12);
            make.centerY.equalTo(self).offset(-8);
            make.right.equalTo(@(-70));
        }];
    } else {
        [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagBgIv.mas_right).offset(12);
            make.centerY.equalTo(self);
            make.right.equalTo(@(-70));
        }];
    }
    
    // desc
    self.descLabel.text = des;
    
    
    // delay
//    self.delayImageView.image = [QDLineTableViewBaseCell getDelayImage:model.weights];
    
    self.delayImageView.image = [QDLineTableViewBaseCell getSpeedImage:model.pingResult];


}

- (void) updateNode:(QDNodeModel*)model selectLines:(BOOL)select {
    if (!model) return;
    
    // flag
    [self.flagImageView sd_setImageWithURL:[NSURL URLWithString:model.circle_image_url] placeholderImage:[UIImage imageNamed:@"line_flag_default"]];
    
    NSString* nodeName;
    NSString* des;
    if (select) {
        nodeName = @"Current Location";
        des = model.name;
    }else {
        nodeName = @"Optimal Location";
        des = model.name;
    }
    
    // name
    self.nodeName.text = nodeName;
    if (![des isEqual:@""]) {
        [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagBgIv.mas_right).offset(12);
            make.centerY.equalTo(self).offset(-8);
            make.right.equalTo(@(-70));
        }];
    } else {
        [self.nodeName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.flagBgIv.mas_right).offset(12);
            make.centerY.equalTo(self);
            make.right.equalTo(@(-70));
        }];
    }
    
    // desc
    self.descLabel.text = des;
    
    
    // delay
//    self.delayImageView.image = [QDLineTableViewBaseCell getDelayImage:model.weights];
    
    self.delayImageView.image = [QDLineTableViewBaseCell getSpeedImage:model.pingResult];

}

- (void)setNodeColor:(UIColor *)nodeColor {
    self.nodeName.textColor = nodeColor;
}

- (void)setDescColor:(UIColor *)descColor {
    self.descLabel.textColor = descColor;
}

- (void)setImageName:(NSString *)imageName {
    [_button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
