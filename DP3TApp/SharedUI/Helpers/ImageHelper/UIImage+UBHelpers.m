//
//  UIImage+UBHelpers.m
//  mainlib
//
//  Created by Fabian Aggeler on 10/9/13.
//  Copyright (c) 2013 Ubique. All rights reserved.
//

#import "UIImage+UBHelpers.h"

@implementation UIImage (UBHelpers)

+ (UIImage *)ub_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)ub_imageWithColor:(UIColor *)color
{

    // load the image
  

    // begin a new image context, to draw our colored image onto with the right scale
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque =
        alpha == kCGImageAlphaNone || alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast;

    UIGraphicsBeginImageContextWithOptions(self.size, opaque, self.scale);

    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();

    // set the fill color
    [color setFill];

    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(context, rect, self.CGImage);

    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);

    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // return the color-burned image
    return coloredImg;
}


- (UIImage *)ub_imageByScaling:(CGFloat)scale {
    
    CGSize s = self.size;
    s.height = round(s.height * scale);
    s.width = round(s.width * scale);
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = alpha == kCGImageAlphaNone || alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast;
    
    
    UIGraphicsBeginImageContextWithOptions(s, opaque, self.scale);
    [self drawInRect:CGRectMake(0, 0, s.width, s.height)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}

- (UIImage *)ub_imageByFillingMaskWithColor:(UIColor *)color
{
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)ub_imageWithOpaqueMode:(UBImageModificationOpaqueMode)opaqueMode byApplyingBlockToPixels:(struct UBColor (^)(struct UBColor, CGPoint))block {
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque =
    alpha == kCGImageAlphaNone || alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast;
    if(opaqueMode == UBImageModificationOpaqueModeTransparent)
    {
        opaque = NO;
    }
    else if(opaqueMode == UBImageModificationOpaqueModeOpque)
    {
        opaque = YES;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, opaque, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0f];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    unsigned char *data = CGBitmapContextGetData(ctx);
    
    for(int y = 0; y < self.size.height; y++)
    {
        for(int x = 0; x < self.size.width; x++)
        {
            int offset = (int)(CGBitmapContextGetBytesPerRow(ctx) * y) + (4 * x);
            
            struct UBColor inColor;
            inColor.b = data[offset];
            inColor.g = data[offset + 1];
            inColor.r = data[offset + 2];
            inColor.a = data[offset + 3];
            
            struct UBColor outColor = block(inColor, CGPointMake(x, y));
            
            data[offset] = MAX(0, MIN(255, outColor.b));
            data[offset + 1] = MAX(0, MIN(255, outColor.g));
            data[offset + 2] = MAX(0, MIN(255, outColor.r));
            data[offset + 3] = MAX(0, MIN(255, outColor.a));
        }
    }
    
    UIImage *rtimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rtimg;
}


@end
