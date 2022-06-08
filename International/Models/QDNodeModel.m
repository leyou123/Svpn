//
//  NodeModel.m
//  vpn
//
//  Created by hzg on 2020/12/14.
//

#import "QDNodeModel.h"

@implementation QDNodeModel

//模型和字典的字段不对应需要转化
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nodeid":@"id", @"des":@"description"};
}



@end
