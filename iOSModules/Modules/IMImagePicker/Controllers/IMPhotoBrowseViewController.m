//
//  IMPhotoBrowseViewController.m
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoBrowseViewController.h"
#import <Photos/Photos.h>
#import "IMPhotosManager.h"
#import "IMPhotoCollectionViewCell.h"
#import "UIView+AddRoundBorder.h"
#import "IMPhotosPreviewViewController.h"

#import "IMPhoto.h"

static NSString * const IMPhotoCVCID    =   @"IMPhotoCVCID";

@interface IMPhotoBrowseViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, strong)   UICollectionView    *photoBrowseCollectionView;
@property (nonatomic, copy  )   NSArray             *photoArray;
@property (nonatomic, strong)   NSMutableArray      *selectedPhotosArray;
@property (nonatomic, strong)   UIView              *bottomToolBarView;
@property (nonatomic, strong)   UIButton            *previewPhotosButton;
@property (nonatomic, strong)   UILabel             *selectedPhotoCountLabel;
@property (nonatomic, strong)   UIButton            *completeSelectButton;

@end

@implementation IMPhotoBrowseViewController

#pragma mark -
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewApperance];
}

#pragma mark -
#pragma mark - Private methods
- (void)configureViewApperance {
    self.title  =   self.album.albumTitle;
    //
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]
                                                                      }];
    self.navigationItem.leftBarButtonItem  =   [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"im_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    [self.view addSubview:self.photoBrowseCollectionView];
    //
    [self.view addSubview:self.bottomToolBarView];
    [self.previewPhotosButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
    [self.completeSelectButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
}

- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//
- (void)deselectePhoto:(NSDictionary *)photoDict {
    NSIndexPath *deselecIndexPath   =   photoDict[@"IndexPath"];
    for (NSDictionary *selectedPhotoDict in [self.selectedPhotosArray copy]) {
        NSIndexPath *selectedIndexPath  =   selectedPhotoDict[@"IndexPath"];
        if (deselecIndexPath.row == selectedIndexPath.row) {
            [self.selectedPhotosArray removeObject:selectedPhotoDict];
            [self refreshSelectedPhotoCountLabel];
        }
    }
}

//
- (void)selectedPhoto:(NSDictionary *)photoDict {
    [self.selectedPhotosArray insertObject:photoDict atIndex:self.selectedPhotosArray.count];
    [self refreshSelectedPhotoCountLabel];
}

//
- (void)refreshSelectedPhotoCountLabel {
    if (self.selectedPhotosArray.count == 0) {
        self.selectedPhotoCountLabel.text   =   @"";
    } else {
        self.selectedPhotoCountLabel.text   =   [NSString stringWithFormat:@"已选择 %li 张图片",self.selectedPhotosArray.count];
    }
}

//
- (void)previewPhotosButtonAction {
    IMPhotosPreviewViewController *photosPreviewVC  =   [[IMPhotosPreviewViewController alloc] init];
    photosPreviewVC.previewType                     =   IMPhotosPreviewTypeAlbumPhotos;
    photosPreviewVC.album                           =   self.album;
    [self.navigationController pushViewController:photosPreviewVC animated:YES];
}

#pragma mark -
#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoCollectionViewCell *photoCVC  =   [collectionView dequeueReusableCellWithReuseIdentifier:IMPhotoCVCID forIndexPath:indexPath];
    IMPhoto *photo                       =   self.photoArray[indexPath.row];
    if (!photo.resultImage) {
        [photo loadImageFromAsset];
    }
    [photoCVC configurePhotoCVCWithPhoto:photo selectedHandler:^(id<IMPhotoProtocol> photo, BOOL isSelected) {
        NSDictionary *handlePhotoDict   =   @{@"IndexPath"  :   indexPath,
                                              @"PhotoDict"  :   photo
                                              };
        if (!isSelected) {
            [self deselectePhoto:handlePhotoDict];
        } else {
            [self selectedPhoto:handlePhotoDict];
        }
    }];
    return photoCVC;
}

#pragma mark - UICollectionViewDelegate

#pragma mark -
#pragma mark - Initializations
- (UICollectionView *)photoBrowseCollectionView {
    if (!_photoBrowseCollectionView) {
        UICollectionViewFlowLayout  *flowLayout =   [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth                       =   (ScreenWidth-25.0f)/4;
        CGFloat itemHeight                      =   itemWidth*(16/10);
        CGSize  itemSize                        =   CGSizeMake(itemWidth, itemHeight);
        flowLayout.itemSize                     =   itemSize;
        flowLayout.minimumLineSpacing           =   5.0f;
        flowLayout.minimumInteritemSpacing      =   5.0f;
        flowLayout.sectionInset                 =   UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        flowLayout.scrollDirection              =   UICollectionViewScrollDirectionVertical;
        _photoBrowseCollectionView              =   [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _photoBrowseCollectionView.backgroundColor  =   [UIColor whiteColor];
        _photoBrowseCollectionView.delegate     =   self;
        _photoBrowseCollectionView.dataSource   =   self;
        
        UINib *imPhotoCVCNib                    =   [UINib nibWithNibName:NSStringFromClass([IMPhotoCollectionViewCell class]) bundle:nil];
        [_photoBrowseCollectionView registerNib:imPhotoCVCNib forCellWithReuseIdentifier:IMPhotoCVCID];
        [_photoBrowseCollectionView setFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight-46.0f)];
        [_photoBrowseCollectionView setContentSize:CGSizeMake(ScreenWidth, 10*itemHeight+11*5.0f)];
    }
    return _photoBrowseCollectionView;
}

- (UIView *)bottomToolBarView {
    if (!_bottomToolBarView) {
        _bottomToolBarView  =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.bounds)-46.0f, ScreenWidth, 46.0f)];
        [_bottomToolBarView setBackgroundColor:[UIColor whiteColor]];
        [_bottomToolBarView addSubview:self.previewPhotosButton];
        [_bottomToolBarView addSubview:self.selectedPhotoCountLabel];
        [_bottomToolBarView addSubview:self.completeSelectButton];
    }
    return _bottomToolBarView;
}

- (UIButton *)previewPhotosButton {
    if (!_previewPhotosButton) {
        _previewPhotosButton    =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_previewPhotosButton setFrame:CGRectMake(8.0f, 8.0f, 60.0f, 30.0f)];
        [_previewPhotosButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_previewPhotosButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewPhotosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewPhotosButton addTarget:self action:@selector(previewPhotosButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_previewPhotosButton setBackgroundColor:RGBACOLOR(255.0f, 255.0f, 255.0f, 0.5)];
    }
    return _previewPhotosButton;
}

- (UILabel *)selectedPhotoCountLabel {
    if (!_selectedPhotoCountLabel) {
        _selectedPhotoCountLabel                =   [[UILabel alloc] initWithFrame:CGRectMake(76.0f, 8.0f, ScreenWidth-60*2-8*4, 30.0f)];
        _selectedPhotoCountLabel.font           =   [UIFont systemFontOfSize:14.0f];
        _selectedPhotoCountLabel.textAlignment  =   NSTextAlignmentCenter;
        [_selectedPhotoCountLabel setTextColor:[UIColor blackColor]];
    }
    return _selectedPhotoCountLabel;
}

- (UIButton *)completeSelectButton {
    if (!_completeSelectButton) {
        _completeSelectButton    =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_completeSelectButton setFrame:CGRectMake(ScreenWidth-68.0f, 8.0f, 60.0f, 30.0f)];
        [_completeSelectButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_completeSelectButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _completeSelectButton;
}

- (NSArray *)photoArray {
    if (!_photoArray) {
        PHAssetCollection *assetCollection  =   self.album.albumCollection;
        NSArray *photosInAlbumArr           =   [IMPhotoManagerInstance loadPhotosFromAlbum:assetCollection];
        NSMutableArray *tempPhotosMutArr    =   [NSMutableArray arrayWithCapacity:photosInAlbumArr.count];
        CGFloat screenScale                 =   [UIScreen mainScreen].scale;
        CGFloat sizeWidth                   =   ((ScreenWidth-25.0f)/4)*screenScale;
        CGFloat sizeHeight                  =   (sizeWidth*(16/10))*screenScale;
        for (PHAsset *photoAsset in photosInAlbumArr) {
            @autoreleasepool {
                IMPhoto *photo   =   [[IMPhoto alloc] initWithAsset:photoAsset targetSize:CGSizeMake(sizeWidth, sizeHeight) contentMode:PHImageContentModeAspectFit];
                [tempPhotosMutArr addObject:photo];
            }
        }
        _photoArray =   [[NSArray alloc] initWithArray:[tempPhotosMutArr copy]];
    }
    return _photoArray;
}

- (NSMutableArray *)selectedPhotosArray {
    if (!_selectedPhotosArray) {
        _selectedPhotosArray    =   [[NSMutableArray alloc] init];
    }
    return _selectedPhotosArray;
}

@end
