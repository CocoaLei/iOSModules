//
//  IMPhotoAlbumsViewController.m
//  iOSModules
//
//  Created by 石城磊 on 29/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoAlbumsViewController.h"
#import "IMPhotoAlbumItemTableViewCell.h"
#import "IMPhotosManager.h"
#import "IMPhotoBrowseViewController.h"
#import "IMAlbum.h"

static  NSString * const IMPhotoAlbumTVCID  =   @"IMPhotoAlbumTVCID";

@interface IMPhotoAlbumsViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong)   UITableView *photoAlbumsTableView;
@property (nonatomic, strong)   NSArray     *photoAlbumsArray;

@end

@implementation IMPhotoAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewApperance];
    //
}

#pragma mark -
#pragma mark - Private methods
- (void)configureViewApperance {
    self.title  =   @"Photo";
    UIImage *backgroundImage    =   [UIImage createTranslucenceImageWithSize:CGSizeMake(ScreenWidth, 64.0f)
                                                                       alpha:0.5
                                                                      colorR:255.0f
                                                                      colorG:255.0f
                                                                      colorB:255.0f];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]
                                                                      }];
    self.navigationItem.rightBarButtonItem  =   [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"im_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissPhotoAlbumViewController)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    [self.photoAlbumsTableView setFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.photoAlbumsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMPhotoAlbumItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:IMPhotoAlbumTVCID];
    [self.view addSubview:self.photoAlbumsTableView];
}

- (void)dismissPhotoAlbumViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoAlbumItemTableViewCell *photoAlbumTVC    =   [tableView dequeueReusableCellWithIdentifier:IMPhotoAlbumTVCID];
    [photoAlbumTVC configurePhotoAlbum:self.photoAlbumsArray[indexPath.row]];
    return photoAlbumTVC;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IMPhotoBrowseViewController *photoBrowseViewController  =   [[IMPhotoBrowseViewController alloc] init];
    photoBrowseViewController.album                         =   self.photoAlbumsArray[indexPath.row];
    [self.navigationController pushViewController:photoBrowseViewController animated:YES];
}



#pragma mark -
#pragma mark - Initializations
- (UITableView *)photoAlbumsTableView {
    if (!_photoAlbumsTableView) {
        _photoAlbumsTableView   =   [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_photoAlbumsTableView setDataSource:self];
        [_photoAlbumsTableView setDelegate:self];
        [_photoAlbumsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _photoAlbumsTableView;
}

- (NSArray *)photoAlbumsArray {
    if (!_photoAlbumsArray) {
        NSArray *albumsArray    =    [IMPhotoManagerInstance loadAllPhotoAlbumsFromDevice];
        _photoAlbumsArray       =    [NSArray arrayWithArray:albumsArray];
    }
    return _photoAlbumsArray;
}

@end
