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
            self.photoRequestSize   =   CGSizeMake(60.0f, 60.0f);
        }
        UIImage *albumCoverImage            =   [self requestImageFromAsset:[assetFetchResult firstObject] withSize:self.photoRequestSize];
        NSDictionary *albumDetailDict       =   @{ALBUM_TITLE               :   albumTitle,
                                                  ALBUM_PHOTO_COUNT         :   @(assetCount),
                                                  ALBUM_COVER_IMAGE         :   albumCoverImage,
                                                  ALBUM_ASSET_COLLECZTION   :   assetCollection
                                                  };
        [tempAlbumsMutArr addObject:albumDetailDict];
    }
    return [tempAlbumsMutArr copy];
}

#pragma mark -
#pragma mark - Get photos from album
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection
                        withSize:(CGSize)imageSize {
    PHFetchResult *assetFetchResult     =   [PHAsset fetchAssetsInAssetCollection:assetCollection
                                                               options:nil];
    NSMutableArray *tempPhotoMutArr     =   [[NSMutableArray alloc] initWithCapacity:assetFetchResult.count];
    for (PHAsset *asset in assetFetchResult) {
        [tempPhotoMutArr addObject:[self requestImageFromAsset:asset withSize:imageSize]];
    }
    return [tempPhotoMutArr copy];
}

#pragma mark -
#pragma mark - Private methods
- (UIImage *)requestImageFromAsset:(PHAsset *)asset withSize:(CGSize)imageSize {
    PHImageRequestOptions *opt      =   [[PHImageRequestOptions alloc] init];
    opt.resizeMode                  =   PHImageRequestOptionsResizeModeExact;
    PHImageManager *imageManager    =   [[PHImageManager alloc] init];
    __block UIImage *resultImage    =   [UIImage imageNamed:@"im_image_placeholder"];
    [imageManager requestImageForAsset:asset
                            targetSize:imageSize
                           contentMode:PHImageContentModeAspectFit
                               options:opt
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                   if (result) {
                                       resultImage  =   result;
                                   }
    }];
    return resultImage;
}

@end
