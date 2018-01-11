//
//  IMPhotoPreviewCollectionViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhotoPreviewCollectionViewCell.h"

@interface IMPhotoPreviewCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong)   UIScrollView    *photoContentView;
@property (nonatomic, strong)   UIImageView     *photoImageView;

@property (nonatomic, strong)   IMPhoto               *photo;

@end

@implementation IMPhotoPreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.photoContentView];
        [self.photoContentView addSubview:self.photoImageView];
    }
    return self;
}

- (void)resetContentViewScale {
    self.photoContentView.zoomScale =   1.0f;
}


//
- (void)configurePhotoPreviewCVCWithPhoto:(id<IMPhotoProtocol>)photo {
    self.photo                  =   photo;
    if (!self.photo.resultImage) {
        self.photoImageView.image   =   self.photo.resultImage;
    } else {
        [self.photo loadImageFromAsset];
    }
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePhotoLoadDidEndNotification:)
                                                 name:IMPHOTO_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
}

- (void)loadOriginalImage {
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

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}


#pragma mark - Initializations
- (UIScrollView *)photoContentView {
    if (!_photoContentView) {
        _photoContentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _photoContentView.showsHorizontalScrollIndicator    = NO;
        _photoContentView.showsVerticalScrollIndicator      = NO;
        _photoContentView.bouncesZoom                       = YES;
        _photoContentView.minimumZoomScale                  = 1.0f;
        _photoContentView.maximumZoomScale                  = 4.0f;
        _photoContentView.multipleTouchEnabled              = YES;
        _photoContentView.delegate                          = self;
        _photoContentView.scrollsToTop                      = NO;
        _photoContentView.showsHorizontalScrollIndicator    = NO;
        _photoContentView.showsVerticalScrollIndicator      = NO;
        _photoContentView.autoresizingMask                  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _photoContentView.delaysContentTouches              = NO;
        _photoContentView.canCancelContentTouches           = YES;
        _photoContentView.alwaysBounceVertical              = NO;
    }
    return _photoContentView;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView                     =   [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode         =   UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}

@end
