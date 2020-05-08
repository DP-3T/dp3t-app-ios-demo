//
//  UIImage+UBHelpers.h
//  mainlib
//
//  Created by Fabian Aggeler on 10/9/13.
//  Copyright (c) 2013 Ubique. All rights reserved.
//

#import <UIKit/UIKit.h>

struct UBColor
{
    NSInteger r;
    NSInteger g;
    NSInteger b;
    NSInteger a;
};

typedef NS_ENUM(NSUInteger, UBImageModificationOpaqueMode)
{
    UBImageModificationOpaqueModeAsOriginal,
    UBImageModificationOpaqueModeOpque,
    UBImageModificationOpaqueModeTransparent,
};


@interface UIImage (UBHelpers)
+ (UIImage *)ub_imageWithColor:(UIColor *)color;

- (UIImage *)ub_imageWithColor:(UIColor *)color;
- (UIImage *)ub_imageByFillingMaskWithColor:(UIColor *)color;

- (UIImage *)ub_imageByScaling:(CGFloat)scale;

- (UIImage *)ub_imageWithOpaqueMode:(UBImageModificationOpaqueMode)opaqueMode
              byApplyingBlockToPixels:(struct UBColor (^)(struct UBColor c, CGPoint p))block;

@end
