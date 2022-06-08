//
//  ProtocolView.h
//  International
//
//  Created by a on 2020/3/19.
//  Copyright © 2020 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ProtocolView : UIView

@property (nonatomic, copy) ClickBlock callback;

@end

NS_ASSUME_NONNULL_END
