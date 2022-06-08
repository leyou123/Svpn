//
//  QDLineSubTableViewCell.m
//  International
//
//  Created by hzg on 2021/8/5.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDLineSubTableViewCell.h"
#import "GADTSmallTemplateView.h"

@interface QDLineSubTableViewCell()

@property (nonatomic,strong)UIImageView          *placeHolderImageView;
@property (nonatomic,strong)GADTSmallTemplateView *smallTemplateView;

@end

@implementation QDLineSubTableViewCell

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
    
    // flag
    self.placeHolderImageView = [[UIImageView alloc] init];
    self.placeHolderImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.placeHolderImageView.image = [UIImage imageNamed:@"line_sub_headview"];
    [self.contentView addSubview:self.placeHolderImageView];
    [self.placeHolderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self setupAdView];
}

- (void) setupAdView {
    
    self.smallTemplateView = [[GADTSmallTemplateView alloc] init];
    [self.contentView addSubview:self.smallTemplateView];
    self.smallTemplateView.layer.cornerRadius = 6;
    self.smallTemplateView.layer.masksToBounds = YES;
    [self.smallTemplateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    NSString *myBlueColor = @"#5C84F0";
    NSDictionary *styles = @{
        GADTNativeTemplateStyleKeyCallToActionFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyCallToActionFontColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCallToActionBackgroundColor :
            [GADTTemplateView colorFromHexString:myBlueColor],
        GADTNativeTemplateStyleKeySecondaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeySecondaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeySecondaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyPrimaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyPrimaryFontColor : UIColor.blackColor,
        GADTNativeTemplateStyleKeyPrimaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyTertiaryFont : [UIFont systemFontOfSize:15.0],
        GADTNativeTemplateStyleKeyTertiaryFontColor : UIColor.grayColor,
        GADTNativeTemplateStyleKeyTertiaryBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyMainBackgroundColor : UIColor.whiteColor,
        GADTNativeTemplateStyleKeyCornerRadius : [NSNumber numberWithFloat:7.0],
    };

    self.smallTemplateView.styles = styles;

    // STEP 6: Set the ad for your template to render.
//    templateView.nativeAd = nativeAd;

    // STEP 7 (Optional): If you'd like your template view to span the width of your
    // superview call this method.
//    [templateView addHorizontalConstraintsToSuperviewWidth];
//    [templateView addVerticalCenterConstraintToSuperview];
}

- (void)configWithData:(id)data {
    QDNodeModel* model = (QDNodeModel*)data;
    if (!model) return;
    
    BOOL isVIP = QDConfigManager.shared.activeModel && QDConfigManager.shared.activeModel.member_type == 1;
    [self.placeHolderImageView setHidden:!isVIP];
    [self.smallTemplateView setHidden:isVIP];
    if (!isVIP) {
        [QDAdManager.shared showNativeAd:self.smallTemplateView];
    }
}

@end
