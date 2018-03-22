//
//  IMCameraPreview.m
//  iOSModules
//
//  Created by 石城磊 on 13/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraPreview.h"

@interface IMCameraPreview ()

//
@property (nonatomic, strong)   AVCaptureVideoPreviewLayer  *im_captureVideoPreviewLayer;
@property (nonatomic, strong)   AVCaptureSession            *im_captureSession;


@end

@implementation IMCameraPreview

- (instancetype)initWithFrame:(CGRect)frame camera:(IMCamera *)camera {
    if (self = [super initWithFrame:frame]) {
        _im_captureSession  =   camera.im_captureSeesion;
        [self initialCameraPreview];
    }
    return self;
}

#pragma mark - Setup
- (void)initialCameraPreview {
    self.im_captureVideoPreviewLayer                = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.im_captureSession];
    self.im_captureVideoPreviewLayer.videoGravity   = AVLayerVideoGravityResizeAspectFill;
    self.im_captureVideoPreviewLayer.bounds         = self.bounds;
    self.im_captureVideoPreviewLayer.position       = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self.layer addSublayer:self.im_captureVideoPreviewLayer];
}




@end
