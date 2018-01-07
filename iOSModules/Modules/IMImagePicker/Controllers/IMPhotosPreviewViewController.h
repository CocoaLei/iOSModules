//
//  IMPhotosPreviewViewController.h
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAlbum.h"

typedef NS_ENUM(NSInteger, IMPhotosPreviewType) {
    IMPhotosPreviewTypeSelectedPhotos   =   0,
    IMPhotosPreviewTypeAlbumPhotos      =   1
};

@interface IMPhotosPreviewViewController : UIViewController

@property (nonatomic, assign) IMPhotosPreviewType   previewType;
@property (nonatomic, strong) IMAlbum               *album;
@property (nonatomic, copy  ) NSArray               *selectedPhotosArray;

@end
