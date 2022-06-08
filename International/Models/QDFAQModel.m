//
//  FAQModel.m
//  vpn
//
//  Created by hzg on 2020/12/29.
//

#import "QDFAQModel.h"

@implementation QDFAQModel

//模型和字典的字段不对应需要转化
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"qid":@"id"};
}

@end
