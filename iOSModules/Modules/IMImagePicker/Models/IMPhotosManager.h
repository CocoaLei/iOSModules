//
//  IMPhotosManager.h
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

#define IMPhotoManagerInstance [IMPhotosManager sharedIMPhotosManger]

// key of return dictionary
#define ALBUM_TITLE             @"ALBUM_TITLE"
#define ALBUM_PHOTO_COUNT       @"ALBUM_PHOTO_COUNT"
#define ALBUM_COVER_IMAGE       @"ALBUM_COVER_IMAGE"
#define ALBUM_ASSET_COLLECZTION @"ALBUM_ASSET_COLLECTION"

@interface IMPhotosManager : NSObject

+ (IMPhotosManager *)sharedIMPhotosManger;

// size of request image
@property (nonatomic, assign)   CGSize photoRequestSize;

// Get photo album
- (NSArray *)loadAllPhotoAlbumsFromDevice;
- (NSArray *)loadMyPhotoAlbumsFromDevice;
- (NSArray *)loadSmartPhotoAlbumsFromDevice;

// Get photo from album
- (NSArray *)loadPhotosFromAlbum:(PHAssetCollection *)assetCollection withSize:(CGSize)imageSize;

@end
