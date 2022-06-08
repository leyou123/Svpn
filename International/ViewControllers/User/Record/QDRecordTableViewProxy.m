//
//  HomeTableViewProxy.m
//  TZVideo
//
//  Created by Qeye Wang on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDRecordTableViewProxy.h"
#import "QDRecordTableViewDefines.h"
#import "QDRecordTableViewCell.h"
#import "QDOrderRecordModel.h"

@interface QDRecordTableViewProxy () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation QDRecordTableViewProxy

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(TZTVConfigBlock)cBlock action:(TZTVActionBlock)aBlock {
    if (self = [super initWithReuseIdentifier:reuseIdentifier configuration:cBlock action:aBlock]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:NSClassFromString(QDRecordTableViewCellIdentifier) forCellReuseIdentifier:QDRecordTableViewCellIdentifier];
    }
    return self;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return QDRecordTableViewCellHeight;
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
    QDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QDRecordTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.cellConfigBlock) self.cellConfigBlock(cell, self.dataArray[indexPath.row], indexPath);
    return cell;
}
@end
