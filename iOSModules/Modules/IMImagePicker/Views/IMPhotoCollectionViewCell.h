//
//  IMPhotoCollectionViewCell.h
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPhoto.h"

typedef void (^IMPhotoCVCDidSelectedBlock)(id <IMPhotoProtocol> photo, BOOL isSelected);

@interface IMPhotoCollectionViewCell : UICollectionViewCell

- (void)configurePhotoCVCWithPhoto:(id <IMPhotoProtocol> )photo
                  selectedHandler:(IMPhotoCVCDidSelectedBlock)selectedBlock;


@end
