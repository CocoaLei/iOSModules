//
//  IMPhotoPreviewCollectionViewCell.h
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPhoto.h"

@interface IMPhotoPreviewCollectionViewCell : UICollectionViewCell

- (void)configurePhotoPreviewCVCWithPhoto:(id<IMPhotoProtocol>)photo;
- (void)resetContentViewScale;

@end
