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

@property (nonatomic, copy )    IMPhotoCVCDidSelectedBlock  photoSelectedBlock;
@property (nonatomic, copy )    NSDictionary                *photoDict;

@end

@implementation IMPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configurePhotoCVCWithDict:(NSDictionary *)photoDict
                  selectedHandler:(IMPhotoCVCDidSelectedBlock)selectedBlock {
    self.photoDict          =   photoDict;
    self.photoSelectedBlock =   selectedBlock;
    [self.photoImageView setImage:photoDict[IM_PHOTO_IMAGE]];
}

- (IBAction)photoSelectedButtonAction:(id)sender {
    self.photoSelectedButton.selected   =   !self.photoSelectedButton.selected;
    if (self.photoSelectedBlock) {
        self.photoSelectedBlock(self.photoDict, self.photoSelectedButton.selected);
    }
}


@end
