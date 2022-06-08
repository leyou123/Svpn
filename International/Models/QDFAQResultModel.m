//
//  FAQResultModel.m
//  vpn
//
//  Created by hzg on 2020/12/29.
//

#import "QDFAQResultModel.h"
#import "QDFAQModel.h"

@implementation QDFAQResultModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"data" : [QDFAQModel class]};
}

@end
