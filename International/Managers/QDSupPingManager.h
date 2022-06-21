//
//  CSLYPingHelper.h
//  vpn
//
//  Created by hzg on 2021/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDSupPingManager : NSObject

+ (QDSupPingManager *) shared;

// ping
- (void) ping:(NSString*)ip;

// 网络延迟测试
@property (nonatomic, strong)NSMutableDictionary *pingServicesDict;

@end

NS_ASSUME_NONNULL_END
