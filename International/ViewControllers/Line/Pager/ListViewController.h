//
//  ListViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "QDLineTableViewProxy.h"
#import "QDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) QDLineTableViewProxy *tableViewProxy;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL isHeaderRefreshed;   //默认为YES
@end

NS_ASSUME_NONNULL_END
