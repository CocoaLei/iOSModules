//
//  IMPhotoAlbumItemTableViewCell.h
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAlbum.h"

@interface IMPhotoAlbumItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoAlbumCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel     *photoAlbumBriefIntroLabel;

- (void)configurePhotoAlbum:(IMAlbum *)album;

@end
