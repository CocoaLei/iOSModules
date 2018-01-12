//
//  IMPhotoProtocol.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/5.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMPHOTO_LOADING_FINISHED_NOTIFICATION             @"IMPHOTO_LOADING_FINISHED_NOTIFICATION"
#define IMPHOTO_LOADING_INPROGRESS_NOTIFICATION           @"IMPHOTO_LOADING_INPROGRESS_NOTIFICATION"

#define ORIGINAL_INPROGRESS_NOTIFICATION                  @"ORIGINAL_INPROGRESS_NOTIFICATION"
#define ORIGINAL_LOADING_FINISHED_NOTIFICATION            @"ORIGINAL_LOADING_FINISHED_NOTIFICATION"

#define IMPHOTO_LOADING_PROGRESS_KEY                      @"IMPHOTO_LOADING_PROGRESS_KEY"
#define IMPHOTO_LOADING_PHOTOT_KEY                        @"IMPHOTO_LOADING_PHOTOT_KEY"

@protocol IMPhotoProtocol <NSObject>

@required
@property (nonatomic, strong) PHAsset *photoAsset;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) UIImage *originalImage;

- (void)loadImageFromAsset;

@optional
- (void)loadOriginalImageFromAsset;
- (void)cancelAnyImageRequest;

@end
