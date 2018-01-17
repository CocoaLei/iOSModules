//
//  IMProgressView.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/17.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMProgressView.h"
#import "IMCircleView.h"

@interface IMProgressView ()
<
    CAAnimationDelegate
>

@property (nonatomic, strong)   UIColor *borderColor;
@property (nonatomic, assign)   CGFloat borderWidth;
@property (nonatomic, assign)   CGFloat lineWidth;
@property (nonatomic, copy  )   IMProgressDidChangeBLOCK progressDidChangeBlock;
@property (nonatomic, strong)   IMCircleView    *circleProgressView;
@property (nonatomic, assign)   double          progress;

@end

@implementation IMProgressView

+ (IMProgressView *)progressViewWithFrame:(CGRect)frame
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                                lineWidth:(CGFloat)lineWidth
                        progressDidChange:(IMProgressDidChangeBLOCK)progressDidChange {
    return [[IMProgressView alloc] initProgressViewWithFrame:frame
                                            borderColor:borderColor
                                            borderWidth:borderWidth
                                              lineWidth:lineWidth
                                      progressDidChange:progressDidChange];
    
}

- (IMProgressView *)initProgressViewWithFrame:(CGRect)frame
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth
                                 lineWidth:(CGFloat)lineWidth
                         progressDidChange:(IMProgressDidChangeBLOCK)progressDidChange {
    if (self = [super initWithFrame:frame]) {
        _progress               =   0.0;
        _borderColor            =   borderColor;
        _borderWidth            =   borderWidth;
        _lineWidth              =   lineWidth;
        _progressDidChangeBlock =   progressDidChange;
        [self setUpIMProgressView];
    }
    return self;
}

#pragma mark -
#pragma mark - Initialization methods
- (void)setUpIMProgressView {
    self.circleProgressView                     =   [[IMCircleView alloc] initWithFrame:self.bounds];
    self.circleProgressView.shapeLayer.fillColor    =   [UIColor clearColor].CGColor;
    self.circleProgressView.shapeLayer.strokeColor  =  [UIColor blackColor].CGColor;
    self.circleProgressView.shapeLayer.borderColor  =   _borderColor.CGColor;
    self.circleProgressView.shapeLayer.borderWidth  =   _borderWidth;
    self.circleProgressView.shapeLayer.lineWidth    =   _lineWidth;
    [self addSubview:self.circleProgressView];
    //
    [self.circleProgressView updateCircleProgress:self.progress];
}

- (void)updateProgress:(CGFloat)progress animated:(BOOL)animated {
    
    
    if (animated) {
        [self animateToProgress:_progress];
    } else {
        
        _progress = progress;
        [self.circleProgressView updateCircleProgress:_progress];
    }
    
    if (self.progressDidChangeBlock) {
        self.progressDidChangeBlock(_progress);
    }
}

- (void)animateToProgress:(double)progress {
    CABasicAnimation *animation =   [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration          =   0.25;
    animation.fromValue         =   @(self.progress);
    animation.toValue           =   @(progress);
    animation.delegate          =   self;
    [self.circleProgressView.layer addAnimation:animation forKey:@"IMProgressAnimationKey"];
    _progress = progress;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.circleProgressView updateCircleProgress:_progress];
   
}


@end
