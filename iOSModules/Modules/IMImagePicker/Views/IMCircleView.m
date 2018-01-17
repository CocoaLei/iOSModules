//
//  IMCircleView.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/17.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMCircleView.h"

@implementation IMCircleView

- (void)updateCircleProgress:(double)progress {
    IMDebugLog(@"%f",progress);
    [self updatePath:progress];
}

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shapeLayer.cornerRadius =  self.frame.size.width / 2.0f;
    self.shapeLayer.path         =  [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI   = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle   = startAngle + TWO_M_PI;
    
    CGFloat width           = self.frame.size.width;
    CGFloat borderWidth     = self.shapeLayer.borderWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - borderWidth - 0.5
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}


- (void)updatePath:(float)progress {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}

@end
