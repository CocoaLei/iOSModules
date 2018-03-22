//
//  IMModalViewController.m
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMModalViewController.h"

@interface IMModalViewController ()

@property (nonatomic, strong)   UIView *modalContentView;
@property (nonatomic, strong)   NSMutableArray

@end

@implementation IMModalViewController

#pragma mark - Construction method
+ (instancetype)modalViewControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                              modalViewStyle:(IMModalViewStyle)modalViewStyle {
    return [[IMModalViewController alloc] initWithTitle:title message:message modalViewStyle:modalViewStyle];
}

#pragma mark - Initialize methods
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               modalViewStyle:(IMModalViewStyle)modalViewStyle {
    if (self = [super init]) {
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        [self setUpModalViewWithTitle:title message:message modalViewStyle:modalViewStyle];
    }
    return self;
}

- (void)setUpModalViewWithTitle:(NSString *)title
                        message:(NSString *)message
                 modalViewStyle:(IMModalViewStyle)modalViewStyle {
    //
    self.modalContentView   =   [[UIView alloc] initWithFrame:CGRectZero];
    [self.modalContentView setBackgroundColor:[UIColor whiteColor]];
    //
    switch (modalViewStyle) {
        case IMModalViewStyleAlert:
            [self configureAlertModalViewWithTitle:title message:message];
            break;
        case IMModalViewStyleActionSheet:
            [self configureActionSheettModalViewWithTitle:title message:message];
            break;
        default:
            break;
    }
}

- (void)modalViewAddAction:(IMModalViewAction *)modalViewAction {
    
}

#pragma mark - Configure methods
- (void)configureAlertModalViewWithTitle:(NSString *)title
                                 message:(NSString *)message {
    [self setUpTitle:title message:message];
}

- (void)configureActionSheettModalViewWithTitle:(NSString *)title
                                        message:(NSString *)message {
    self.modalContentView   =   [[UIView alloc] initWithFrame:CGRectMake(16.0f, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width-16.0f*2, 0.0f)];
    [self setUpTitle:title message:message];
}

- (void)setUpTitle:(NSString *)title message:(NSString *)message {
    UIView *modalHeaderView       =   [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat headerHeight          =   0.0f;
    //
    if (title && title.length > 0) {
        UIView *modalTitleView    =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.modalContentView.bounds.size.width, 44.0f)];
        UILabel *modalTitleLabel  =   [[UILabel alloc] initWithFrame:modalTitleView.bounds];
        modalTitleLabel.text      =   title;
        modalTitleLabel.textColor =   [UIColor blackColor];
        modalTitleLabel.textAlignment   =   NSTextAlignmentCenter;
        [modalTitleView addSubview:modalTitleLabel];
        [modalHeaderView addSubview:modalTitleView];
        //
        headerHeight += 44.0f;
    }
    //
    if (message && message.length >0) {
        UIView *modalMessageView    =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerHeight, self.modalContentView.bounds.size.width, 44.0f)
];
        UILabel *modalMessageLabel  =   [[UILabel alloc] initWithFrame:modalMessageView.bounds];
        modalMessageLabel.text      =   message;
        modalMessageLabel.textColor =   [UIColor darkGrayColor];
        modalMessageLabel.textAlignment   =   NSTextAlignmentCenter;
        [modalMessageView addSubview:modalMessageLabel];
        [modalHeaderView addSubview:modalMessageView];
        //
        headerHeight += 44.0f;
    }
    [modalHeaderView setFrame:CGRectMake(0.0f, 0.0f, self.modalContentView.bounds.size.width, headerHeight)];
    CGRect contentRect  =   self.modalContentView.frame;
    [self.modalContentView setFrame:CGRectMake(contentRect.origin.x, contentRect.origin.y-headerHeight-8.0f, contentRect.size.width, headerHeight)];
    [self.modalContentView addSubview:modalHeaderView];
    [self.modalContentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.modalContentView];
}

@end
