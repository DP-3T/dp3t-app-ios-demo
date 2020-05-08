//
//  UIScrollView+UBKeyboardObserver.m
//  UBFoundationUI
//
//  Created by Nicolas Märki on 19.02.15.
//  Copyright (c) 2015 Ubique Engineering GmbH. All rights reserved.
//

#import "UIScrollView+UBKeyboardObserver.h"

#import "UBKeyboardObserver.h"

#import <objc/runtime.h>

@implementation UIScrollView (UBKeyboardObserver)

- (void)ub_enableDefaultKeyboardObserver
{
    UBKeyboardObserver *observer = [[UBKeyboardObserver alloc] init];
    __weak typeof(self) weakSelf = self;
    observer.callback = ^(CGFloat height) {
        UIEdgeInsets insets = weakSelf.contentInset;
        insets.bottom = [UBKeyboardObserver height:height intoView:weakSelf];
        weakSelf.contentInset = insets;
        weakSelf.scrollIndicatorInsets = insets;
    };
    objc_setAssociatedObject(self, @"keyboardObserver", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
