//
//  IMVideoRecordViewController.m
//  iOSModules
//
//  Created by 石城磊 on 01/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCamera.h"
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

//
@property (nonatomic, copy  )   IMPhotoCaptureHandler       photoCaptureHandler;
@end

@implementation IMCamera

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self setUpCaptureSession];
    }
    return self;
}

#pragma mark - Private methods
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

-(void)photoCapture:(IMPhotoCaptureHandler)photoCaptureHandler
     exactSeenImage:(BOOL)exactSeenImage
     animationBlock:(void (^)(AVCaptureVideoPreviewLayer *))animationBlock {
    __weak typeof(self) weakSelf    =   self;
    [IMCameraHelper im_CameraAuthorizationDetection:^(BOOL authorized) {
        if (!authorized) {
            return;
        } else {
            weakSelf.photoCaptureHandler    =   photoCaptureHandler;
            // Capture an image
            if (![self.im_captureSeesion isRunning]) {
                [self.im_captureSeesion startRunning];
            }
            if (@available(iOS 11.0, *)) {
                [self.im_photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
            }
        }
    }];
}

- (void)startCameraCapture:(IMCameraCatpureType)captureType {
    //
    [IMCameraHelper im_CameraAuthorizationDetection:^(BOOL authorized) {
        if (!authorized) {
            return;
        } else {
            switch (captureType) {
                case IMCameraCatpureTypePhoto:
                {
                    if (![self.im_captureSeesion isRunning]) {
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
    NSData *photoData   =   [photo fileDataRepresentation];
    UIImage *image      =   [UIImage imageWithData:photoData];
    self.photoCaptureHandler(self, image, error);
    [self.im_captureSeesion stopRunning];
}


@end
