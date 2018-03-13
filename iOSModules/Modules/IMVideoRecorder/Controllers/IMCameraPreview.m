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

- (instancetype)initWithFrame:(CGRect)frame captureSession:(AVCaptureSession *)session {
    if (self = [super initWithFrame:frame]) {
        _im_captureSession  =   session;
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
    //
    [self addSubview:self.dismissButton];
    [self addSubview:self.switchCameraButton];
    //
    [self addSubview:self.startRecordButton];
}

#pragma mark - Lazy Initializations
- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds)+16.0f, 16.0f, 24.0f, 24.0f)];
        [_dismissButton setImage:[UIImage imageNamed:@"im_dismiss_white"] forState:UIControlStateNormal];
    }
    return _dismissButton;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds)-40.0f, 16.0f, 24.0f, 24.0f)];
        [_switchCameraButton setImage:[UIImage imageNamed:@"im_camera_switch_white"] forState:UIControlStateNormal];
    }
    return _switchCameraButton;
}

- (IMCameraRecordControl *)startRecordButton {
    if (!_startRecordButton) {
        _startRecordButton  =   [[IMCameraRecordControl alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds)-24.0f, CGRectGetMaxY(self.bounds)-64.0f, 48.0f, 48.0f)];
        [_startRecordButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _startRecordButton;
}

@end
