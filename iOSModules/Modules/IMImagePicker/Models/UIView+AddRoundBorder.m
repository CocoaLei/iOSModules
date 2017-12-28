//
//  UIView+AddRoundBorder.m
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "UIView+AddRoundBorder.h"

@implementation UIView (AddRoundBorder)

- (void)addRoundBorderWithBorderColor:(UIColor *)borderColor
                          borderWidth:(CGFloat)borderWidth
                               radius:(CGFloat)radius {
  
    if (radius > 0.0f) {
        CAShapeLayer *shapeLayer =  [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        [shapeLayer setStrokeColor:[borderColor CGColor]];
        [shapeLayer setLineWidth:borderWidth];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        CGMutablePathRef path   =   CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
        CGPathAddRoundedRect(path, NULL, self.bounds, radius, radius);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [self.layer addSublayer:shapeLayer];
    } else {
        CAShapeLayer *shapeLayer =  [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        [shapeLayer setStrokeColor:[borderColor CGColor]];
        [shapeLayer setLineWidth:borderWidth];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        CGMutablePathRef path   =   CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), 0.0f);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
        CGPathAddLineToPoint(path, NULL, 0.0f, CGRectGetMaxY(self.bounds));
        CGPathAddLineToPoint(path, NULL, 0.0f, 0.0f);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [self.layer addSublayer:shapeLayer];
    }
    
   
    IMDebugLog();
}

@end
