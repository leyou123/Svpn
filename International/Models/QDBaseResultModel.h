//
//  BaseResultModel.h
//  vpn
//
//  Created by hzg on 2020/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDBaseResultModel : NSObject

@property (nonatomic, copy) NSString *message; //错误信息
@property (nonatomic, assign) int code;        //错误码

@end

NS_ASSUME_NONNULL_END
