//
//  IMPhotoPreviewCollectionViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhotoPreviewCollectionViewCell.h"

@interface IMPhotoPreviewCollectionViewCell ()

@property (weak, nonatomic  ) IBOutlet  UIImageView *photoImageView;
@property (nonatomic, strong) IMPhoto               *photo;

@end

@implementation IMPhotoPreviewCollectionViewCell

- (void)configurePhotoPreviewCVCWithPhoto:(id<IMPhotoProtocol>)photo {
    self.photo                  =   photo;
    self.photoImageView.image   =   self.photo.resultImage;
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePhotoLoadDidEndNotification:)
                                                 name:IMPHOTO_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
}

- (void)handlePhotoLoadDidEndNotification:(NSNotification *)notfication {
    id <IMPhotoProtocol> photo = [notfication object];
    if (photo == self.photo) {
        if ([photo resultImage]) {
            self.photoImageView.image   =   photo.resultImage;
        } else {
            self.photoImageView.image   =   [UIImage imageNamed:@"im_image_placeholder"];
        }
    }
}

@end
