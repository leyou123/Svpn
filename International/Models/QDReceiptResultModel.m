//
//  ReceiptResultModel.m
//  vpn
//
//  Created by hzg on 2020/12/31.
//

#import "QDReceiptResultModel.h"
#import "QDReceiptModel.h"

@implementation QDReceiptResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"data" : [QDReceiptModel class]};
}

@end
