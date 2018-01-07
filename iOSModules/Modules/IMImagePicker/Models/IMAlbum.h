//
//  IMAlbum.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMPhoto.h"

@interface IMAlbum : NSObject

@property (nonatomic, copy  ) NSString          *albumTitle;
@property (nonatomic, assign) NSNumber          *albumPhotoCount;
@property (nonatomic, strong) IMPhoto           *albumCoverPhoto;
@property (nonatomic, strong) PHAssetCollection *albumCollection;

+ (IMAlbum *)imalbumModelWithTitle:(NSString *)albumTitle
                        photoCount:(NSUInteger)photoCount
                        albumCover:(id <IMPhotoProtocol> )coverPhoto
                   albumCollection:(PHAssetCollection *)albumCollection;

- (instancetype)initAlbumModelWithTitle:(NSString *)albumTitle
                             photoCount:(NSUInteger)photoCount
                             albumCover:(id <IMPhotoProtocol> )coverPhoto
                        albumCollection:(PHAssetCollection *)albumCollection;

@end
