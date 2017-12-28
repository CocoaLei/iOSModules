//
//  IMPhotoPickerInitialViewController.m
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMPhotoPickerInitialViewController.h"
#import "UIView+AddRoundBorder.h"

@interface IMPhotoPickerInitialViewController ()


@end

@implementation IMPhotoPickerInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMPhotoPicker";
    IMDebugLog();
    [self configureViewsApperance];
    
}

- (void)configureViewsApperance {
    
}

- (void)viewDidLayoutSubviews {
    IMDebugLog();
}



- (void)presentPhotoPickerActionSheetButtonAction {
    UIAlertController *photoPickerActionSheet   =   [UIAlertController alertControllerWithTitle:@"Select Image" message:@"Select image from photo album or take a picture use camera" preferredStyle:UIAlertControllerStyleActionSheet];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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


@end
