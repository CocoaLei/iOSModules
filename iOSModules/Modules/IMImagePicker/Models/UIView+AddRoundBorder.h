//
//  UIView+AddRoundBorder.h
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddRoundBorder)

// If view is create with xib, you should't invoke this method in viewDidLoad
- (void)addRoundBorderWithBorderColor:(UIColor *)borderColor
                          borderWidth:(CGFloat)borderWidth
                               radius:(CGFloat)radius;

@end
