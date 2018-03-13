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
#import "IMCameraPreview.h"

typedef NS_ENUM(NSInteger, IMCameraCatpureType) {
    IMCameraCatpureTypePhoto  = 0,
    IMCameraCatpureTypeVideo  = 1,
    IMCameraCatpureTypeCancel = 2
};

@interface IMCamera ()
<
    AVCapturePhotoCaptureDelegate
>
// Record apperance
@property (nonatomic, strong)   IMCameraPreview             *im_videoRecordPreview;
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
@property (nonatomic, assign)   IMCameraCatpureType         currentCameraType;

@end

@implementation IMCamera

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewsApperance];
    [self setUpCaptureSession];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Private methods
- (void)configureViewsApperance {
    [self.view setBackgroundColor:[UIColor clearColor]];
    //
}

- (void)setUpCaptureSession {
    if (!self.im_captureSeesion) {
        //
        self.currentCameraType  =   IMCameraCatpureTypePhoto;
        self.im_captureSeesion  =   [[AVCaptureSession alloc] init];
        // 默认为拍照模式
        self.im_photoCaptureDevice      =   [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
        NSError *photoDeviceInputerror  =   nil;
        self.im_photoCaptureDeviceInput =   [AVCaptureDeviceInput deviceInputWithDevice:self.im_photoCaptureDevice error:&photoDeviceInputerror];
        if ([self.im_captureSeesion canAddInput:self.im_photoCaptureDeviceInput]) {
            [self.im_captureSeesion addInput:self.im_photoCaptureDeviceInput];
        }
        self.im_photoOutput             =   [[AVCapturePhotoOutput alloc] init];
        if ([self.im_captureSeesion canAddOutput:self.im_photoOutput]) {
            [self.im_captureSeesion addOutput:self.im_photoOutput];
        }
        //
        self.im_videoRecordPreview      =   [[IMCameraPreview alloc] initWithFrame:self.view.bounds captureSession:self.im_captureSeesion];
        [self.im_videoRecordPreview setBackgroundColor:[UIColor clearColor]];
        [self.im_videoRecordPreview.startRecordButton setMaxVideoDuration:15.0f];
        //
        __weak typeof(self) weakSelf    =   self;
        [self.im_videoRecordPreview.startRecordButton setCameraHandler:^(IMCameraRecordControlType handleType) {
            switch (handleType) {
                case IMCameraRecordControlTypePhoto:
                {
                    [weakSelf   startCameraCapture:IMCameraCatpureTypePhoto];
                }
                    break;
                case IMCameraRecordControlTypeVideo:
                {
                    [weakSelf   startCameraCapture:IMCameraCatpureTypeVideo];
                }
                    break;
                case IMCameraRecordControlTypeCancel:
                {
                    [weakSelf   startCameraCapture:IMCameraCatpureTypeCancel];
                }
                    break;
                default:
                    break;
            }
        }];
        [self.view addSubview:self.im_videoRecordPreview];
        //
        [self.im_captureSeesion startRunning];
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

- (void)startCameraCapture:(IMCameraCatpureType)captureType {
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
        } else {
            switch (captureType) {
                case IMCameraCatpureTypePhoto:
                {
                    if ([self.im_captureSeesion isRunning]) {
                        [self.im_captureSeesion startRunning];
                    }
                    [self.im_photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
                }
                    break;
                case IMCameraCatpureTypeVideo:
                {
                    //
                    self.im_audioCaptureDevice      =   [AVCaptureDevice defaultDeviceWithMediaType:AVCaptureDeviceTypeBuiltInMicrophone];
                    NSError *audioDeviceInputerror  =   nil;
                    self.im_audioCaptureDeviceInput =   [AVCaptureDeviceInput deviceInputWithDevice:self.im_audioCaptureDevice error:&audioDeviceInputerror];
                    if ([self.im_captureSeesion canAddInput:self.im_audioCaptureDeviceInput]) {
                        [self.im_captureSeesion addInput:self.im_audioCaptureDeviceInput];
                    }
                    //
                    self.im_videoOutput             =   [[AVCaptureVideoDataOutput alloc] init];
                    if ([self.im_captureSeesion canAddOutput:self.im_videoOutput]) {
                        [self.im_captureSeesion addOutput:self.im_videoOutput];
                    }
                    
                }
                    break;
                case IMCameraCatpureTypeCancel:
                    break;
                default:
                    break;
            }
        }
    }];
    //
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    if (!error) {
        NSData *photoData   =   [photo fileDataRepresentation];
        UIImage *photo      =   [UIImage imageWithData:photoData];
        [self.im_captureSeesion stopRunning];
    } else {
        IMDebugLog(@"error : %@", error.localizedDescription);
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didCapturePhotoForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings {
    
}


@end
