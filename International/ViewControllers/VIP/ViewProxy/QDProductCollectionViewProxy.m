//
//  ProductCollectionViewProxy.m
//  vpn
//
//  Created by hzg on 2021/1/15.
//

#import "QDProductCollectionViewProxy.h"
#import "QDSizeUtils.h"

@interface QDProductCollectionViewProxy()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation QDProductCollectionViewProxy 

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(TZCVConfigBlock)cBlock action:(TZCVActionBlock)aBlock {
    if (self = [super initWithReuseIdentifier:reuseIdentifier configuration:cBlock action:aBlock]) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:NSClassFromString(reuseIdentifier) forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QDProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    if (self.cellConfigBlock) {
        self.cellConfigBlock(cell, self.dataArray[indexPath.row], indexPath);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 168);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat width = MIN([QDSizeUtils is_width], [QDSizeUtils is_height]);
    CGFloat gap = (width - 90*4 - 3*4)/2;
    if (gap < 0) gap = 0;
    return UIEdgeInsetsMake(0, gap, 0, gap);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
