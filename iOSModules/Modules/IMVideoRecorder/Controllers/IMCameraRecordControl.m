//
//  IMCameraRecordControl.m
//  iOSModules
//
//  Created by 石城磊 on 13/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraRecordControl.h"

@interface IMCameraRecordControl ()

@property (nonatomic, assign )  NSTimeInterval touchDuration;

@end

@implementation IMCameraRecordControl

// Set max duration of video
- (void)setMaxVideoDuration:(NSTimeInterval)maxVideoDuration {
    if (maxVideoDuration == 0.0f) {
        _maxVideoDuration   =   CGFLOAT_MAX;
    }
    _maxVideoDuration   =   maxVideoDuration;
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
        if (self.cameraHandler) {
            self.cameraHandler(IMCameraRecordControlTypeVideo);
        }
        if ((event.timestamp - self.touchDuration) == self.maxVideoDuration) {
            IMDebugLog(@"Video recorded the maximum duration");
            if (self.cameraHandler) {
                self.cameraHandler(IMCameraRecordControlTypeCancel);
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
    }
}

@end
