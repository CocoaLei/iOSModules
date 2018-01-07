//
//  IMAlbum.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMAlbum.h"

@implementation IMAlbum

+ (IMAlbum *)imalbumModelWithTitle:(NSString *)albumTitle
                        photoCount:(NSUInteger)photoCount
                        albumCover:(id <IMPhotoProtocol> )coverPhoto
                   albumCollection:(PHAssetCollection *)albumCollection {
    return [[IMAlbum alloc] initAlbumModelWithTitle:albumTitle photoCount:photoCount albumCover:coverPhoto albumCollection:albumCollection];
}

- (instancetype)initAlbumModelWithTitle:(NSString *)albumTitle
                             photoCount:(NSUInteger)photoCount
                             albumCover:(id <IMPhotoProtocol> )coverPhoto
                      albumCollection:(PHAssetCollection *)albumCollection {
    if (self = [super init]) {
        self.albumTitle         =   albumTitle;
        self.albumPhotoCount    =   @(photoCount);
        self.albumCoverPhoto    =   coverPhoto;
        self.albumCollection    =   albumCollection;
    }
    return self;
}


@end
