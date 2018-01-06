//
//  IMPhotoCollectionViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoCollectionViewCell.h"

@interface IMPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIButton    *photoSelectedButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (nonnull, strong )    id <IMPhotoProtocol>        photo;
@property (nonatomic, copy )    IMPhotoCVCDidSelectedBlock  photoSelectedBlock;


@end

@implementation IMPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configurePhotoCVCWithPhoto:(id<IMPhotoProtocol>)photo selectedHandler:(IMPhotoCVCDidSelectedBlock)selectedBlock {
    self.photo                  =   photo;
    self.photoSelectedBlock     =   selectedBlock;
    self.photoImageView.image   =   self.photo.resultImage;
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePhotoLoadDidEndNotification:)
                                                 name:IMPHOTO_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
}

- (void)handlePhotoLoadDidEndNotification:(NSNotification *)notfication {
    id <IMPhotoProtocol> photo = [notfication object];
    if (photo == _photo) {
        if ([photo resultImage]) {
            self.photoImageView.image   =   photo.resultImage;
        } else {
            self.photoImageView.image   =   [UIImage imageNamed:@"im_image_placeholder"];
        }
    }
}

- (IBAction)photoSelectedButtonAction:(id)sender {
    self.photoSelectedButton.selected   =   !self.photoSelectedButton.selected;
    if (self.photoSelectedBlock) {
        self.photoSelectedBlock(self.photo, self.photoSelectedButton.selected);
    }
}


@end
