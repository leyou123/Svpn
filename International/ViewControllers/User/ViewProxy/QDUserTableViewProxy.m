//
//  HomeTableViewProxy.m
//  TZVideo
//
//  Created by Qeye Wang on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDUserTableViewProxy.h"
#import "QDUserTableViewDefines.h"
#import "QDUserTableViewCell.h"

@interface QDUserTableViewProxy () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation QDUserTableViewProxy

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(TZTVConfigBlock)cBlock action:(TZTVActionBlock)aBlock {
    if (self = [super initWithReuseIdentifier:reuseIdentifier configuration:cBlock action:aBlock]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        for (NSString *className in QDUserTableViewCellIdentifiers.allValues) {
            [self.tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
        }
    }
    return self;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return QDUserTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellActionBlock) {
        self.cellActionBlock([tableView cellForRowAtIndexPath:indexPath], self.dataArray[indexPath.row], indexPath);
    }
}

#pragma mark tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellType = [self.dataArray[indexPath.row][@"type"] integerValue];
    if (cellType == 0 || cellType == 20) cellType = 0;
    else cellType = 1;
    QDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QDUserTableViewCellIdentifiers[@(cellType)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.cellConfigBlock) self.cellConfigBlock(cell, self.dataArray[indexPath.row], indexPath);
    return cell;
}
@end
