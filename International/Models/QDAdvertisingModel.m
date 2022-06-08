//
//  QDAdvertisingModel.m
//  International
//
//  Created by hzg on 2021/6/17.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDAdvertisingModel.h"

@implementation QDAdvertisingModel

//模型和字典的字段不对应需要转化
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"des":@"description"};
}

@end
