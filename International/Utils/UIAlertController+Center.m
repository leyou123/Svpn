//
//  UIAlertController+Center.m
//  International
//
//  Created by 杜国锋 on 2022/5/30.
//  Copyright © 2022 com. All rights reserved.
//

#import "UIAlertController+Center.h"

@implementation UIAlertController (Center)

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self _my_fixupLayout];
}

- (void)_my_fixupLayout
{
    if (self.preferredStyle == UIAlertControllerStyleAlert && self.view.window)
    {
        CGPoint myCenter = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
        self.view.center = myCenter;
    }
    else if (self.preferredStyle == UIAlertControllerStyleActionSheet && self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && self.view.window)
    {
        CGRect myRect = self.view.bounds;
        CGRect windowRect = [self.view convertRect:myRect toView:nil];
        if (!CGRectContainsRect(self.view.window.bounds, windowRect) || CGPointEqualToPoint(windowRect.origin, CGPointZero))
        {
            UIScreen *screen = self.view.window.screen;
            CGFloat borderPadding = ((screen.nativeBounds.size.width / screen.nativeScale) - myRect.size.width) / 2.0f;
            CGRect myFrame = self.view.frame;
            CGRect superBounds = self.view.superview.bounds;
            myFrame.origin.x = CGRectGetMidX(superBounds) - myFrame.size.width / 2;
            myFrame.origin.y = superBounds.size.height - myFrame.size.height - borderPadding;
            self.view.frame = myFrame;
        }
    }
}

@end
