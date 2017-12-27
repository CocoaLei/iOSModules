//
//  UIImage+RoundCorner.m
//  iOSModules
//
//  Created by 石城磊 on 27/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "UIImage+RoundCorner.h"

@implementation UIImage (RoundCorner)

- (UIImage *)im_addRoundCornerWithRadius:(CGFloat)radius andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx    = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
