//
//  CSLYVersionUpdate.h
//
//  Created by hzg on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDVersionManager : NSObject

+ (QDVersionManager *) shared;

// 版本配置
@property(nonatomic, strong) NSDictionary* versionConfig;

- (void) check:(BOOL)isAuto;

@end

NS_ASSUME_NONNULL_END
