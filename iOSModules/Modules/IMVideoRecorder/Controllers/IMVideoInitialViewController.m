//
//  IMVideoInitialViewController.m
//  iOSModules
//
//  Created by 石城磊 on 26/02/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMVideoInitialViewController.h"
#import "UIView+AddRoundBorder.h"
#import "IMCameraViewController.h"

@interface IMVideoInitialViewController ()

@end

@implementation IMVideoInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMVideoRecorder";
    [self configureViewsApperance];
}

- (void)configureViewsApperance {
    UIButton *handleButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [handleButton setFrame:CGRectMake(8.0f, ScreenHeight/2-20.0f, ScreenWidth-16.0f, 40.0f)];
    [handleButton setTitle:@"Start use photo picker ~ " forState:UIControlStateNormal];
    [handleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton addTarget:self action:@selector(presentVideoRecorderActionSheetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [handleButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
    [self.view addSubview:handleButton];
}

- (void)presentVideoRecorderActionSheetButtonAction {
    UIAlertController *photoPickerActionSheet   =   [UIAlertController alertControllerWithTitle:@"Select Video" message:@"Select video from local or record a video use camera" preferredStyle:UIAlertControllerStyleActionSheet];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Select From Local" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        IMCameraViewController *camera    =   [[IMCameraViewController alloc] init];
        [self presentViewController:camera animated:YES completion:^{}];
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [photoPickerActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [photoPickerActionSheet dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [self presentViewController:photoPickerActionSheet animated:YES completion:^{}];
}

@end
