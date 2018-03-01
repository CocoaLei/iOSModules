//
//  IMCameraHelper.h
//  iOSModules
//
//  Created by 石城磊 on 01/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCameraHelper : NSObject

+ (void)im_CameraAuthorizationDetection:(void (^)(BOOL authorized))completionBlock;

@end
