//
//  HomeTwoTableViewCell.h
//  TZVideo
//
//  Created by Qeye Wang on 2018/4/10.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDTableViewCell.h"

@interface QDRecordTableViewCell : QDTableViewCell

@property (nonatomic,strong)UILabel *productName;
@property (nonatomic,strong)UILabel *purchaseDate;
@property (nonatomic,strong)UILabel *price;
@property (nonatomic,strong)UIView  *lineView;

@end
