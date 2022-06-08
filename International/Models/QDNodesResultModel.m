//
//  NodesResultModel.m
//  vpn
//
//  Created by hzg on 2020/12/18.
//

#import "QDNodesResultModel.h"

@implementation QDNodesResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"data" : [QDNodeModel class]};
}

@end
