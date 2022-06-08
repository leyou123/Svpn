//
//  QDUserCopyTableViewCell.h
//  International
//
//  Created by hzg on 2021/9/14.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDTableViewCell.h"
#import "QDCopyLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDUserCopyTableViewCell : QDTableViewCell

// 名称
@property (nonatomic,strong)UILabel         *cellNameLabel;
@property (nonatomic,strong)QDCopyLabel     *cellContentLabel;
@property (nonatomic,strong)UIImageView     *cellNextImageView;

@end

NS_ASSUME_NONNULL_END
