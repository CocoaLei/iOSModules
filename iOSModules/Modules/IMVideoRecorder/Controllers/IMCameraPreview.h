//
//  IMCameraPreview.h
//  iOSModules
//
//  Created by 石城磊 on 13/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IMCameraRecordControl.h"
#import "IMCamera.h"

@interface IMCameraPreview : UIView
//
@property (nonatomic, strong)   UIButton                    *dismissButton;
@property (nonatomic, strong)   IMCameraRecordControl       *startRecordButton;
@property (nonatomic, strong)   UIButton                    *switchCameraButton;

- (instancetype)initWithFrame:(CGRect)frame camera:(IMCamera *)camera;

@end
