//
//  NodesResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/18.
//

#import "QDBaseResultModel.h"
#import "QDNodeModel.h"
#import "QDNodeTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDNodesResultModel : QDBaseResultModel

@property(nonatomic, copy) NSArray* data;
// 是否隐藏线路
@property (nonatomic, assign) int node_hide_switch;
    
@property(nonatomic, copy) NSArray* test_nodes;

@end

NS_ASSUME_NONNULL_END
