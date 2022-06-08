//
//  QDCheckBoxButton2.h
//  International
//
//  Created by hzg on 2022/2/9.
//  Copyright © 2022 com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDCheckBoxButton2 : UIView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text callback:(void (^)(NSString *text)) callback;

@end

NS_ASSUME_NONNULL_END
