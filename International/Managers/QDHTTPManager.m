//
//  HTTPHelper.m
//  vpn
//
//  Created by hzg on 2020/12/9.
//

#import "QDHTTPManager.h"

@implementation QDHTTPManager


+ (QDHTTPManager *) shared {
    static dispatch_once_t onceToken;
    static QDHTTPManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDHTTPManager new];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return instance;
}

- (NSString*) getUrlByType:(APIType) type {
//    if (type == kAPIGithub) return @"https://api.github.com/repos/huangzugang/github_api_test/contents/serve.json";
    if (type == kAPILookupApp)
        return [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPLE_ID];
    return [NSString stringWithFormat:@"%@/%@%@", QDConfigManager.shared.currentUrl, APP_V, API_PATH[[NSNumber numberWithInteger:type]]];
}

- (void) request:(HTTPMethodType)method type:(APIType)type parameters:(NSDictionary *)parameters completed:(void (^)(NSDictionary *dictionary)) completed {
    
    NSLog(@"%@",parameters);
    
    // FIXME: isReachable这个状态并不是实时的，启动时获取的状态有延迟
    if (QDConfigManager.shared.isNetworkReady && ![AFNetworkReachabilityManager sharedManager].isReachable) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // 需要延迟执行的代码
            completed(@{@"code":@(-1001), @"message":NSLocalizedString(@"HomeNoNetwork", nil)});
        });
        return;
    }
    
    // url
    NSString* url = [self getUrlByType:type];
    NSLog(@"\n request url = %@ \n request parameters = %@", url, parameters);
    
    // 定义成功回调闭包
    void (^successBlock) (NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response = %@", responseObject);
        // 重置失败次数
        QDConfigManager.shared.failTimes = 0;
        completed(responseObject);
    };
    
    // 定义失败回调闭包
    void (^failureBlock) (NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, NSError*  error) {
        // 失败次数+1
        QDConfigManager.shared.failTimes += 1;
        completed(@{@"code":@(-1), @"message":error.localizedDescription});
    };
    
    
    if (method == HTTPMethodTypeGet) {
        [self GET:url parameters:parameters headers:nil progress:nil success:successBlock failure:failureBlock];
    } else if (method == HTTPMethodTypePut) {
        [self PUT:url parameters:parameters headers:nil success:successBlock failure:failureBlock];
    } else {
        [self POST:url parameters:parameters headers:nil progress:nil success:successBlock failure:failureBlock];
    }
}

- (void) request:(HTTPMethodType)method url:(NSString *)url parameters:(NSDictionary *)parameters completed:(void (^)(NSDictionary *dictionary)) completed {
    // FIXME: isReachable这个状态并不是实时的，启动时获取的状态有延迟
    if (QDConfigManager.shared.isNetworkReady && ![AFNetworkReachabilityManager sharedManager].isReachable) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // 需要延迟执行的代码
            completed(@{@"code":@(-1001), @"message":NSLocalizedString(@"HomeNoNetwork", nil)});
        });
        return;
    }
    
    // 定义成功回调闭包
    void (^successBlock) (NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response = %@", responseObject);
        // 重置失败次数
        QDConfigManager.shared.failTimes = 0;
        completed(responseObject);
    };
    
    // 定义失败回调闭包
    void (^failureBlock) (NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, NSError*  error) {
        // 失败次数+1
        QDConfigManager.shared.failTimes += 1;
        completed(@{@"code":@(-1), @"message":error.localizedDescription});
    };
    
    
    if (method == HTTPMethodTypeGet) {
        [self GET:url parameters:parameters headers:nil progress:nil success:successBlock failure:failureBlock];
    } else if (method == HTTPMethodTypePut) {
        [self PUT:url parameters:parameters headers:nil success:successBlock failure:failureBlock];
    } else {
        [self POST:url parameters:parameters headers:nil progress:nil success:successBlock failure:failureBlock];
    }
}

@end
