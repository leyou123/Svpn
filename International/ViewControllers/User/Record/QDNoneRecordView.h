//
//  NoneRecordView.h
//  vpn
//
//  Created by hzg on 2020/12/24.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDNoneRecordView : UIView

- (instancetype) initWithFrame:(CGRect)frame clickBlock:(ClickBlock) block;

@end

NS_ASSUME_NONNULL_END
