//
//  LineOptimalTableViewCell.h
//  vpn
//
//  Created by hzg on 2020/12/23.
//

#import "QDLineTableViewBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLineOptimalTableViewCell : QDLineTableViewBaseCell

// 选中标志
@property (nonatomic,strong)UIImageView *selectIcon;
// 会员标志
@property (nonatomic,strong)UIImageView *memberLogo;
// 国旗/自动选择的icon
@property (nonatomic,strong)UIImageView *flagImageView;
@property (nonatomic,strong)UILabel     *nodeName;
// 描述: 自动推荐的节点显示国家：节点名称； 其它： 显示desc
@property (nonatomic,strong)UILabel     *descLabel;

@property (nonatomic,strong)UIView      *tagView;
@property (nonatomic,strong)UIImageView *delayImageView;

@end

NS_ASSUME_NONNULL_END
