//
//  IMPhotosManager.m
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotosManager.h"


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
    return [tempAlbumsMutArray copy];
}

- (NSArray *)loadMyPhotoAlbumsFromDevice {
    return [self loadPhotoAlbumFromDeviceWithType:PHAssetCollectionTypeAlbum];
}

- (NSArray *)loadSmartPhotoAlbumsFromDevice {
    return [self loadPhotoAlbumFromDeviceWithType:PHAssetCollectionTypeSmartAlbum];
}

- (NSArray *)loadPhotoAlbumFromDeviceWithType:(PHAssetCollectionType)albumType {
    PHFetchResult *albumsFetchResult   =   [PHAssetCollection fetchAssetCollectionsWithType:albumType
                                                                                    subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                    options:nil];
    NSMutableArray *tempAlbumsMutArr   =   [[NSMutableArray alloc] initWithCapacity:albumsFetchResult.count];
    for (PHAssetCollection *assetCollection in albumsFetchResult) {
        NSString *albumTitle               =   assetCollection.localizedTitle;
        PHFetchResult *assetFetchResult     =   [PHAsset fetchAssetsInAssetCollection:assetCollection
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
- (UIImage *)requestPreviewImageFromAsset:(PHAsset *)asset withSize:(CGSize)imageSize contentMode:(PHImageContentMode)imageContentMode {
    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.deliveryMode                =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
    opt.resizeMode                  =   PHImageRequestOptionsResizeModeExact;
    opt.synchronous                 =   YES;
    __block UIImage *resultImage    =   [[UIImage alloc] init];
    [[PHImageManager defaultManager]  requestImageForAsset:asset
                                      targetSize:imageSize
                                      contentMode:imageContentMode
                                      options:opt
                                      resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                          if (result) {
                                              resultImage =  result;
                                          } else {
                                              resultImage   =   [UIImage imageNamed:@"im_image_placeholder"];
                                          }
     }];
    return  resultImage;
}

#pragma mark - Get original photo with asset
- (UIImage *)requestOriginalImageFromAsset:(PHAsset *)asset {
    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.deliveryMode                =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
    opt.synchronous                 =   YES;
    __block UIImage *resultImage    =   [[UIImage alloc] init];
    [[PHImageManager defaultManager]  requestImageForAsset:asset
                                                targetSize:PHImageManagerMaximumSize
                                               contentMode:PHImageContentModeDefault
                                                   options:opt
                                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                 if (result) {
                                                     resultImage =  result;
                                                 } else {
                                                     resultImage   =   [UIImage imageNamed:@"im_image_placeholder"];
                                                 }
                                             }];
    return  resultImage;
}

@end
