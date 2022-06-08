//
//  CSLYLineSectionTableViewCell.m
//  StormVPN
//
//  Created by hzg on 2021/6/10.
//

#import "QDLineSectionTableViewCell.h"

@implementation QDLineSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.backgroundColor = [UIColor clearColor];
    
    // name
    self.nodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nodeName.textColor = RGB_HEX(0x888888);
    self.nodeName.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nodeName];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(32));
        make.centerY.equalTo(self);
    }];
}

- (void)configWithData:(id)data {
    QDNodeModel* model = (QDNodeModel*)data;
    if (!model) return;
    
    // name
    self.nodeName.text = model.name;
}

@end
