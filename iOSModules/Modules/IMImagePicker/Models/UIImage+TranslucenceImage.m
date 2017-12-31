//
//  UIImage+TranslucenceImage.m
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "UIImage+TranslucenceImage.h"

@implementation UIImage (TranslucenceImage)

+ (UIImage *)createTranslucenceImageWithSize:(CGSize)size
                                       alpha:(CGFloat)alpha
                                      colorR:(CGFloat)colorR
                                      colorG:(CGFloat)colorG
                                      colorB:(CGFloat)colorB {
    CGRect frame            =   CGRectMake(0, 0, size.width, size.height);
    UIColor *imageColor     =   [UIColor colorWithRed:colorR green:colorG blue:colorB alpha:alpha];
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context    =   UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage       =   UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
