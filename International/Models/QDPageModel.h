//
//  PageModel.h
//  vpn
//
//  Created by hzg on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDPageModel : NSObject

// 总共条数
@property(nonatomic, assign) int count;

// 页码数
@property(nonatomic, assign) int pages;

@end

NS_ASSUME_NONNULL_END
