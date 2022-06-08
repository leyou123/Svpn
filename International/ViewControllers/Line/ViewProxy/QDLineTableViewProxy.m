//
//  HomeTableViewProxy.m
//  TZVideo
//
//  Created by Qeye Wang on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#import "QDLineTableViewProxy.h"
#import "QDLineTableViewDefines.h"
#import "QDNodeModel.h"
#import "QDLineTableViewCell.h"
#import "QDLineOptimalTableViewCell.h"

@interface QDLineTableViewProxy () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation QDLineTableViewProxy

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(TZTVConfigBlock)cBlock action:(TZTVActionBlock)aBlock {
    if (self = [super initWithReuseIdentifier:reuseIdentifier configuration:cBlock action:aBlock]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        for (NSString *className in QDLineTableViewCellIdentifiers.allValues) {
            [self.tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
        }
    }
    return self;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDNodeModel* model = self.dataArray[indexPath.row];
    return [QDLineTableViewCellHeights[@(model.cell_type)] floatValue];
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
    QDNodeModel* model = self.dataArray[indexPath.row];
    QDLineTableViewBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:QDLineTableViewCellIdentifiers[@(model.cell_type)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.cellConfigBlock) self.cellConfigBlock(cell, model, indexPath);
    return cell;
}

@end
