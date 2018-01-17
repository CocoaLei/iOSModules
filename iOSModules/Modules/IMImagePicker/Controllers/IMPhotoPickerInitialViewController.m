//
//  IMPhotoPickerInitialViewController.m
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoPickerInitialViewController.h"
#import "UIView+AddRoundBorder.h"
#import "IMPhotosManager.h"
#import <Photos/Photos.h>
#import "IMPhotoAlbumsViewController.h"

#import "IMProgressView.h"

@interface IMPhotoPickerInitialViewController ()

@property (nonatomic, strong)   IMProgressView  *progressView;

@end

@implementation IMPhotoPickerInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMPhotoPicker";
    [self configureViewsApperance];
}

- (void)configureViewsApperance {
    
   self.progressView = [IMProgressView progressViewWithFrame:CGRectMake(ScreenWidth/2-40.0f, ScreenHeight/2-40.0f, 80.0f, 80.0f)
                              borderColor:[UIColor clearColor]
                              borderWidth:1.0f
                                lineWidth:1.0f
                        progressDidChange:^(CGFloat progress) {
                            //
                        }];
    [self.view addSubview:self.progressView];
    
    __block double progress =   0.0f;
    
    
    NSTimer *timer  =   [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        progress    +=  0.02;
        if (progress < 1.0) {
            [self.progressView updateProgress:progress animated:YES];
        } else {
            [timer invalidate];
            [self.progressView removeFromSuperview];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//    UIButton *handleButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [handleButton setFrame:CGRectMake(8.0f, ScreenHeight/2-20.0f, ScreenWidth-16.0f, 40.0f)];
//    [handleButton setTitle:@"Start use photo picker ~ " forState:UIControlStateNormal];
//    [handleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [handleButton addTarget:self action:@selector(presentPhotoPickerActionSheetButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [handleButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
//    [self.view addSubview:handleButton];
}




- (void)presentPhotoPickerActionSheetButtonAction {
    UIAlertController *photoPickerActionSheet   =   [UIAlertController alertControllerWithTitle:@"Select Image" message:@"Select image from photo album or take a picture use camera" preferredStyle:UIAlertControllerStyleActionSheet];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoAlbumViewController];
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"User Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [self presentViewController:photoPickerActionSheet animated:YES completion:^{}];
}

- (void)presentPhotoAlbumViewController {
    IMPhotoAlbumsViewController *photoAlbumViewController   =   [[IMPhotoAlbumsViewController alloc] init];
    UINavigationController *naviPhotoAlbumViewController    =   [[UINavigationController alloc] initWithRootViewController:photoAlbumViewController];
    [self presentViewController:naviPhotoAlbumViewController animated:YES completion:^{}];
}

@end
