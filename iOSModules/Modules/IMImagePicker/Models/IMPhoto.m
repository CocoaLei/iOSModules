//
//  IMPhoto.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/5.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhoto.h"

@interface IMPhoto ()

@property (nonatomic, strong) PHAsset               *photoAsset;
@property (nonatomic, assign) CGSize                photoTargetSize;

@property (nonatomic, assign) PHImageRequestID      assetRequestId;
@property (nonatomic, strong) UIImage               *assetImage;
@property (nonatomic, assign) PHImageContentMode    imageContentMode;
@property (nonatomic, assign) BOOL                  isLoading;


@end

@implementation IMPhoto

@synthesize resultImage =   _resultImage;

#pragma mark - Constructor
+ (IMPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode {
    return [[IMPhoto alloc] initWithAsset:asset targetSize:targetSize contentMode:contentMode];
}

- (instancetype)initWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode {
    if (self = [super init]) {
        self.photoAsset         =   asset;
        self.photoTargetSize    =   targetSize;
        self.assetRequestId     =   PHInvalidImageRequestID;
        self.imageContentMode   =   contentMode;
        [self loadResultImage];
    }
    return self;
}

#pragma mark - Destory
- (void)dealloc {
    //
    [self cancelAnyImageRequest];
}

#pragma mark - IMPhotoProtocol
- (UIImage *)resultImage {
    return _resultImage;
}

-(void)loadImageFromAsset {
    NSAssert([[NSThread currentThread] isMainThread], @"You should't call this method in main thread !");
    if (self.isLoading) {
        return;
    }
    self.isLoading      =   YES;
    //
    @try {
        if (self.resultImage) {
            [self imageLoadFinished];
        } else {
            [self loadResultImage];
        }
    }
    //
    @catch (NSException *exception) {
        self.resultImage    =   nil;
        self.isLoading      =   NO;
        [self imageLoadFinished];
    }
}

- (void)cancelAnyImageRequest {
    if (self.assetRequestId != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.assetRequestId];
        self.assetRequestId = PHInvalidImageRequestID;
    }
    self.isLoading  =   NO;
}

#pragma mark - Private methods
- (void)loadResultImage {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.resultImage) {
        self.assetImage =   self.resultImage;
        self.isLoading  =   NO;
        [self imageLoadFinished];
    } else if (self.photoAsset) {
        [self loadImageFromAsset:self.photoAsset targetSize:self.photoTargetSize];
    } else {
        [self imageLoadFinished];
    }
}

- (void)loadImageFromAsset:(PHAsset *)asset targetSize:(CGSize)targetSize {
    PHImageRequestOptions *options  =   [PHImageRequestOptions new];
    options.resizeMode              =   self.imageContentMode==PHImageContentModeAspectFill?PHImageRequestOptionsResizeModeExact:PHImageRequestOptionsResizeModeFast;
    options.deliveryMode            =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous             =   false;
    options.progressHandler         =   ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSDictionary* progressDict  = @{IMPHOTO_LOADING_PROGRESS_KEY    :   @(progress),
                                        IMPHOTO_LOADING_PHOTOT_KEY      :   self
                                        };
        [[NSNotificationCenter defaultCenter] postNotificationName:IMPHOTO_LOADING_INPROGRESS_NOTIFICATION object:progressDict];
    };
    self.assetRequestId             =   [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                                   targetSize:targetSize
                                                                                  contentMode:self.imageContentMode
                                                                                      options:options
                                                                                resultHandler:^(UIImage *resultImage, NSDictionary *imageInfo) {
                                                                                    
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        BOOL downloadFinined = (![[imageInfo objectForKey:PHLivePhotoInfoCancelledKey] boolValue]
                                                                                                                && ![[imageInfo objectForKey:PHLivePhotoInfoErrorKey] boolValue]);
                                                                                        if (downloadFinined && resultImage) {
                                                                                            self.resultImage    =   resultImage;
                                                                                            [self imageLoadFinished];
                                                                                        } else {
                                                                                            IMDebugLog(@"ImageInformation is %@",imageInfo);
                                                                                            self.resultImage    =   [UIImage imageNamed:@"im_image_placeholder"];
                                                                                        }
                                                                                    });
                                                                                }];
}

- (void)imageLoadFinished {
    self.isLoading  =   NO;
    [self performSelector:@selector(postPhotoDidLoadedNotification) withObject:nil];
}

- (void)postPhotoDidLoadedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMPHOTO_LOADING_FINISHED_NOTIFICATION object:self];
}



@end
