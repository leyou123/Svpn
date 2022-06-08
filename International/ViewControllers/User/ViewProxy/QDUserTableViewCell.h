//
//  HomeTwoTableViewCell.h
//  TZVideo
//
//  Created by Qeye Wang on 2018/4/10.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDTableViewCell.h"

@interface QDUserTableViewCell : QDTableViewCell

// 名称
@property (nonatomic,strong)UILabel     *cellNameLabel;
@property (nonatomic,strong)UILabel     *cellContentLabel;
@property (nonatomic,strong)UIImageView *cellNextImageView;

@end
