//
//  QDLineTableViewDefines.h
//
//  Created by Qeye Wang on 24/03/2018.
//  Copyright © 2018 tztv. All rights reserved.
//

#ifndef QDLineTableViewDefines_h
#define QDLineTableViewDefines_h

// 节点类型：-1表示未分配 0表示自动推荐节点 1表示section, 2表示normal  3表示可展开收缩的
// 4表示QDLineSubTableViewCell 5表示QDLineUnlockTableViewCell
#define QDLineTableViewCellIdentifiers  @{@(0): @"QDLineOptimalTableViewCell",\
    @(1): @"QDLineSectionTableViewCell", \
    @(2): @"QDLineTableViewCell", \
    @(3): @"QDLineExpandTableViewCell",\
    @(4): @"QDLineSubTableViewCell",\
    @(5): @"QDLineUnlockTableViewCell"}

#define QDLineTableViewCellHeights @{@(0): @(73),\
                                   @(1): @(30),\
                                   @(2): @(73),\
                                   @(3): @(73),\
                                   @(4): @(200),\
                                   @(5): @(50)}

#endif /* QDLineTableViewDefines_h */
