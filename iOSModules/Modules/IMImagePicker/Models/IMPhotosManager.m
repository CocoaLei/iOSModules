//
//  IMPhotosManager.m
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotosManager.h"

@interface IMPhotosManager ()

@end

@implementation IMPhotosManager

+ (IMPhotosManager *)sharedIMPhotosManger {
    static dispatch_once_t onceToken;
    static IMPhotosManager *sharedPhotoManager;
    dispatch_once(&onceToken, ^{
        if (!sharedPhotoManager) {
            sharedPhotoManager  =   [[self alloc] init];
        }
    });
    return sharedPhotoManager;
}

#pragma mark -
#pragma mark - Get photo album
- (NSArray *)loadAllPhotoAlbumsFromDevice {

    NSMutableArray *tempAlbumsMutArray  =   [[NSMutableArray alloc] init];
    [tempAlbumsMutArray addObjectsFromArray:[self loadMyPhotoAlbumsFromDevice]];
    [tempAlbumsMutArray addObjectsFromArray:[self loadSmartPhotoAlbumsFromDevice]];
//    [tempAlbumsMutArray addObjectsFromArray:[self loadMomentPhotoAlbumsFromDevice]];
    return [tempAlbumsMutArray copy];
}

- (NSArray *)loadMyPhotoAlbumsFromDevice {
    return [self loadPhotoAlbumFromDeviceWithType:PHAssetCollectionTypeAlbum];
}

- (NSArray *)loadSmartPhotoAlbumsFromDevice {
    return [self loadPhotoAlbumFromDeviceWithType:PHAssetCollectionTypeSmartAlbum];
}

- (NSArray *)loadMomentPhotoAlbumsFromDevice {
    return [self loadPhotoAlbumFromDeviceWithType:PHAssetCollectionTypeMoment];
}

- (NSArray *)loadPhotoAlbumFromDeviceWithType:(PHAssetCollectionType)albumType {
    PHFetchResult *albumsFetchResult   =   [PHAssetCollection fetchAssetCollectionsWithType:albumType
                                                                                    subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                    options:nil];
    NSMutableArray *tempAlbumsMutArr   =   [[NSMutableArray alloc] initWithCapacity:albumsFetchResult.count];
    PHFetchOptions *fetchOptions       =   [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors       =   @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    for (PHCollection *assetCollection in albumsFetchResult) {
        @autoreleasepool {
            if ([assetCollection isKindOfClass:[PHAssetCollection class]]) {
                NSString *albumTitle                =   assetCollection.localizedTitle;
                PHFetchResult *assetFetchResult     =   [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                                                                                      options:nil];
                NSUInteger assetCount               =   assetFetchResult.count;
                if (self.photoRequestSize.width == 0 && self.photoRequestSize.height == 0) {
                    // if you not set a value to photo request size
                    CGFloat screenScale     =   [UIScreen mainScreen].scale;
                    self.photoRequestSize   =   CGSizeMake(60.0f*screenScale, 60.0f*screenScale);
                }
                UIImage *albumCoverImage            =   [self requestPreviewImageFromAsset:[assetFetchResult firstObject] withSize:self.photoRequestSize contentMode:PHImageContentModeAspectFill];
                NSDictionary *albumDetailDict       =   @{IM_ALBUM_TITLE               :   albumTitle,
                                                          IM_ALBUM_PHOTO_COUNT         :   @(assetCount),
                                                          IM_ALBUM_COVER_IMAGE         :   albumCoverImage,
                                                          IM_ALBUM_ASSET_COLLECZTION   :   assetCollection
                                                          };
                [tempAlbumsMutArr addObject:albumDetailDict];
            }
        }
        
    }
    return [tempAlbumsMutArr copy];
}

#pragma mark -
#pragma mark - Get photos from album
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection {
    PHFetchResult *assetFetchResult     =   [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                               options:nil];
    NSMutableArray *tempPhotoMutArr     =   [[NSMutableArray alloc] initWithCapacity:assetFetchResult.count];
    for (PHAsset *asset in assetFetchResult) {
        [tempPhotoMutArr addObject:asset];
    }
    return [tempPhotoMutArr copy];
}

#pragma mark -
#pragma mark - Get preview photo with asset
- (void)requestPreviewImageFromAsset:(PHAsset *)asset
                             withSize:(CGSize)imageSize
                          contentMode:(PHImageContentMode)imageContentMode
                      requestFinished:(ImageRequestFinished)requestFinised {
    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.resizeMode                  =   PHImageRequestOptionsResizeModeFast;
    opt.deliveryMode                =   PHImageRequestOptionsDeliveryModeFastFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:imageSize
                                                     contentMode:imageContentMode
                                                         options:opt
                                                   resultHandler:^(UIImage * _Nullable resultImage, NSDictionary * _Nullable imageInfo) {
                                                       if (resultImage && [[imageInfo objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                                                           requestFinised(imageInfo, resultImage);
                                                       }
                                                   }];
}

/*
 @DeliveryMode
    PHImageRequestOptionsDeliveryModeOpportunistic
    -- client may get several image results when the call is asynchronous or will get one result when the call is synchronous
    PHImageRequestOptionsDeliveryModeHighQualityFormat
    -- client will get one result only and it will be as asked or better than asked (sync requests are automatically processed this way regardless of the specified mode)
    PHImageRequestOptionsDeliveryModeFastFormat
    -- client will get one result only and it may be degraded and only available when synchronous = YES
*/
- (UIImage *)requestPreviewImageFromAsset:(PHAsset *)asset withSize:(CGSize)imageSize contentMode:(PHImageContentMode)imageContentMode {
    if (asset.mediaType != PHAssetMediaTypeImage) {
        return [UIImage imageNamed:@"im_image_placeholder"];
    }

    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.deliveryMode                =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
    opt.resizeMode                  =   PHImageRequestOptionsResizeModeExact;
    opt.synchronous                 =   YES;
    __block UIImage *resultImage    =   [[UIImage alloc] init];
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:imageSize
                                                     contentMode:imageContentMode
                                                         options:opt
                                                   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHLivePhotoInfoCancelledKey] boolValue] && ![info objectForKey:PHLivePhotoInfoErrorKey]);
        if (downloadFinined && result) {
           
        }
    }];
    return  resultImage;
}

#pragma mark - Get original photo with asset
/*
 PHImageFileOrientationKey
 PHImageFileSandboxExtensionTokenKey
 PHImageFileURLKey
 PHImageFileUTIKey
 
 
 PHImageResultDeliveredImageFormatKey
 PHImageResultWantedImageFormatKey
 
 PHImageResultIsDegradedKey
    --- > A key whose value indicates whether the result image is a low-quality substitute for the requested image.
 PHImageResultIsInCloudKey
    --- > A key whose value indicate whether photo asset data is stored on the local device or must be downloaded from iCloud.
 PHImageResultIsPlaceholderKey

 */
- (UIImage *)requestOriginalImageFromAsset:(PHAsset *)asset {
    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.deliveryMode                =   PHImageRequestOptionsDeliveryModeOpportunistic;
    __block UIImage *resultImage    =   [[UIImage alloc] init];
    [[PHImageManager defaultManager]  requestImageForAsset:asset
                                                targetSize:PHImageManagerMaximumSize
                                               contentMode:PHImageContentModeDefault
                                                   options:opt
                                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable ImageResult) {
                                                 //
                                                 if ([ImageResult.allKeys containsObject:PHImageErrorKey]) {
                                                     resultImage   =   [UIImage imageNamed:@"im_image_placeholder"];
                                                 }
                                                 //
                                                 if ([ImageResult.allKeys containsObject:PHImageCancelledKey]) {
                                                     resultImage   =   [UIImage imageNamed:@"im_image_placeholder"];
                                                 }
                                                 //
                                                 if ([ImageResult.allKeys containsObject:PHImageResultIsInCloudKey]) {
                                                     resultImage   =   [UIImage imageNamed:@"im_image_placeholder"];
                                                 }
                                                 //
                                                 if (result) {
                                                     resultImage =  result;
                                                 }
                                             }];
    return  resultImage;
}

@end
