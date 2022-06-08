//
//  TZCollectionViewProxy.h
//  TZVideo
//
//  Created by TanZhou on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TZCVConfigBlock)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath);
typedef void(^TZCVActionBlock)(UICollectionViewCell *cell, id cellData, NSIndexPath *indexPath);

@interface QDCollectionViewProxy : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (copy) TZCVConfigBlock cellConfigBlock;
@property (copy) TZCVActionBlock cellActionBlock;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                          configuration:(TZCVConfigBlock)cBlock
                                 action:(TZCVActionBlock)aBlock NS_DESIGNATED_INITIALIZER;

@end
