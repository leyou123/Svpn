//
//  ProductResultModel.m
//  vpn
//
//  Created by hzg on 2020/12/21.
//

#import "QDProductResultModel.h"
#import "QDProductModel.h"

@implementation QDProductResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"data" : [QDProductModel class]};
}

@end
