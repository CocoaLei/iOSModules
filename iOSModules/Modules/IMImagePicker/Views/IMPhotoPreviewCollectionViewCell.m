//
//  IMPhotoPreviewCollectionViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/7.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhotoPreviewCollectionViewCell.h"
#import "UIImage+FileSize.h"
#import "IMRingProgressView.h"


@interface IMPhotoPreviewCollectionViewCell ()
<
    UIScrollViewDelegate,
    UIGestureRecognizerDelegate
>

@property (nonatomic, strong)   IMRingProgressView  *loadingProgressView;
@property (nonatomic, strong)   UIScrollView        *photoContentView;
@property (nonatomic, strong)   UIImageView         *photoImageView;

@property (nonatomic, strong)   IMPhoto         *photo;

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
    [self.loadingProgressView removeFromSuperview];
    [self.loadingProgressView setProgress:0.0f animated:YES];
    [self.loadingProgressView performAction:IMProgressViewActionTypeNone animated:YES];
}

//
- (void)configurePhotoPreviewCVCWithPhoto:(id<IMPhotoProtocol>)photo {
    [self resetContentViewScale];
    
    //
    self.photo                  =   photo;
    if (!self.photo.originalImage) {
        if (self.photo.resultImage) {
            self.photoImageView.image   =   self.photo.resultImage;
        } else {
            [self.photo loadOriginalImageFromAsset];
        }
        [self.photoContentView addSubview:self.loadingProgressView];
    } else {
        self.photoImageView.image   =   self.photo.originalImage;
    }
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleResultImageDidLoadNotification:)
                                                 name:IMPHOTO_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handPhotoLoadingNotification:)
                                                 name:ORIGINAL_INPROGRESS_NOTIFICATION
                                               object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePhotoLoadDidEndNotification:)
                                                 name:ORIGINAL_LOADING_FINISHED_NOTIFICATION
                                               object:nil];
    
}

- (void)handleResultImageDidLoadNotification:(NSNotification *)notification {
    IMPhoto *photo  =   (IMPhoto *)[notification object];
    if (self.photo == photo) {
        self.photoImageView.image   =   photo.resultImage;
        self.photo                  =   photo;
    }
}

- (void)handPhotoLoadingNotification:(NSNotification *)notification {
    NSDictionary *pregressDict  =   [notification object];
    CGFloat loadProgress        =   [[pregressDict objectForKey:IMPHOTO_LOADING_PROGRESS_KEY] floatValue];
    IMPhoto *postPhoto          =   (IMPhoto *)[pregressDict objectForKey:IMPHOTO_LOADING_PHOTOT_KEY];
    if (self.photo == postPhoto) {
        if (loadProgress == 1.0f) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loadingProgressView performAction:IMProgressViewActionTypeSuccess animated:YES];
                dispatch_time_t delayTime   =   dispatch_time(DISPATCH_TIME_NOW, 0.75*NSEC_PER_SEC);
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.loadingProgressView removeFromSuperview];
                });
            });
        } else {
         [self.loadingProgressView setProgress:loadProgress animated:YES];
        }
    }
}

- (void)handlePhotoLoadDidEndNotification:(NSNotification *)notfication {
    PHAsset *photoAsset = [notfication object];
    if (photoAsset == self.photo.photoAsset) {
        if ([self.photo originalImage]) {
            self.photoImageView.image   =   self.photo.originalImage;
        } else {
            self.photoImageView.image   =   [UIImage imageNamed:@"im_image_placeholder"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingProgressView performAction:IMProgressViewActionTypeSuccess animated:YES];
            dispatch_time_t delayTime   =   dispatch_time(DISPATCH_TIME_NOW, 0.75*NSEC_PER_SEC);
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.loadingProgressView removeFromSuperview];
            });
        });
    }
    
}

- (void)singleTapGestureAction {
    if (self.photoViewTapHandler) {
        self.photoViewTapHandler();
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    IMDebugLog(@"A gesture recognizer happened %@",[gestureRecognizer class]);
    return YES;
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
        [_photoContentView setBackgroundColor:[UIColor blackColor]];
        
        UITapGestureRecognizer *singleTap                   =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction)];
        singleTap.numberOfTapsRequired                      =   1;
        singleTap.numberOfTouchesRequired                   =   1;
        [_photoContentView addGestureRecognizer:singleTap];
    }
    return _photoContentView;
}

- (IMRingProgressView *)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView    =   [[IMRingProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds)-40.0f, CGRectGetMidY(self.bounds)-40.0f, 80.0f, 80.0f)];
        [_loadingProgressView performAction:IMProgressViewActionTypeNone animated:YES];
    }
    return _loadingProgressView;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView                     =   [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode         =   UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}

@end
