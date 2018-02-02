//
//  IMHomeViewController.m
//  iOSModules
//
//  Created by 石城磊 on 22/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "IMHomeViewController.h"
#import "ModulesHeader.h"

#import "IMModuleItemModel.h"
#import "IMModuleItemTableViewCell.h"

#import "IMPhotoPickerInitialViewController.h"
#import "IMTableViewCellAnimationViewController.h"

#import "IMInitialProgressViewController.h"

#import "IMDatePickerViewController.h"

#import <objc/runtime.h>

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
    self.homeTableView.frame    =   self.view.bounds;
    [self.view addSubview:self.homeTableView];
}

#pragma mark - Delegate
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modulesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMModuleItemTableViewCell   *imModuleItemTVCell =   [tableView dequeueReusableCellWithIdentifier:IMModuleItemTVCID];
    [imModuleItemTVCell setModel:self.modulesArray[indexPath.row]];
    return imModuleItemTVCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IMModuleItemModel *itemModel    =   self.modulesArray[indexPath.row];
    NSString *className             =   itemModel.InitialClass;
    [self.navigationController pushViewController:class_createInstance(objc_getClass([className UTF8String]), 0) animated:YES];
}

#pragma mark - Initializations
#pragma mark - Initial views
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView                  =   [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _homeTableView.dataSource       =   self;
        _homeTableView.delegate         =   self;
        _homeTableView.tableFooterView  =   [[UIView alloc] initWithFrame:CGRectZero];
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([IMModuleItemTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:IMModuleItemTVCID];
    }
    return _homeTableView;
}

- (NSArray *)modulesArray {
    if (!_modulesArray) {
        NSString *filePath                  =   [[NSBundle mainBundle] pathForResource:ModulesItemPListFileName ofType:@"plist"];
        NSArray *modulesItemArray           =   [NSArray loadArrayFromPListAtPath:filePath];
        NSMutableArray *tempMutArray        =   [NSMutableArray arrayWithCapacity:modulesItemArray.count];
        for (NSDictionary *itemDict in modulesItemArray) {
            IMModuleItemModel *itemModel    =   [[IMModuleItemModel alloc] init];
            [itemModel setValuesForKeysWithDictionary:itemDict];
            [tempMutArray addObject:itemModel];
        }
        _modulesArray                       =   [[NSArray alloc] initWithArray:[tempMutArray copy]];
    }
    return _modulesArray;
}

@end
