//
//  IMProgressView.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/17.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IMProgressDidChangeBLOCK)(CGFloat progress);

@interface IMProgressView : UIView

+ (IMProgressView *)progressViewWithFrame:(CGRect)frame
                              borderColor:(UIColor *)borderColor
                                    borderWidth:(CGFloat)borderWidth
                                      lineWidth:(CGFloat)lineWidth
                              progressDidChange:(IMProgressDidChangeBLOCK)progressDidChange;
- (IMProgressView *)initProgressViewWithFrame:(CGRect)frame
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth
                                 lineWidth:(CGFloat)lineWidth
                         progressDidChange:(IMProgressDidChangeBLOCK)progressDidChange;

- (void)updateProgress:(double)progress animated:(BOOL)animated;


@end
