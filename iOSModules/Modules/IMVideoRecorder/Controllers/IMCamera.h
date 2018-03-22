//
//  IMVideoRecordViewController.h
//  iOSModules
//
//  Created by 石城磊 on 01/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class IMCamera;

typedef void (^IMPhotoCaptureHandler)(IMCamera *camera, UIImage *image, NSError *error);

@interface IMCamera : NSObject

//
@property (nonatomic, strong)   AVCaptureSession            *im_captureSeesion;
//
-(void)photoCapture:(IMPhotoCaptureHandler)photoCaptureHandler
     exactSeenImage:(BOOL)exactSeenImage
     animationBlock:(void (^)(AVCaptureVideoPreviewLayer *))animationBlock;

@end
