//
//  NSString+FormatFloat.m
//  vpn
//
//  Created by hzg on 2021/3/19.
//

#import "NSString+FormatFloat.h"

@implementation NSString (FormatFloat)

/**
 过滤器/ 将.2f格式化的字符串，去除末尾0
 */
+ (NSString *)formatFloat:(float)value {
    NSString* numberStr = [NSString stringWithFormat:@"%0.2f", value];
    if (numberStr.length > 1) {
        
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return @"";
    }
}

@end
