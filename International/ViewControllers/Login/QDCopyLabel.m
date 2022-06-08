//
//  QDCopyLabel.m
//  International
//
//  Created by hzg on 2021/9/14.
//  Copyright © 2021 com. All rights reserved.
//

#import "QDCopyLabel.h"

@implementation QDCopyLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCellHandle:)];
                [self addGestureRecognizer:longPressGesture];
    }
    return self;
}


-(void)longPressCellHandle:(UILongPressGestureRecognizer *)gesture {
    [self becomeFirstResponder];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(menuCopyBtnPressed:)];
    menuController.menuItems = @[copyItem];
    [menuController setTargetRect:gesture.view.frame inView:gesture.view.superview];
    [menuController setMenuVisible:YES animated:NO];
    [UIMenuController sharedMenuController].menuItems=nil;
}


-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem {
    [UIPasteboard generalPasteboard].string = self.text;
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Copy_Success", nil)];
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(menuCopyBtnPressed:)) {
        return YES;
    }
    return NO;
}

@end
