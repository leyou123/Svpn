//
//  NSDictionary+String.m
//  vpn
//
//  Created by hzg on 2021/3/26.
//

#import "NSDictionary+String.h"

@implementation NSDictionary (String)

+ (NSDictionary *)parseString:(NSString*)json {
    if (json == nil) return nil;
    NSData *JSONData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    return responseJSON;
}

@end
