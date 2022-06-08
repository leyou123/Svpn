//
//  HomeTwoTableViewCell.h
//  TZVideo
//
//  Created by Qeye Wang on 2018/4/10.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDLineTableViewBaseCell.h"

@interface QDLineTableViewCell : QDLineTableViewBaseCell

@property (nonatomic,strong)UIImageView *flagImageView;
@property (nonatomic,strong)UIImageView *selectIcon;
@property (nonatomic,strong)UILabel     *nodeName;
//@property (nonatomic,strong)UIView      *lineView;
@property (nonatomic,strong)UILabel     *descLabel;

// 连接人数/节点延迟
@property (nonatomic,strong)UIImageView *delayImageView;
@property (nonatomic,strong)UIView      *tagView;

@end
