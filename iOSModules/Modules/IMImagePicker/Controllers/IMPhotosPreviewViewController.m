//
//  IMPhotosPreviewViewController.m
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotosPreviewViewController.h"
#import "IMPhotosManager.h"

@interface IMPhotosPreviewViewController ()

@property (nonatomic, copy  )   NSArray                 *albumAssetsArray;
@property (nonatomic, strong)   NSMutableArray          *albumPhotosArray;
@property (nonatomic, strong)   UIScrollView            *photosScrollView;
@property (nonatomic, assign)   BOOL                    isHideOtherUI;
@property (nonatomic, assign)   NSInteger               currentShowPhotoIndex;
@property (nonatomic, assign)   NSInteger               maxLoadPhotoNum;


@end

@implementation IMPhotosPreviewViewController

#pragma mark -
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewApperance];
    [self initialPhotosData];
}

#pragma mark -
#pragma mark - Private methods
- (void)configureViewApperance {
    //
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]
                                                                      }];
    self.navigationItem.leftBarButtonItem  =   [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"im_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    self.isHideOtherUI          =   NO;
    self.currentShowPhotoIndex  =   0;
    self.maxLoadPhotoNum        =   20;
    //
}

- (void)initialPhotosData {
    NSInteger   photosCount = [self.albumDetialDict[IM_ALBUM_PHOTO_COUNT] integerValue];
    [self.photosScrollView setContentSize:CGSizeMake(ScreenWidth*photosCount, ScreenHeight)];
    [self.view addSubview:self.photosScrollView];
    //
    PHAssetCollection *albumAssetCollection =   self.albumDetialDict[IM_ALBUM_ASSET_COLLECZTION];
    self.albumAssetsArray                   =   [NSArray arrayWithArray:[IMPhotoManagerInstance loadPhotosFromAlbum:albumAssetCollection]];
    [self loadPhotoFromCurrentPhotoIndex];
    [self addPhotoImageViewToScrollView];
}

- (void)loadPhotoFromCurrentPhotoIndex {
    if (self.currentShowPhotoIndex == 0) {
        for (NSInteger index = 0; index < self.albumAssetsArray.count; index++) {
            if (index < self.albumAssetsArray.count) {
                PHAsset *photoAsset =   self.albumAssetsArray[index];
                UIImage *image      =   [IMPhotoManagerInstance requestOriginalImageFromAsset:photoAsset];
                [self.albumPhotosArray insertObject:image atIndex:self.albumPhotosArray.count];
            }
        }
    }
}

- (void)addPhotoImageViewToScrollView {
    for (NSInteger index = 0; index < self.albumPhotosArray.count; index++) {
        UIView *containerView   =   [[UIView alloc] initWithFrame:CGRectMake(index*ScreenWidth, 0.0f, ScreenWidth, ScreenHeight)];
        UIImageView *imageView  =   [[UIImageView alloc] initWithFrame:containerView.bounds];
        imageView.contentMode   =   UIViewContentModeScaleAspectFit;
        [imageView setImage:self.albumPhotosArray[index]];
        [containerView addSubview:imageView];
        [self.photosScrollView addSubview:containerView];
    }
}

- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch   =   [touches anyObject];
    if (anyTouch.view == self.view) {
        if (!self.isHideOtherUI) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect navigationBarRect  =   self.navigationController.navigationBar.frame;
                self.navigationController.navigationBar.frame   =   CGRectMake(navigationBarRect.origin.x, navigationBarRect.origin.y-64.0f, navigationBarRect.size.width, navigationBarRect.size.height);
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect navigationBarRect  =   self.navigationController.navigationBar.frame;
                self.navigationController.navigationBar.frame   =   CGRectMake(navigationBarRect.origin.x, navigationBarRect.origin.y+64.0f, navigationBarRect.size.width, navigationBarRect.size.height);
            }];
        }
        self.isHideOtherUI  =   !self.isHideOtherUI;
    }
}

#pragma mark -
#pragma mark - Initializations
- (UIScrollView *)photosScrollView {
    if (!_photosScrollView) {
        _photosScrollView   =   [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
        _photosScrollView.showsVerticalScrollIndicator      =   NO;
        _photosScrollView.showsHorizontalScrollIndicator    =   NO;
        _photosScrollView.pagingEnabled                     =   YES;
        _photosScrollView.bounces                           =   NO;
    }
    return _photosScrollView;
}

- (NSArray *)albumAssetsArray {
    if (!_albumAssetsArray) {
        _albumAssetsArray   =   [[NSArray alloc] init];
    }
    return _albumAssetsArray;
}

- (NSMutableArray *)albumPhotosArray {
    if (!_albumPhotosArray) {
        _albumPhotosArray   =   [[NSMutableArray alloc] init];
    }
    return _albumPhotosArray;
}

@end
