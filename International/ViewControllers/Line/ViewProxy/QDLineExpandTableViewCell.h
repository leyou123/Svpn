//
//  CSLYLineExpandTableViewCell.h
//  StormVPN
//
//  Created by hzg on 2021/6/10.
//

#import "QDLineTableViewBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLineExpandTableViewCell : QDLineTableViewBaseCell

@property (nonatomic,strong)UIImageView *flagImageView;
@property (nonatomic,strong)UILabel     *nodeName;
@property (nonatomic,strong)UILabel     *nodeLocation;
@property (nonatomic,strong)UIImageView *nextImageView;
// 会员标志
@property (nonatomic,strong)UIImageView *memberLogo;

@end

NS_ASSUME_NONNULL_END
