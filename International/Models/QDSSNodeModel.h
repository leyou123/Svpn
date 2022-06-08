//
//  SSNodeModel.h
//  vpn
//
//  Created by hzg on 2021/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDSSNodeModel : NSObject

@property(nonatomic, copy) NSString* host;
@property(nonatomic, copy) NSString* port;
@property(nonatomic, copy) NSString* password;
@property(nonatomic, copy) NSString* uid;

@end

NS_ASSUME_NONNULL_END
