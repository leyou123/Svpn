//
//  QDForgetFillEmailViewController.h
//  International
//
//  Created by LC on 2022/4/22.
//  Copyright © 2022 com. All rights reserved.
//

#import "QDBaseUserViewController.h"

typedef enum : NSUInteger {
    PageFillEmail,
    PageVerifation,
} ForgetPage;

NS_ASSUME_NONNULL_BEGIN

@interface QDForgetFillEmailViewController : QDBaseUserViewController

@property (nonatomic, assign) ForgetPage page;

@end

NS_ASSUME_NONNULL_END
