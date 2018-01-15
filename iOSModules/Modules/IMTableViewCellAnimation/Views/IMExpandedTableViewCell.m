//
//  IMExpandedTableViewCell.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/13.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMExpandedTableViewCell.h"

@interface IMExpandedTableViewCell  ()

@property (nonatomic, strong)   UIView      *initialView;
@property (nonatomic, strong)   UIButton    *expandedButton;
@property (nonatomic, strong)   UIView      *dynamicHeightView;
@property (nonatomic, strong)   UIView      *expandedView;



@end

@implementation IMExpandedTableViewCell


- (void)initialViewApperance {
    //
    self.initialView    =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.bounds.size.width, 40.0f)];
    [self.initialView setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.initialView];
    //
    self.expandedButton =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.expandedButton setTitle:@"Fold" forState:UIControlStateNormal];
    [self.expandedButton setTitle:@"Unfold" forState:UIControlStateSelected];
    [self.expandedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.expandedButton addTarget:self action:@selector(expandedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.expandedButton setFrame:self.initialView.bounds];
    [self.initialView addSubview:self.expandedButton];
    //
}

- (void)expandedButtonAction {
    if (self.expandBlock) {
        self.expandBlock(self.indexPath);
    }
}

- (void)layoutSubviews {
    [self initialViewApperance];
}


@end
