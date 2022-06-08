//
//  OrderRecordResultModel.m
//  vpn
//
//  Created by hzg on 2020/12/28.
//

#import "QDOrderRecordResultModel.h"
#import "QDOrderRecordModel.h"

@implementation QDOrderRecordResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"data" : [QDOrderRecordModel class]};
}

@end
