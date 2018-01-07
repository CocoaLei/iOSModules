//
//  IMPhotoAlbumItemTableViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoAlbumItemTableViewCell.h"

@interface IMPhotoAlbumItemTableViewCell ()

@property (nonatomic, strong)   IMAlbum *albumModel;

@end

@implementation IMPhotoAlbumItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configurePhotoAlbum:(IMAlbum *)album {
    self.albumModel =   album;
    self.photoAlbumCoverImageView.image =   album.albumCoverPhoto.resultImage;
    self.photoAlbumBriefIntroLabel.text =   [NSString stringWithFormat:@"%@ (%li)",album.albumTitle,[album.albumPhotoCount integerValue]];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePhotoLoadDidEndNotification:)
                                                 name:IMPHOTO_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
}

- (void)handlePhotoLoadDidEndNotification:(NSNotification *)notfication {
    id <IMPhotoProtocol> photo = [notfication object];
    if (photo == self.albumModel.albumCoverPhoto) {
        if ([photo resultImage]) {
            self.photoAlbumCoverImageView.image   =   photo.resultImage;
        } else {
            self.photoAlbumCoverImageView.image   =   [UIImage imageNamed:@"im_album_placeholder"];
        }
    }
}

@end
