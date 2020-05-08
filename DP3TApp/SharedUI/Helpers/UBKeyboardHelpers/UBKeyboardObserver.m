//
//  UBKeyboardObserver.m
//  MeteoSchweiz
//
//  Created by Nicolas Märki on 27.11.12.
//  Copyright (c) 2012 Ubique Engineering GmbH. All rights reserved.
//

#import "UBKeyboardObserver.h"

@implementation UBKeyboardObserver

+ (CGFloat)height:(CGFloat)height intoView:(UIView *)view
{
    CGRect frame = [view.window convertRect:view.frame fromView:view.superview];

    return MIN(MAX(height - view.window.bounds.size.height + frame.origin.y + frame.size.height, 0), height);
}

- (id)init
{
    self = [super init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideOrShow:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideOrShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHideOrShow:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat height = 0;
    if([note.name isEqualToString:UIKeyboardWillShowNotification])
    {
        height = keyboardFrame.size.height;
    }

    if(self.callback)
    {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | curve
                         animations:^{ self.callback(height); }
                         completion:nil];
    };
}

@end
