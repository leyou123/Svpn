//
//  TZTableViewCell.m
//  TZVideo
//
//  Created by TanZhou on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDTableViewCell.h"

@implementation QDTableViewCell

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.selectionStyle = UITableViewCellStyleDefault;
//    }
//    return self;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setup {
    
}

- (void)configWithData:(id)data {
    
}
@end
