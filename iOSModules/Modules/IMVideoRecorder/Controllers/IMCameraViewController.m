//
//  IMCameraViewController.m
//  iOSModules
//
//  Created by 石城磊 on 15/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraViewController.h"
#import "IMCameraPreview.h"
#import "IMCamera.h"

@interface IMCameraViewController ()

@property (nonatomic, strong    )   IMCameraPreview *cameraPreview;
@property (nonatomic, strong    )   IMCamera        *camera;
//
//
@property (nonatomic, strong)   UIButton                    *dismissButton;
@property (nonatomic, strong)   IMCameraRecordControl       *startRecordButton;
@property (nonatomic, strong)   UIButton                    *switchCameraButton;
//
@property (nonatomic, strong)   UIButton                    *completeButton;
@property (nonatomic, strong)   UIButton                    *continueButton;

@end

@implementation IMCameraViewController

#pragma mark  - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpIMCamera];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Initial setup
- (void)setUpIMCamera {
    self.camera         =   [[IMCamera alloc] init];
    self.cameraPreview  =   [[IMCameraPreview alloc] initWithFrame:self.view.bounds camera:self.camera];
    [self.view addSubview:self.cameraPreview];
    //
    [self.view addSubview:self.dismissButton];
    [self.view addSubview:self.switchCameraButton];
    [self.view addSubview:self.startRecordButton];
    //
    [self.startRecordButton configureRecordControlWithType:IMCameraRecordControlTypePhoto];
    __weak typeof(self) weak_self   =   self;
    [self.startRecordButton setCameraHandler:^(IMCameraRecordControlType handleType) {
        switch (handleType) {
            case IMCameraRecordControlTypePhoto:
            {
                [weak_self.camera photoCapture:^(IMCamera *camera, UIImage *image, NSError *error) {
                    if (!error) {
                        // Capture photo succeed
                        [weak_self switchHandleMode:YES];
                    }
                }
                                exactSeenImage:YES
                                animationBlock:^(AVCaptureVideoPreviewLayer *previewLayer) {
                               
                           }];
            }
                break;
            case IMCameraRecordControlTypeVideo:
            {
                
            }
                break;
            case IMCameraRecordControlTypeCancel:
            {
                
            }
                break;
            default:
                break;
        }
    }];
}

- (void)switchHandleMode:(BOOL)isHandle {
    if (isHandle) {
        [self.continueButton setFrame:self.startRecordButton.frame];
        [self.completeButton setFrame:self.startRecordButton.frame];
        [self.view addSubview:self.continueButton];
        [self.view addSubview:self.completeButton];
        [UIView animateWithDuration:0.25f animations:^{
            [self.continueButton setFrame:CGRectMake(CGRectGetMinX(self.view.bounds)+16.0f, CGRectGetMaxY(self.view.bounds)-80.0f, 48.0f, 48.0f)];
            [self.completeButton setFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-64.0f, CGRectGetMaxY(self.view.bounds)-80.0f, 48.0f, 48.0f)];
            self.startRecordButton.alpha    =   0.0f;
            self.startRecordButton.enabled  =   NO;
        }];
    } else {
        [UIView animateWithDuration:0.25f animations:^{
            [self.continueButton removeFromSuperview];
            [self.completeButton  removeFromSuperview];
            self.startRecordButton.alpha    =   1.0f;
            self.startRecordButton.enabled  =   YES;
        }];
    }
}

#pragma mark -  Control methods
- (void)continueButtonAction {
    [self switchHandleMode:NO];
}

- (void)dismissCameraViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy Initializations
- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds)+16.0f, 16.0f, 48.0f, 48.0f)];
        [_dismissButton setImage:[UIImage imageNamed:@"im_dismiss_white"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissCameraViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-40.0f, 16.0f, 48.0f, 48.0f)];
        [_switchCameraButton setImage:[UIImage imageNamed:@"im_camera_switch_white"] forState:UIControlStateNormal];
    }
    return _switchCameraButton;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds)-64.0f, CGRectGetMaxY(self.view.bounds)-80.0f, 48.0f, 48.0f)];
        [_completeButton setImage:[UIImage imageNamed:@"im_complete"] forState:UIControlStateNormal];
    }
    return _completeButton;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton  =   [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds)+16.0f, CGRectGetMaxY(self.view.bounds)-80.0f, 48.0f, 48.0f)];
        [_continueButton setImage:[UIImage imageNamed:@"im_continue"] forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(continueButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueButton;
}

- (IMCameraRecordControl *)startRecordButton {
    if (!_startRecordButton) {
        _startRecordButton  =   [[IMCameraRecordControl alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-24.0f, CGRectGetMaxY(self.view.bounds)-80.0f, 64.0f, 64.0f)];
        [_startRecordButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _startRecordButton;
}


@end
