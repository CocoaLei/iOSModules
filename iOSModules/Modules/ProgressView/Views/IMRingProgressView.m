//
//  IMRingProgressView.m
//  iOSModules
//
//  Created by 石城磊 on 19/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMRingProgressView.h"

static NSString * const IMProgressViewShowAnimationKey  =   @"IMProgressViewShowAnimationKey";
static NSString * const IMProgressViewHideAnimationKey  =   @"IMProgressViewHideAnimationKey";

@interface IMRingProgressView ()

@property (nonatomic, assign  ) CGFloat         backgroundRingWidth;
@property (nonatomic, assign  ) CGFloat         progressRingWidth;

@property (nonatomic, strong  ) CAShapeLayer    *progressShapeLayer;
@property (nonatomic, strong  ) CAShapeLayer    *backgroundShapeLayer;
@property (nonatomic, strong  ) CAShapeLayer    *actionIconLayer;
@property (nonatomic, strong  ) CADisplayLink   *displayLink;

@property (nonatomic, assign  ) CGFloat         animationFromValue;
@property (nonatomic, assign  ) CGFloat         animationToValue;
@property (nonatomic, assign  ) CFTimeInterval  animationStartTime;

@property (nonatomic, assign  ) IMProgressViewActionType    currentActionType;

@property (nonatomic, strong  ) NSNumberFormatter   *percentageNumberFormatter;
@property (nonatomic, strong  ) UILabel *percentageLabel;

@end

@implementation IMRingProgressView



#pragma mark - Initializations
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self im_InitialSubViewLayout];
    }
    return self;
}

- (void)layoutSubviews {
    //
    self.backgroundShapeLayer.frame = self.bounds;
    self.progressShapeLayer.frame   = self.bounds;
    self.actionIconLayer.frame      = self.bounds;
    //Redraw
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawBackground];
    [self drawProgress];
}

- (void)drawBackground {
    float startAngle    = - (float)M_PI_2;
    float endAngle      = (float)(startAngle + (2.0 * M_PI));
    CGPoint center      = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius      = (self.bounds.size.width - self.backgroundRingWidth) / 2.0;
    //
    UIBezierPath *path  = [UIBezierPath bezierPath];
    path.lineWidth      = self.progressRingWidth;
    path.lineCapStyle   = kCGLineCapRound;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    //
    self.backgroundShapeLayer.path = path.CGPath;
}

- (void)drawProgress {
    float startAngle = - (float)M_PI_2;
    float endAngle   = (float)(startAngle + (2.0 * M_PI * self.progress));
    CGPoint center   = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    CGFloat radius   = (self.bounds.size.width - self.progressRingWidth) / 2.0;
    //
    UIBezierPath *path  = [UIBezierPath bezierPath];
    path.lineCapStyle   = kCGLineCapButt;
    path.lineWidth      = self.progressRingWidth;
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    //
    [self.progressShapeLayer setPath:path.CGPath];
    //
    if (self.progress == 0.0f) {
        self.percentageLabel.text   =   @"";
    } else {
        self.percentageLabel.text   =   [self.percentageNumberFormatter stringFromNumber:@(self.progress)];
    }
}


#pragma mark - Private methods
- (void)im_InitialSubViewLayout {
    //
    [self setBackgroundColor:[UIColor clearColor]];
    //
    self.backgroundRingWidth    =   1.0f;
    self.progressRingWidth      =   self.backgroundRingWidth*3.0f;
    self.animationDuration      =   0.01f;
    //
    self.backgroundShapeLayer   =   [[CAShapeLayer alloc] init];
    [self.backgroundShapeLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [self.backgroundShapeLayer setFillColor:[UIColor clearColor].CGColor];
    [self.backgroundShapeLayer setLineCap:kCALineCapRound];
    [self.backgroundShapeLayer setLineWidth:self.backgroundRingWidth];
    [self.layer addSublayer:self.backgroundShapeLayer];
    //
    self.progressShapeLayer   =   [[CAShapeLayer alloc] init];
    [self.progressShapeLayer setStrokeColor:[UIColor greenColor].CGColor];
    [self.progressShapeLayer setFillColor:nil];
    [self.progressShapeLayer setLineCap:kCALineCapRound];
    [self.progressShapeLayer setLineWidth:self.progressRingWidth];
    [self.layer addSublayer:self.progressShapeLayer];
    //
    self.percentageLabel                = [[UILabel alloc] init];
    self.percentageLabel.font           = [UIFont systemFontOfSize:self.bounds.size.width/5];
    self.percentageLabel.textColor      = [UIColor greenColor];
    self.percentageLabel.textAlignment  = NSTextAlignmentCenter;
    self.percentageLabel.contentMode    = UIViewContentModeCenter;
    self.percentageLabel.frame          = self.bounds;
    [self addSubview:self.percentageLabel];
    //
    self.actionIconLayer                = [[CAShapeLayer alloc] init];
    self.actionIconLayer.fillRule       = kCAFillRuleNonZero;
    [self.layer addSublayer:self.actionIconLayer];
    //
    self.percentageNumberFormatter      = [[NSNumberFormatter alloc] init];
    [self.percentageNumberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
}

#pragma mark - Instance methods
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (self.progress == progress) {
        return;
    }
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink invalidate];
            _displayLink = nil;
        }
        [super setProgress:progress animated:animated];
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue   = progress;
        if (!_displayLink) {
            [self.displayLink invalidate];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - self.animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            [self.displayLink invalidate];
            self.displayLink = nil;
            [super setProgress:self.animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        //Set progress
        [super setProgress:self.animationFromValue + dt * (self.animationToValue - self.animationFromValue) animated:YES];
        [self setNeedsDisplay];
        
    });
}

- (void)performAction:(IMProgressViewActionType)actionType animated:(BOOL)animated {
    switch (actionType) {
        case IMProgressViewActionTypeNone:
        {
            if (self.currentActionType != IMProgressViewActionTypeNone) {
                [CATransaction begin];
                [self.actionIconLayer addAnimation:[self hideAnimation] forKey:IMProgressViewHideAnimationKey];
                [self.percentageLabel.layer addAnimation:[self showAnimation] forKey:IMProgressViewShowAnimationKey];
                [CATransaction commit];
                self.currentActionType  =   actionType;
            }
        }
            break;
        case IMProgressViewActionTypeSuccess:
        {
            if (self.currentActionType != IMProgressViewActionTypeSuccess) {
                if (self.currentActionType == IMProgressViewActionTypeNone) {
                    self.currentActionType = actionType;
                    [self drawIcon];
                    //Animate
                    [CATransaction begin];
                    [self.actionIconLayer addAnimation:[self showAnimation] forKey:IMProgressViewShowAnimationKey];
                    [self.percentageLabel.layer addAnimation:[self hideAnimation] forKey:IMProgressViewHideAnimationKey];
                    [CATransaction commit];
                } else if (self.currentActionType == IMProgressViewActionTypeFailure) {
                    //Hide the icon layer before showing
                    [CATransaction begin];
                    [self.actionIconLayer addAnimation:[self hideAnimation] forKey:IMProgressViewHideAnimationKey];
                    [CATransaction setCompletionBlock:^{
                        self.currentActionType = actionType;
                        [self drawIcon];
                        [self.actionIconLayer addAnimation:[self showAnimation] forKey:IMProgressViewShowAnimationKey];
                    }];
                    [CATransaction commit];
                }
            }
        }
            break;
        case IMProgressViewActionTypeFailure:
        {
            if (self.currentActionType != IMProgressViewActionTypeFailure) {
                if (self.currentActionType == IMProgressViewActionTypeNone) {
                    //Just show the icon layer
                    self.currentActionType = actionType;
                    [self drawIcon];
                    [CATransaction begin];
                    [self.actionIconLayer addAnimation:[self showAnimation] forKey:IMProgressViewShowAnimationKey];
                    [self.percentageLabel.layer addAnimation:[self hideAnimation] forKey:IMProgressViewHideAnimationKey];
                    [CATransaction commit];
                } else if (self.currentActionType == IMProgressViewActionTypeSuccess) {
                    //Hide the icon layer before showing
                    [CATransaction begin];
                    [self.actionIconLayer addAnimation:[self hideAnimation] forKey:IMProgressViewHideAnimationKey];
                    [CATransaction setCompletionBlock:^{
                        self.currentActionType = actionType;
                        [self drawIcon];
                        [self.actionIconLayer addAnimation:[self showAnimation] forKey:IMProgressViewShowAnimationKey];
                    }];
                    [CATransaction commit];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)drawIcon {
    switch (self.currentActionType) {
        case IMProgressViewActionTypeNone:
        {
            self.actionIconLayer    =   nil;
        }
            break;
        case IMProgressViewActionTypeSuccess:
        {
            [self drawSuccess];
        }
            break;
        case IMProgressViewActionTypeFailure:
        {
            [self drawFailure];
        }
            break;
        default:
            break;
    }
}

- (void)drawSuccess
{
    //Draw relative to a base size and percentage, that way the check can be drawn for any size.*/
    CGFloat radius = (self.frame.size.width / 2.0);
    CGFloat size = radius * .3;
    
    //Create the path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, size * 2)];
    [path addLineToPoint:CGPointMake(size * 3, size * 2)];
    [path addLineToPoint:CGPointMake(size * 3, size)];
    [path addLineToPoint:CGPointMake(size, size)];
    [path addLineToPoint:CGPointMake(size, 0)];
    [path closePath];
    
    //Rotate it through -45 degrees...
    [path applyTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    
    //Center it
    [path applyTransform:CGAffineTransformMakeTranslation(radius * .46, 1.02 * radius)];
    
    //Set path
    [self.actionIconLayer setPath:path.CGPath];
    [self.actionIconLayer setFillColor:[UIColor greenColor].CGColor];
}

- (void)drawFailure
{
    //Calculate the size of the X
    CGFloat radius = self.frame.size.width / 2.0;
    CGFloat size = radius * .3;
    
    //Create the path for the X
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(size, 0)];
    [xPath addLineToPoint:CGPointMake(2 * size, 0)];
    [xPath addLineToPoint:CGPointMake(2 * size, size)];
    [xPath addLineToPoint:CGPointMake(3 * size, size)];
    [xPath addLineToPoint:CGPointMake(3 * size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(2 * size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(2 * size, 3 * size)];
    [xPath addLineToPoint:CGPointMake(size, 3 * size)];
    [xPath addLineToPoint:CGPointMake(size, 2 * size)];
    [xPath addLineToPoint:CGPointMake(0, 2 * size)];
    [xPath addLineToPoint:CGPointMake(0, size)];
    [xPath addLineToPoint:CGPointMake(size, size)];
    [xPath closePath];
    
    
    //Center it
    [xPath applyTransform:CGAffineTransformMakeTranslation(radius - (1.5 * size), radius - (1.5 * size))];
    
    //Rotate path
    [xPath applyTransform:CGAffineTransformMake(cos(M_PI_4),sin(M_PI_4),-sin(M_PI_4),cos(M_PI_4),radius * (1 - cos(M_PI_4)+ sin(M_PI_4)),radius * (1 - sin(M_PI_4)- cos(M_PI_4)))];
    
    //Set path and fill color
    [self.actionIconLayer setPath:xPath.CGPath];
    [self.actionIconLayer setFillColor:[UIColor redColor].CGColor];
}

- (CABasicAnimation *)showAnimation {
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showAnimation.fromValue         = [NSNumber numberWithFloat:0.0];
    showAnimation.toValue           = [NSNumber numberWithFloat:1.0];
    showAnimation.duration          = self.animationDuration;
    showAnimation.repeatCount       = 1.0;
    //
    showAnimation.fillMode              = kCAFillModeForwards;
    showAnimation.removedOnCompletion   = NO;
    return showAnimation;
}

- (CABasicAnimation *)hideAnimation {
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    hideAnimation.fromValue         = [NSNumber numberWithFloat:1.0];
    hideAnimation.toValue           = [NSNumber numberWithFloat:0.0];
    hideAnimation.duration          = self.animationDuration;
    hideAnimation.repeatCount       = 1.0;
    //
    hideAnimation.fillMode              = kCAFillModeForwards;
    hideAnimation.removedOnCompletion   = NO;
    return hideAnimation;
}

@end

