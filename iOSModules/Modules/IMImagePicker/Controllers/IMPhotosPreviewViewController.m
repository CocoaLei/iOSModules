//
//  IMPhotosPreviewViewController.m
//  iOSModules
//
//  Created by 石城磊 on 30/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotosPreviewViewController.h"
#import "IMPhotosManager.h"
#import "IMPhotoPreviewCollectionViewCell.h"

static NSString * const IMPhotoPreviewCVCID =   @"IMPhotoPreviewCVCID";

@interface IMPhotosPreviewViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic, assign)   BOOL                    isHideOtherUI;

@property (nonatomic, strong)  UICollectionView                                *photosCollectionView;
@property (nonatomic, strong)  NSMutableArray <id <IMPhotoProtocol>>           *photosMutArray;



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
    self.navigationController.navigationBar.hidden  =   YES;
    UIImage *backgroundImage    =   [UIImage createTranslucenceImageWithSize:CGSizeMake(ScreenWidth, 64.0f)
                                                                       alpha:0.0f
                                                                      colorR:255.0f
                                                                      colorG:255.0f
                                                                      colorB:255.0f];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]
                                                                      }];
    self.navigationItem.leftBarButtonItem  =   [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"im_arrow_left"]
                                                                                style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
    self.navigationController.navigationBar.translucent =   YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    self.isHideOtherUI          =   NO;
    //
    [self.photosCollectionView setFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.photosCollectionView];
}

- (void)initialPhotosData {
    switch (self.previewType) {
        case IMPhotosPreviewTypeAlbumPhotos:
        {
            NSArray *imageAssetsArray    =   [IMPhotoManagerInstance loadPhotosFromAlbum:self.album.albumCollection];
            if (imageAssetsArray.count > 0) {
                for (PHAsset *asset in imageAssetsArray) {
                    IMPhoto *photo  =   [[IMPhoto alloc] initWithAsset:asset
                                                            targetSize:CGSizeMake(ScreenWidth, ScreenHeight)
                                                           contentMode:PHImageContentModeAspectFit];
                    [self.photosMutArray addObject:photo];
                }
            }
        }
            break;
        case IMPhotosPreviewTypeSelectedPhotos:
        {
            if (self.selectedPhotosArray.count > 0) {
                [self.photosMutArray addObjectsFromArray:self.selectedPhotosArray];
            }
        }
            break;
        default:
            break;
    }
    [self.photosCollectionView setContentSize:CGSizeMake(ScreenWidth*self.photosMutArray.count, ScreenHeight)];
    [self.photosCollectionView reloadData];
}
- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *anyTouch   =   [touches anyObject];
    if (anyTouch.view == self.photosCollectionView) {
        
    }
}

#pragma mark -
#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosMutArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoPreviewCollectionViewCell *photoPreviceCVC   =   [collectionView dequeueReusableCellWithReuseIdentifier:IMPhotoPreviewCVCID forIndexPath:indexPath];
    [photoPreviceCVC configurePhotoPreviewCVCWithPhoto:self.photosMutArray[indexPath.row]];
    return photoPreviceCVC;
}

#pragma mark - UICollectionViewCellDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark -
#pragma mark - Initializations
- (UICollectionView *)photosCollectionView {
    if (!_photosCollectionView) {
        UICollectionViewFlowLayout  *flowLayout =   [[UICollectionViewFlowLayout alloc] init];
        CGSize  itemSize                        =   CGSizeMake(ScreenWidth, ScreenHeight);
        flowLayout.minimumLineSpacing           =   0.0f;
        flowLayout.minimumInteritemSpacing      =   0.0f;
        flowLayout.sectionInset                 =   UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        flowLayout.itemSize                     =   itemSize;
        flowLayout.scrollDirection              =   UICollectionViewScrollDirectionHorizontal;
        _photosCollectionView                   =   [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _photosCollectionView.backgroundColor   =   [UIColor clearColor];
        _photosCollectionView.pagingEnabled     =   YES;
        _photosCollectionView.delegate          =   self;
        _photosCollectionView.dataSource        =   self;
        [_photosCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IMPhotoPreviewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:IMPhotoPreviewCVCID];
    }
    return _photosCollectionView;
}

- (NSMutableArray<id<IMPhotoProtocol>> *)photosMutArray {
    if (!_photosMutArray) {
        _photosMutArray =   [[NSMutableArray alloc] init];
    }
    return _photosMutArray;
}

@end
