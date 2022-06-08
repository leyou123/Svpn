//
//  TZBaseViewController.h
//  vpn
//
//  Created by hzg on 2020/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDBaseViewController : UIViewController


@property(nonatomic, assign) BOOL isHideNavagation;

@property(nonatomic, assign) BOOL showNavBarWhiteBg;

@property(nonatomic, strong) UIView* backFrame;

- (void) setupBack;
- (void) setupTitle:(NSString*) title;
- (void) setupBackFrame;


@end

NS_ASSUME_NONNULL_END
