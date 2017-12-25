//
//  IMHomeViewController.m
//  iOSModules
//
//  Created by 石城磊 on 22/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMHomeViewController.h"
#import "IMModuleItemTableViewCell.h"

static NSString * const IMModuleItemTVCID   =   @"IMModuleItemTVCID";

@interface IMHomeViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong)   UITableView *homeTableView;
@property (nonatomic, copy  )   NSArray     *modulesArray;


@end

@implementation IMHomeViewController

#pragma mark -
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewApperance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Configure and Layout
- (void)configureViewApperance {
    self.title  =   @"iOS Modules";
}

#pragma mark - Delegate
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modulesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMModuleItemTableViewCell   *imModuleItemTVCell =   [[IMModuleItemTableViewCell alloc] init];
    return imModuleItemTVCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0f;
}

#pragma mark - Initializations
#pragma mark - Initial views
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView              =   [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _homeTableView.dataSource   =   self;
        _homeTableView.delegate     =   self;
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMModuleItemTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:IMModuleItemTVCID];
    }
    return _homeTableView;
}

@end
