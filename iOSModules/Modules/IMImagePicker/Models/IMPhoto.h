//
//  IMPhoto.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/5.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "IMPhotoProtocol.h"

@interface IMPhoto : NSObject   <IMPhotoProtocol>

@property   (nonatomic, assign) NSInteger photoIndex;

+ (IMPhoto *)photoWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
                contentMode:(PHImageContentMode)contentMode;
- (instancetype)initWithAsset:(PHAsset *)asset
                   targetSize:(CGSize)targetSize
                  contentMode:(PHImageContentMode)contentMode;

@end
