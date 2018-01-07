//
//  IMPhotosManager.h
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void (^ImageRequestFinished)(NSDictionary *imageInfo, UIImage *resulImage);

#define IMPhotoManagerInstance [IMPhotosManager sharedIMPhotosManger]

// key of return dictionary
#define IM_ALBUM_TITLE             @"IM_ALBUM_TITLE"
#define IM_ALBUM_PHOTO_COUNT       @"IM_ALBUM_PHOTO_COUNT"
#define IM_ALBUM_COVER_IMAGE       @"IM_ALBUM_COVER_IMAGE"
#define IM_ALBUM_ASSET_COLLECZTION @"IM_ALBUM_ASSET_COLLECTION"

@interface IMPhotosManager : NSObject

+ (IMPhotosManager *)sharedIMPhotosManger;

// size of request image
@property (nonatomic, assign)   CGSize photoRequestSize;

// Get photo album
- (NSArray *)loadAllPhotoAlbumsFromDevice;
- (NSArray *)loadMyPhotoAlbumsFromDevice;
- (NSArray *)loadSmartPhotoAlbumsFromDevice;

// Get photo asset from album
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection;
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection
                      targetSize:(CGSize)targetSize;

// Get photo by asset
- (UIImage *)requestPreviewImageFromAsset:(PHAsset *)asset
                          withSize:(CGSize)imageSize
                              contentMode:(PHImageContentMode)imageContentMode;
- (UIImage *)requestOriginalImageFromAsset:(PHAsset *)asset;

- (void )requestPreviewImageFromAsset:(PHAsset *)asset
                                 withSize:(CGSize)imageSize
                              contentMode:(PHImageContentMode)imageContentMode
                          requestFinished:(ImageRequestFinished)requestFinised;

@end
