//
//  IMCameraRecordControl.m
//  iOSModules
//
//  Created by 石城磊 on 13/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraRecordControl.h"
#import "IMRingProgressView.h"

@interface IMCameraRecordControl ()

@property (nonatomic, assign )  NSTimeInterval            touchDuration;
@property (nonatomic, assign )  IMCameraRecordControlType currentControlType;

@property (nonatomic, strong )  UIView                    *capturePhotoView;
@property (nonatomic, strong )  UIView                    *captureVideoView;

@end

@implementation IMCameraRecordControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialCofigureRecordControl];
    }
    return self;
}

- (void)initialCofigureRecordControl {
    self.layer.cornerRadius    =   self.bounds.size.width/2.0f;
    self.layer.masksToBounds   =   YES;
}

// Set max duration of video
- (void)setMaxVideoDuration:(NSTimeInterval)maxVideoDuration {
    if (maxVideoDuration == 0.0f) {
        _maxVideoDuration   =   CGFLOAT_MAX;
    }
    _maxVideoDuration   =   maxVideoDuration;
}

#pragma mark - Private methods
- (void)configureRecordControlWithType:(IMCameraRecordControlType)controlType {
    self.currentControlType =   controlType;
    switch (self.currentControlType) {
        case IMCameraRecordControlTypePhoto:
        {
            CGAffineTransform currentTransform = self.transform;
            [UIView animateWithDuration:0.1f animations:^{
                self.transform = CGAffineTransformScale(currentTransform, 1.50f,1.50f);
            }];
        }
            break;
        case IMCameraRecordControlTypeVideo:
        {
            //
            CGAffineTransform currentTransform = self.transform;
            [UIView animateWithDuration:0.1f animations:^{
                self.transform = CGAffineTransformScale(currentTransform, 2.0f,2.0f);
            }];
        }
            break;
        case IMCameraRecordControlTypeCancel:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - Touch tracking
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.touchDuration  =   event.timestamp;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if ((event.timestamp - self.touchDuration) > 0.5f) {
        // Record video
        IMDebugLog(@"Record video");
        if (self.currentControlType != IMCameraRecordControlTypeVideo) {
            [self configureRecordControlWithType:IMCameraRecordControlTypeVideo];
        }
        //
        if ((event.timestamp - self.touchDuration) == self.maxVideoDuration) {
            IMDebugLog(@"Video recorded the maximum duration");
            if (self.cameraHandler) {
                self.cameraHandler(IMCameraRecordControlTypeCancel);
            }
        } else {
            if (self.cameraHandler) {
                self.cameraHandler(IMCameraRecordControlTypeVideo);
            }
        }
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.touchDuration  = event.timestamp - self.touchDuration;
    if (self.touchDuration > 0.1f) {
        // Take Picture
        IMDebugLog(@"Take a photo");
        if (self.cameraHandler) {
            self.cameraHandler(IMCameraRecordControlTypePhoto);
        }
    } else {
        if (self.cameraHandler) {
            self.cameraHandler(IMCameraRecordControlTypeCancel);
        }
    }
}

@end
