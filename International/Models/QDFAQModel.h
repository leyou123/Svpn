//
//  FAQModel.h
//  vpn
//
//  Created by hzg on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDFAQModel : NSObject

@property(nonatomic, copy) NSString* qid;
@property(nonatomic, copy) NSString* describe;
@property(nonatomic, copy) NSString* name;

// cell使用/展开
@property(nonatomic, assign) BOOL showline;
@property(nonatomic, assign) BOOL showExtend;

@end

NS_ASSUME_NONNULL_END
