//
//  IMCameraHelper.m
//  iOSModules
//
//  Created by 石城磊 on 01/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation IMCameraHelper

+ (void)im_CameraAuthorizationDetection:(void (^)(BOOL authorized))completionBlock {
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
        // Apply to the user for permission to use the camera.
        // The user is only asked for permission the first time the client requests access. Later calls use the permission granted by the user.
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(granted);
                }
            });
        }];
    } else {
        completionBlock(YES);
    }
}

@end
