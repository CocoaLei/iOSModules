//
//  IMDatePickerViewController.m
//  iOSModules
//
//  Created by 石城磊 on 29/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMDatePickerViewController.h"
#import "IMDatePicker.h"

@interface IMDatePickerViewController ()

@end

@implementation IMDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMDatePicker";
    [self configureViewsApperance];
    IMDebugLog(@"----------------------------------");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IMDebugLog(@"----------------------------------");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    IMDebugLog(@"----------------------------------");
}

- (void)viewWillLayoutSubviews {
    IMDebugLog(@"----------------------------------");
}

- (void)viewDidLayoutSubviews {
    IMDebugLog(@"----------------------------------");
}

- (void)configureViewsApperance {
    NSLocale *currentLocal  =   [NSLocale currentLocale];
    IMDebugLog(@"%@",currentLocal.languageCode);
    
    IMDatePicker *imDatePicker  =   [[IMDatePicker alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame)-300.0f, CGRectGetWidth(self.view.frame), 300.0f)];
    [imDatePicker setSelectDateCompletionHandler:^(NSDictionary *dateDict) {
        IMDebugLog(@"Name = %@ \n Date = %@",dateDict[@"Name"],dateDict[@"Date"]);
    }];
    [self.view addSubview:imDatePicker];
}

@end
