//
//  IMPhoto.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/5.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhoto.h"

@interface IMPhoto ()


@property (nonatomic, assign) CGSize                photoTargetSize;

@property (nonatomic, assign) PHImageRequestID      assetRequestId;
@property (nonatomic, assign) PHImageRequestID      assetOriginalImageRequestId;

@property (nonatomic, strong) UIImage               *assetImage;
@property (nonatomic, assign) PHImageContentMode    imageContentMode;
@property (nonatomic, assign) BOOL                  isLoading;
@property (nonatomic, assign) BOOL                  isOriginalLoading;


@end

@implementation IMPhoto

@synthesize resultImage     =   _resultImage;
@synthesize originalImage   =   _originalImage;
@synthesize photoAsset      =   _photoAsset;

#pragma mark - Constructor
+ (IMPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode {
    return [[IMPhoto alloc] initWithAsset:asset targetSize:targetSize contentMode:contentMode];
}

- (instancetype)initWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode {
    if (self = [super init]) {
        self.photoAsset                     =   asset;
        self.photoTargetSize                =   targetSize;
        self.assetRequestId                 =   PHInvalidImageRequestID;
        self.assetOriginalImageRequestId    =   PHInvalidImageRequestID;
        self.imageContentMode               =   contentMode;
    }
    return self;
}

#pragma mark - Destory
- (void)dealloc {
    //
    self.originalImage  =   nil;
    self.resultImage    =   nil;
    [self cancelAnyImageRequest];
}

#pragma mark - IMPhotoProtocol
- (UIImage *)resultImage {
    return _resultImage;
}

- (UIImage *)originalImage {
    return _originalImage;
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

- (void)loadOriginalImageFromAsset {
    NSAssert([[NSThread currentThread] isMainThread], @"You should't call this method in main thread !");
    if (self.isOriginalLoading) {
        return;
    }
    self.isOriginalLoading      =   YES;
    //
    @try {
        if (self.originalImage) {
            [self originalImageLoadFinished];
        } else {
            [self loadOriginalImage];
        }
    }
    //
    @catch (NSException *exception) {
        self.originalImage          =   nil;
        self.isOriginalLoading      =   NO;
        [self originalImageLoadFinished];
    }
}

- (void)cancelAnyImageRequest {
    if (self.assetRequestId != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.assetRequestId];
        self.assetRequestId = PHInvalidImageRequestID;
    }
    if (self.assetOriginalImageRequestId != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.assetOriginalImageRequestId];
        self.assetOriginalImageRequestId    =   PHInvalidImageRequestID;
    }
    self.isLoading  =   NO;
}

#pragma mark - Private methods
- (void)loadResultImage {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.resultImage) {
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

- (void)loadOriginalImage {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.originalImage) {
        self.isOriginalLoading  =   NO;
        [self originalImageLoadFinished];
    } else if (self.photoAsset) {
        [self loadOriginalImageFromAsset:self.photoAsset];
    } else {
        [self originalImageLoadFinished];
    }
}

- (void)loadOriginalImageFromAsset:(PHAsset *)photoAsset {
    PHImageRequestOptions *options  =   [PHImageRequestOptions new];
    options.networkAccessAllowed    =   YES; //  A Boolean value that specifies whether Photos can download the requested image from iCloud.
    options.version                 =   PHImageRequestOptionsVersionOriginal;
    options.resizeMode              =   PHImageRequestOptionsResizeModeNone;
    options.deliveryMode            =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous             =   NO;
    options.progressHandler         =   ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSDictionary* progressDict  = @{IMPHOTO_LOADING_PROGRESS_KEY    :   @(progress),
                                        IMPHOTO_LOADING_PHOTOT_KEY      :   self
                                        };
        [[NSNotificationCenter defaultCenter] postNotificationName:ORIGINAL_INPROGRESS_NOTIFICATION object:progressDict];
    };
    
    self.assetOriginalImageRequestId=   [[PHImageManager defaultManager] requestImageForAsset:photoAsset
                                                                                   targetSize:PHImageManagerMaximumSize
                                                                                  contentMode:PHImageContentModeDefault // Default value is PHImageContentModeAspectFit
                                                                                      options:options
                                                                                resultHandler:^(UIImage *resultImage, NSDictionary *imageInfo) {
                                                                                    
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        if ([imageInfo objectForKey:PHImageErrorKey]) {
                                                                                            // An error that occurred when Photos attempted to load the image.
                                                                                        }
                                                                                        if ([[imageInfo objectForKey:PHImageCancelledKey] boolValue]) {
                                                                                            // The image request was canceled.
                                                                                        }
                                                                                        if ([[imageInfo objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                                                                                            // The result image is a low-quality substitute for the requested image.
                                                                                        }
                                                                                        if ([[imageInfo objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                                                                                            // Asset data must be downloaded from iCloud.
                                                                                        }
                                                                                        if (resultImage) {
                                                                                            self.originalImage    =   resultImage;
                                                                                            [self originalImageLoadFinished];
                                                                                        } else {
                                                                                            self.originalImage    =   [UIImage imageNamed:@"im_image_placeholder"];
                                                                                        }
                                                                                    });
                                                                                    
                                                                                }];
}


- (void)imageLoadFinished {
    self.isLoading          =   NO;
    [self performSelector:@selector(postPhotoDidLoadedNotification) withObject:self];
}

- (void)originalImageLoadFinished {
    self.isOriginalLoading  =   NO;
    [self performSelector:@selector(postOriginalPhotoDidLoadedNotification) withObject:nil];
}

- (void)postPhotoDidLoadedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:IMPHOTO_LOADING_FINISHED_NOTIFICATION object:self];
}

- (void)postOriginalPhotoDidLoadedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ORIGINAL_LOADING_FINISHED_NOTIFICATION object:self.photoAsset];
}


@end
