//
//  IMPhotoCollectionViewCell.h
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IM_PHOTO_IMAGE         @"IM_PHOTO_IMAGE"
#define IM_PHOTO_IS_SELECTED   @"IM_PHOTO_IS_SELECTED"
#define IM_PHOTO_SELECT_NO     @"IM_PHOTO_SELECT_NO"
#define IM_PHOTO_ALBUM_NO      @"IM_PHOTO_ALBUM_NO"
#define IM_PHOTO_ASSET         @"IM_PHOTO_ASSET_ID"

typedef void (^IMPhotoCVCDidSelectedBlock)(NSDictionary *photoDict, BOOL isSelected);

@interface IMPhotoCollectionViewCell : UICollectionViewCell

- (void)configurePhotoCVCWithDict:(NSDictionary *)photoDict
                  selectedHandler:(IMPhotoCVCDidSelectedBlock)selectedBlock;


@end
