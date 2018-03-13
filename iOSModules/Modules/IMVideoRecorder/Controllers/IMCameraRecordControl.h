//
//  IMCameraRecordControl.h
//  iOSModules
//
//  Created by 石城磊 on 13/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMCameraRecordControlType) {
    IMCameraRecordControlTypePhoto  =   0,
    IMCameraRecordControlTypeVideo  =   1,
    IMCameraRecordControlTypeCancel =   2
};

typedef void (^CamearRecordControlHandler)(IMCameraRecordControlType handleType);

@interface IMCameraRecordControl : UIControl

@property (nonatomic, assign )  NSTimeInterval maxVideoDuration;
@property (nonatomic, copy   )  CamearRecordControlHandler cameraHandler;


@end
