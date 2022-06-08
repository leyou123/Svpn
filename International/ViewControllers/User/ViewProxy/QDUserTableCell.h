//
//  QDUserTableCell.h
//  International
//
//  Created by LC on 2022/4/18.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDUserTableCell : UITableViewCell

// 名称
@property (nonatomic,strong)UIImageView *cellIconIv;
@property (nonatomic,strong)UILabel     *cellNameLabel;
@property (nonatomic,strong)UILabel     *cellContentLabel;
@property (nonatomic,strong)UIImageView *cellNextImageView;
- (void)configWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
