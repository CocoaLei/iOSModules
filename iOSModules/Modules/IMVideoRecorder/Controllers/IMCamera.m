//
//  IMVideoRecordViewController.m
//  iOSModules
//
//  Created by 石城磊 on 01/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCamera.h"
#import <AVFoundation/AVFoundation.h>
#import "IMCameraHelper.h"

@interface IMCamera ()
// Record apperance
@property (nonatomic, strong)   UIView                      *im_videoRecordPreview;
@property (nonatomic, strong)   AVCaptureVideoPreviewLayer  *im_captureVideoPreviewLayer;
//
@property (nonatomic, strong)   AVCaptureSession            *im_captureSeesion;
//
@property (nonatomic, strong)   AVCaptureDevice             *im_photoCaptureDevice;
@property (nonatomic, strong)   AVCaptureDeviceInput        *im_photoCaptureDeviceInput;
@property (nonatomic, strong)   AVCapturePhotoOutput        *im_photoOutput;
//
@property (nonatomic, strong)   AVCaptureDevice             *im_audioCaptureDevice;
@property (nonatomic, strong)   AVCaptureDeviceInput        *im_audioCaptureDeviceInput;
@property (nonatomic, strong)   AVCaptureAudioDataOutput    *im_audioOutput;
//
@property (nonatomic, strong)   AVCaptureDevice             *im_videoCaptureDevice;
@property (nonatomic, strong)   AVCaptureDeviceInput        *im_videoCaptureDeviceInput;
@property (nonatomic, strong)   AVCaptureVideoDataOutput    *im_videoOutput;

//
@property (nonatomic, strong)   UIButton *recordButton;
@property (nonatomic, strong)   UIButton *dismissButton;
@property (nonatomic, strong)   UIButton *switchCameraButton;

@end

@implementation IMCamera

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewsApperance];
    [self setUpCaptureSession];
}

#pragma mark - Private methods
- (void)configureViewsApperance {
    [self.view setBackgroundColor:[UIColor clearColor]];
    //
    self.im_videoRecordPreview  =   [[UIView alloc] initWithFrame:CGRectZero];
    [self.im_videoRecordPreview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.im_videoRecordPreview];
}

- (void)setUpCaptureSession {
    if (!self.im_captureSeesion) {
        self.im_captureSeesion  =   [[AVCaptureSession alloc] init];
        //
        self.im_photoCaptureDevice  =   [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *photoDeviceInputerror = nil;
        self.im_photoCaptureDeviceInput =   [AVCaptureDeviceInput deviceInputWithDevice:self.im_photoCaptureDevice error:&photoDeviceInputerror];
        if ([self.im_captureSeesion canAddInput:self.im_photoCaptureDeviceInput]) {
            [self.im_captureSeesion addInput:self.im_photoCaptureDeviceInput];
        }
        //
        self.im_audioCaptureDevice  =   [AVCaptureDevice defaultDeviceWithMediaType:AVCaptureDeviceTypeBuiltInMicrophone];
        NSError *audioDeviceInputerror = nil;
        self.im_audioCaptureDeviceInput =   [AVCaptureDeviceInput deviceInputWithDevice:self.im_audioCaptureDevice error:&audioDeviceInputerror];
        if ([self.im_captureSeesion canAddInput:self.im_audioCaptureDeviceInput]) {
            [self.im_captureSeesion addInput:self.im_audioCaptureDeviceInput];
        }
        //
        self.im_videoCaptureDevice =   [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *videoDeviceInputerror = nil;
        self.im_videoCaptureDeviceInput =   [AVCaptureDeviceInput deviceInputWithDevice:self.im_videoCaptureDevice error:&videoDeviceInputerror];
        if ([self.im_captureSeesion canAddInput:self.im_videoCaptureDeviceInput]) {
            [self.im_captureSeesion addInput:self.im_videoCaptureDeviceInput];
        }
    }
}

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)devivePosition {
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:devivePosition];
    for (AVCaptureDevice *captureDevice in discoverySession.devices) {
        if (captureDevice.deviceType == AVCaptureDeviceTypeBuiltInWideAngleCamera) {
            return captureDevice;
        }
    }
    return nil;
}

- (void)startRecordVideo {
    //
    [IMCameraHelper im_CameraAuthorizationDetection:^(BOOL authorized) {
        if (!authorized) {
            UIAlertController *alertController  =   [UIAlertController alertControllerWithTitle:@"Unauthorized access to camera"
                                                                                        message:@"If you need to continue using the camera to do the job, go to the Settings reference to authorize access to the camera device."
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }];
    //
}

@end
