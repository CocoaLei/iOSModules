//
//  IMPhotoSelectBottomBarView.m
//  iOSModules
//
//  Created by 石城磊 on 25/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMPhotoSelectBottomBarView.h"
#import "UIView+AddRoundBorder.h"

@interface IMPhotoSelectBottomBarView ()

@property (weak, nonatomic) IBOutlet UIButton       *photoEditButton;
@property (weak, nonatomic) IBOutlet UIButton       *photoSelectCompleteButton;
@property (weak, nonatomic) IBOutlet UILabel        *photoSelectCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView   *photoSelectedContainerScrollView;

@end

@implementation IMPhotoSelectBottomBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self =  [[NSBundle mainBundle]
                 loadNibNamed:NSStringFromClass([self class])
                 owner:self
                 options:nil][0];
        [self barViewInitializationConfiguration];
    }
    return self;
}

- (void)barViewInitializationConfiguration {
    [self.photoEditButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
    [self.photoSelectCompleteButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
}

@end
