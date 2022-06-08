//
//  ProductCollectionViewCell.h
//  vpn
//
//  Created by hzg on 2021/1/15.
//

#import "QDCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDProductCollectionViewCell : QDCollectionViewCell

@property (strong, nonatomic) UIImageView *daysImageView;
@property (strong, nonatomic) UILabel     *priceLabel;
@property (strong, nonatomic) UIImageView *hotImageView;

- (void)configCellWithModel:(id)model isSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
