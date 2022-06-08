//
//  TZTableViewProxy.h
//  TZVideo
//
//  Created by TanZhou on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDTableViewCell.h"

typedef void(^TZTVConfigBlock)(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath);
typedef void(^TZTVActionBlock)(QDTableViewCell *cell, id cellData, NSIndexPath *indexPath);

@interface QDTableViewProxy : NSObject

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (copy) TZTVConfigBlock cellConfigBlock;
@property (copy) TZTVActionBlock cellActionBlock;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                          configuration:(TZTVConfigBlock)cBlock
                                 action:(TZTVActionBlock)aBlock NS_DESIGNATED_INITIALIZER;

@end
