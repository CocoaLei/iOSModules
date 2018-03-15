//
//  IMCameraViewController.m
//  iOSModules
//
//  Created by 石城磊 on 15/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMCameraViewController.h"
#import "IMCameraPreview.h"
#import "IMCamera.h"

@interface IMCameraViewController ()

@property (nonatomic, strong    )   IMCameraPreview *cameraPreview;
@property (nonatomic, strong    )   IMCamera        *camera;

@end

@implementation IMCameraViewController

#pragma mark  - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpIMCamera];
}

#pragma mark - Initial setup
- (void)setUpIMCamera {
    self.camera         =   [[IMCamera alloc] init];
    self.cameraPreview  =   [[IMCameraPreview alloc] initWithFrame:self.view.bounds camera:self.camera];
    [self.view addSubview:self.cameraPreview];
}

@end
