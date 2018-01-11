//
//  IMPhotosManager.m
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotosManager.h"
#import "IMPhoto.h"
#import "IMAlbum.h"

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
    // Configure fetch options
    PHFetchOptions *fetchOptions        =   [PHFetchOptions new];
    fetchOptions.predicate              =   [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    fetchOptions.sortDescriptors        =   @[[NSSortDescriptor sortDescriptorWithKey:@"estimatedAssetCount" ascending:NO]];
    
    __block NSMutableArray  *albumAssetCollectionMutArray   =   [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf                            =   self;
    // Get all user albums
    PHFetchResult *userAlbums           =   [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                     subtype:PHAssetCollectionSubtypeAny
                                                                                     options:fetchOptions];
    [userAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *aAlbumAssetCollection    =   (PHAssetCollection *)obj;
            IMPhoto *coverPhoto                         =   [weakSelf getCoverPhotoInAlbumCollection:aAlbumAssetCollection];
            IMAlbum *aAlbum                             =   [[IMAlbum alloc] initAlbumModelWithTitle:aAlbumAssetCollection.localizedTitle
                                                                                          photoCount:[weakSelf getAssetCountInAlbumCollection:aAlbumAssetCollection]
                                                                                          albumCover:coverPhoto
                                                                                     albumCollection:aAlbumAssetCollection];
            [albumAssetCollectionMutArray addObject:aAlbum];
        }
    }];
    // Get all smart albums
    PHFetchResult *smartAlbums          =   [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                     subtype:PHAssetCollectionSubtypeAny
                                                                                     options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *aAlbumAssetCollection    =   (PHAssetCollection *)obj;
            NSUInteger assetCount                       =   [weakSelf getAssetCountInAlbumCollection:aAlbumAssetCollection];
            if (assetCount > 0) {
                IMPhoto *coverPhoto                         =   [weakSelf getCoverPhotoInAlbumCollection:aAlbumAssetCollection];
                IMAlbum *aAlbum                             =   [[IMAlbum alloc] initAlbumModelWithTitle:aAlbumAssetCollection.localizedTitle
                                                                                              photoCount:assetCount
                                                                                              albumCover:coverPhoto
                                                                                         albumCollection:aAlbumAssetCollection];
                [albumAssetCollectionMutArray addObject:aAlbum];
            }
        }
    }];
    // Sorted by count
    return [albumAssetCollectionMutArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                IMAlbum *albumA =   (IMAlbum *)obj1;
                IMAlbum *albumB =   (IMAlbum *)obj2;
                return [albumB.albumPhotoCount compare:albumA.albumPhotoCount];
            }];
}

- (id <IMPhotoProtocol> )getCoverPhotoInAlbumCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *fetchOptions    =   [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors    =   @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult      =   [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                      options:fetchOptions];
    __block IMPhoto *coverPhoto     =   [[IMPhoto alloc] init];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            PHAsset *resultAsset    =   (PHAsset *)obj;
            if (resultAsset.mediaType == PHAssetMediaTypeImage) {
                coverPhoto =   [IMPhoto photoWithAsset:resultAsset
                                                     targetSize:CGSizeMake(60.0f*[UIScreen mainScreen].scale, 60.0f*[UIScreen mainScreen].scale)
                                                    contentMode:PHImageContentModeAspectFill];
                *stop       =   YES;
            }
        }
    }];
    return coverPhoto;
}

// Note : estimatedAssetCount of PHAssetCollection is just estimates, it will return NSNotFound if a count cannot be quickly returned.
- (NSUInteger)getAssetCountInAlbumCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *fetchOptions    =   [[PHFetchOptions alloc] init];
    fetchOptions.predicate          =   [NSPredicate predicateWithFormat:@"mediaType = %ld",(long)PHAssetMediaTypeImage];
    PHFetchResult *fetchResult      =   [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                      options:fetchOptions];
    return fetchResult.count;
}

#pragma mark -
#pragma mark - Get photos from album
// Not allow download image from iCloud
// If there is no target size, pass a default size
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection {
    CGFloat screenScale                         =   [UIScreen mainScreen].scale;
    CGFloat sizeWidth                           =   ((ScreenWidth-25.0f)/4)*screenScale;
    CGFloat sizeHeight                          =   (sizeWidth*(16/10))*screenScale;
    CGSize  targetSize                          =   CGSizeMake(sizeWidth, sizeHeight);
    return [self loadPhotosFromAlbum:assetCollection targetSize:targetSize];
}

- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection
                      targetSize:(CGSize)targetSize {
    PHFetchOptions  *fetchOptions               =   [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors                =   @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchOptions.predicate                      =   [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    PHFetchResult *assetFetchResult             =   [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                                                  options:fetchOptions];
    __block NSMutableArray *tempPhotoMutArr     =   [[NSMutableArray alloc] initWithCapacity:assetFetchResult.count];
    //
    [assetFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            PHAsset *aAsset =   (PHAsset *)obj;
            IMPhoto *aPhoto =   [[IMPhoto alloc] initWithAsset:aAsset
                                                    targetSize:targetSize
                                                   contentMode:PHImageContentModeAspectFit];
            [tempPhotoMutArr addObject:aPhoto];
        }
    }];
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
