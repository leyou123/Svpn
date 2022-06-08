//
//  QDRecommandAdView.h
//  International
//
//  Created by hzg on 2021/6/17.
//  Copyright © 2021 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface QDRecommandAdView : UIView

- (void) clickAction;

@end

NS_ASSUME_NONNULL_END
