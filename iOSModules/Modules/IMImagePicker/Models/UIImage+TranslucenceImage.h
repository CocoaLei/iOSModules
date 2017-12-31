//
//  UIImage+TranslucenceImage.h
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TranslucenceImage)

+ (UIImage *)createTranslucenceImageWithSize:(CGSize)size
                                       alpha:(CGFloat)alpha
                                      colorR:(CGFloat)colorR
                                      colorG:(CGFloat)colorG
                                      colorB:(CGFloat)colorB;

@end
