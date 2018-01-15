//
//  IMTableViewCellAnimationViewController.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/13.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMTableViewCellAnimationViewController.h"
#import "IMExpandedTableViewCell.h"

static  NSString * const IMExpandedTVCID    =   @"IMExpandedTableViewCellReuseIdentifier";

@interface IMTableViewCellAnimationViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong)   UITableView *mainTableView;
@property (nonatomic, strong)   NSIndexPath *expandedIndexPath;

@end

@implementation IMTableViewCellAnimationViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewsApperance];
}

#pragma mark - Private methods
- (void)configureViewsApperance {
    self.title  =   @"TableViewCell Animation";
    [self.mainTableView setFrame:self.view.bounds];
    [self.view addSubview:self.mainTableView];
}

- (void)expandTableViewCellAtIndexPath:(NSIndexPath *)indexPath {
    self.expandedIndexPath  =   indexPath;
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Delegate
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMExpandedTableViewCell *expandedTVC    =   [tableView dequeueReusableCellWithIdentifier:IMExpandedTVCID forIndexPath:indexPath];
    [expandedTVC setExpandBlock:^(NSIndexPath *indexPath) {
        [self expandTableViewCellAtIndexPath:indexPath];
    }];
    expandedTVC.indexPath                   =   indexPath;
    return expandedTVC;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedIndexPath == indexPath) {
        return 80.0f;
    }
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Initializations
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView                  =   [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.dataSource       =   self;
        _mainTableView.delegate         =   self;
        _mainTableView.tableFooterView  =   [[UIView alloc] initWithFrame:CGRectZero];
        [_mainTableView registerClass:[IMExpandedTableViewCell class] forCellReuseIdentifier:IMExpandedTVCID];
    }
    return _mainTableView;
}

@end
