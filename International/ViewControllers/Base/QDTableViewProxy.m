//
//  TZTableViewProxy.m
//  TZVideo
//
//  Created by TanZhou on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDTableViewProxy.h"

@interface QDTableViewProxy () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation QDTableViewProxy

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(TZTVConfigBlock)cBlock action:(TZTVActionBlock)aBlock {
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
        _cellConfigBlock = cBlock;
        _cellActionBlock = aBlock;
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellActionBlock) {
        _cellActionBlock([tableView cellForRowAtIndexPath:indexPath], _dataArray[indexPath.row], indexPath);
    }
}

#pragma mark tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier forIndexPath:indexPath];
    if (_cellConfigBlock) _cellConfigBlock(cell, _dataArray[indexPath.row], indexPath);
    return cell;
}
@end
