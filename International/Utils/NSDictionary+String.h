//
//  NSDictionary+String.h
//  vpn
//
//  Created by hzg on 2021/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (String)

+ (NSDictionary *)parseString:(NSString*)json;

@end

NS_ASSUME_NONNULL_END
