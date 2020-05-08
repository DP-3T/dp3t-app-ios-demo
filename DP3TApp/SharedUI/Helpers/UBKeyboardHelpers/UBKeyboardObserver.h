//
//  UBKeyboardObserver.h
//  MeteoSchweiz
//
//  Created by Nicolas Märki on 27.11.12.
//  Copyright (c) 2012 Ubique Engineering GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UBKeyboardObserver : NSObject

@property (nonatomic, copy, nullable) void (^callback)(CGFloat height);

+ (CGFloat)height:(CGFloat)height intoView:(nonnull UIView *)view;

@end
