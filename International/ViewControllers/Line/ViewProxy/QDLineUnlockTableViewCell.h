//
//  QDLineUnlockTableViewCell.h
//  International
//
//  Created by hzg on 2022/2/9.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDLineTableViewBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDLineUnlockTableViewCell : QDLineTableViewBaseCell

@property (nonatomic,strong)UIImageView *progressView;
@property (nonatomic,strong)UILabel     *descLabel;

@end

NS_ASSUME_NONNULL_END
