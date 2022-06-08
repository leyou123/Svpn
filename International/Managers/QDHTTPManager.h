//
//  HTTPHelper.h
//  vpn
//
//  Created by hzg on 2020/12/9.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HTTPMethodType) {
    HTTPMethodTypeGet = 0,
    HTTPMethodTypePost,
    HTTPMethodTypePut
};

@interface QDHTTPManager : AFHTTPSessionManager

+ (QDHTTPManager *) shared;

- (void) request:(HTTPMethodType)method type:(APIType)type parameters:(NSDictionary *)parameters completed:(void (^)(NSDictionary *dictionary)) completed;

- (void) request:(HTTPMethodType)method url:(NSString *)url parameters:(NSDictionary *)parameters completed:(void (^)(NSDictionary *dictionary)) completed;


@end

NS_ASSUME_NONNULL_END
