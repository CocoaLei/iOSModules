//
//  IMInitialProgressViewController.m
//  iOSModules
//
//  Created by 石城磊 on 19/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMInitialProgressViewController.h"
#import "UIView+AddRoundBorder.h"
#import "IMRingProgressView.h"

@interface IMInitialProgressViewController ()

@property (nonatomic, strong)   IMRingProgressView  *progressView;
@property (nonatomic, assign)   CGFloat             currentProgress;

@end

@implementation IMInitialProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMProgressView";
    [self configureViewsApperance];
}

- (void)viewDidLayoutSubviews {
    [self configureViewsApperance];
}

- (void)configureViewsApperance {
    UISlider *progressSlider    =   [[UISlider alloc] initWithFrame:CGRectMake(8.0f, CGRectGetMaxY(self.view.frame)-60.0f, ScreenWidth-16.0f, 40.0f)];
    progressSlider.maximumValue =   1.0f;
    progressSlider.minimumValue =   0.0f;
    [progressSlider setBackgroundColor:[UIColor whiteColor]];
    [progressSlider setTintColor:[UIColor greenColor]];
    [progressSlider addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
    [progressSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressSlider];
    
    //
    self.progressView   =   [[IMRingProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40.0f, CGRectGetMidY(self.view.frame)-40.0f, 80.0f, 80.0f)];
    [self.view addSubview:self.progressView];
    
    //
    self.currentProgress    =   0.0f;
}

- (void)progressSliderValueChangedAction:(UISlider *)slider {
    CGFloat currentSliderValue  =   slider.value;
    if (currentSliderValue == slider.minimumValue) {
        [self.progressView performAction:IMProgressViewActionTypeNone animated:YES];
    }
    if (currentSliderValue > 0.9) {
        [self.progressView performAction:IMProgressViewActionTypeSuccess animated:YES];
    }
    [self.progressView setProgress:currentSliderValue animated:YES];
}



@end

