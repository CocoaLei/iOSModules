//
//  IMModuleItemTableViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 23/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMModuleItemTableViewCell.h"
#import "IMModuleItemModel.h"
#import "UIImage+RoundCorner.h"

@interface IMModuleItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imModuleItemImageView;
@property (weak, nonatomic) IBOutlet UILabel     *imModuleItemNameLabel;


@end

@implementation IMModuleItemTableViewCell

- (void)setModel:(IMModuleItemModel *)model {
    _model                          =   model;
    _imModuleItemNameLabel.text     =   model.ModuleName;
    _imModuleItemImageView.image    =   [[UIImage imageNamed:model.ModuleImagePath]
                                         im_addRoundCornerWithRadius:_imModuleItemImageView.bounds.size.width/2
                                         andSize:_imModuleItemImageView.bounds.size];
}

@end
