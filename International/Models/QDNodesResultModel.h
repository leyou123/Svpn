//
//  NodesResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/18.
//

#import "QDBaseResultModel.h"
#import "QDNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDNodesResultModel : QDBaseResultModel

@property(nonatomic, copy) NSArray* data;

@end

NS_ASSUME_NONNULL_END
