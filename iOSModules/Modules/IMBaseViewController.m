//
//  IMBaseViewController.m
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMBaseViewController.h"

@interface IMBaseViewController ()

@end

@implementation IMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]
                                                                      }];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"im_back_arrow_solid"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction)];
}

- (void)backItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
