//
//  CSLYVersionUpdate.m
//
//  Created by hzg on 2021/5/21.
//

#import "QDVersionManager.h"
#import "QDVersionConfigResultModel.h"

@interface QDVersionManager()

// 商店版本信息
@property(nonatomic, strong) NSDictionary* appstoreInfoDict;

// 应用版本信息
@property(nonatomic, strong) NSDictionary* appInfoDict;

@end

@implementation QDVersionManager

+ (QDVersionManager *) shared {
    static dispatch_once_t onceToken;
    static QDVersionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [QDVersionManager new];
    });
    return instance;
}


// 检查版本更新
- (void) check:(BOOL)isAuto {
    
    // 显示loading动画
    if (!isAuto) {
        [SVProgressHUD show];
    }
    
    // 并发请求组
    dispatch_group_t group = dispatch_group_create();
    
    // 请求商店信息
    [self requestAppstoreInfo:group];
    
    // 请求应用信息
    [self requestAppInfo:group];
    
    // 所有请求完成通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (!isAuto) {
            [SVProgressHUD dismiss];
        }
        
        // 没有在商店查到可用版本
        if (!self.appstoreInfoDict || [self.appstoreInfoDict[@"resultCount"] integerValue] <= 0) {
            return;
        }
        
        // 应用版本信息请求错误
        if (!self.appInfoDict || [self.appInfoDict[@"code"] intValue] != 200) {
            return;
        }
        
        // 应用商店地址
        NSString* trackViewUrl = [self.appstoreInfoDict[@"results"][0] objectForKey:@"trackViewUrl"];
        
        // 商店版本
        NSString *appstoreVersion =[self.appstoreInfoDict[@"results"][0] objectForKey:@"version"];
        
        // 强制升级版本
        NSString *forceUpdateVersion = self.appInfoDict[@"data"][@"upgrade_version"];
        
        // 应用版本
        NSMutableArray *appVersionArr =[NSMutableArray arrayWithArray:[APP_VERSION componentsSeparatedByString:@"."]];
        
        // 商店版本
        NSMutableArray *appstoreVersionArr =[NSMutableArray arrayWithArray:[appstoreVersion componentsSeparatedByString:@"."]];
        
        // 强制更新版本
        NSMutableArray *forceUpdateVersionArr =[NSMutableArray arrayWithArray:[forceUpdateVersion componentsSeparatedByString:@"."]];
        
        NSInteger num = appVersionArr.count;
        if(num < appstoreVersionArr.count) num = appstoreVersionArr.count;
        if(num < forceUpdateVersionArr.count) num = forceUpdateVersionArr.count;
        while(appVersionArr.count < num) [appVersionArr addObject:@"0"];
        while(appstoreVersionArr.count < num) [appstoreVersionArr addObject:@"0"];
        while(forceUpdateVersionArr.count < num) [forceUpdateVersionArr addObject:@"0"];
        
        int x = 0;
        BOOL needUpdate      = NO;
        BOOL needForceUpdate = NO;
        // 商店版本大于本地版本，需要更新
        while(x < num) {
            NSInteger appstoreVersion = [appstoreVersionArr[x] integerValue];
            NSInteger appVersion = [appVersionArr[x] integerValue];
            if (appstoreVersion > appVersion) {
                needUpdate = YES;
                break;
            } else if (appstoreVersion < appVersion) {
                break;
            }
            x += 1;
        }
        
        x = 0;
        // 强制更新版本大于本地版本，需强制更新
        while(x < num) {
            NSInteger forceVersion = [forceUpdateVersionArr[x] integerValue];
            NSInteger appVersion = [appVersionArr[x] integerValue];
            if (forceVersion > appVersion) {
                needForceUpdate = YES;
                break;
            } else if (forceVersion < appVersion) {
                break;
            }
            x += 1;
        }
        
        NSString* title        = @"";
        NSString* ok           = NSLocalizedString(@"Version_Update", nil);
        NSString* canel        = nil;
        NSString* message      = NSLocalizedString(@"Version_Latest", nil);
        
        // 弹窗开关 0 不弹窗 1 弹窗
        if ([self.appInfoDict[@"data"][@"switch"] integerValue] == 0) {
            // 不是自动检测更新
            if (!isAuto) {
                ok = NSLocalizedString(@"Dialog_Ok", nil);
                [QDDialogManager showDialog:title message:message ok:ok cancel:canel okBlock:^{
                    
                } cancelBlock:^{
                    
                }];
            }
        }else {
            if (needUpdate) {
                title   = [NSString stringWithFormat:NSLocalizedString(@"Version_Info", nil), appstoreVersion];
                message = [self.appstoreInfoDict[@"results"][0] objectForKey:@"releaseNotes"];
                if (!needForceUpdate) {
                    canel = NSLocalizedString(@"Dialog_Cancel", nil);
                }
                [QDDialogManager showVersionUpdate:title message:message ok:ok cancel:canel okBlock:^{
                        NSURL *url =[NSURL URLWithString:trackViewUrl];
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } cancelBlock:^{
                }];
            } else {
                // 不是自动检测更新
                if (!isAuto) {
                    ok = NSLocalizedString(@"Dialog_Ok", nil);
                    [QDDialogManager showDialog:title message:message ok:ok cancel:canel okBlock:^{
                        
                    } cancelBlock:^{
                        
                    }];
                }
            }
        }
        
        
    });
}

// 请求商店信息
- (void) requestAppstoreInfo:(dispatch_group_t) group {
    dispatch_group_enter(group);
    [QDHTTPManager.shared request:HTTPMethodTypeGet url:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", @"com.superoversea"] parameters:@{} completed:^(NSDictionary * _Nonnull dictionary) {
        self.appstoreInfoDict = dictionary;
        dispatch_group_leave(group);
    }];
}

// 请求后台信息
- (void) requestAppInfo:(dispatch_group_t) group {
    dispatch_group_enter(group);
    [QDModelManager requestVersionInfo:^(NSDictionary * _Nonnull dictionary) {
        self.appInfoDict = dictionary;
        NSLog(@"%@ --------- %@",dictionary,self.appstoreInfoDict);
        if ([dictionary[@"data"][@"current_version"] isEqualToString:self.appstoreInfoDict[@"results"][0][@"version"]]) {
            dispatch_group_leave(group);
        }else {
            [QDHTTPManager.shared request:HTTPMethodTypeGet url:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPLE_ID] parameters:@{} completed:^(NSDictionary * _Nonnull dictionary) {
                self.appstoreInfoDict = dictionary;
                dispatch_group_leave(group);
            }];
        }
    }];
}




@end
