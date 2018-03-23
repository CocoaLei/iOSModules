//
//  IMModalInitialViewController.m
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMModalInitialViewController.h"
#import "IMModalViewController.h"

@interface IMModalInitialViewController ()

@end

@implementation IMModalInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title  =   @"IMModalView";
    [self configureViewsApperance];
}

- (void)configureViewsApperance {
    UIButton *handleButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [handleButton setFrame:CGRectMake(8.0f, ScreenHeight/2-20.0f, ScreenWidth-16.0f, 40.0f)];
    [handleButton setTitle:@"Start present a moadl view " forState:UIControlStateNormal];
    [handleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton addTarget:self action:@selector(presentModalViewAction) forControlEvents:UIControlEventTouchUpInside];
    [handleButton addRoundBorderWithBorderColor:[UIColor blackColor] borderWidth:1.0f radius:5.0f];
    [self.view addSubview:handleButton];
}

- (void)presentModalViewAction {
    IMModalViewController *actionSheetModalViewController   =   [IMModalViewController modalViewControllerWithTitle:@"Modal Title"
                                                                                                    titleAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24.0f]}
                                                                                                            message:@"This is a custom modal view that can set attribute text."
                                                                                                  messageAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor darkGrayColor]} modalViewStyle:IMModalViewStyleAlert];
    [actionSheetModalViewController modalViewAddAction:[IMModalViewAction modalViewActionWithTitle:@"Action-001"
                                                                                     attributeDict:nil
                                                                                             style:IMModalViewActionStyleDefault
                                                                                           handler:^(IMModalViewAction *action) {
        [actionSheetModalViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheetModalViewController modalViewAddAction:[IMModalViewAction modalViewActionWithTitle:@"Action-002"
                                                                                     attributeDict:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}
                                                                                             style:IMModalViewActionStyleDefault
                                                                                           handler:^(IMModalViewAction *action) {
        [actionSheetModalViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheetModalViewController modalViewAddAction:[IMModalViewAction modalViewActionWithTitle:@"Action-003"
                                                                                     attributeDict:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[UIColor greenColor]}
                                                                                             style:IMModalViewActionStyleDefault
                                                                                           handler:^(IMModalViewAction *action) {
        [actionSheetModalViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheetModalViewController modalViewAddAction:[IMModalViewAction modalViewActionWithTitle:@"Cancel Action"
                                                                                     attributeDict:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor redColor]}
                                                                                             style:IMModalViewActionStyleCancel
                                                                                           handler:^(IMModalViewAction *action) {
        [actionSheetModalViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:actionSheetModalViewController animated:YES completion:nil];
}

@end
