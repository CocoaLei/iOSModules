//
//  IMModalViewController.m
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMModalViewController.h"

#define ModalViewItemHeight 52.0f

@interface IMModalViewController ()

@property (nonatomic, strong)   UIView          *modalContentView;
// Actions
@property (nonatomic, strong)   NSMutableArray <__kindof IMModalViewAction*>  *actionsMutArr;
//
@property (nonatomic, assign)   CGFloat         offsetY;

@end

@implementation IMModalViewController

#pragma mark - Construction method

+ (instancetype)modalViewControllerWithTitle:(NSString *)title
                             titleAttributes:(NSDictionary *)titleAttribus
                                     message:(NSString *)message
                           messageAttributes:(NSDictionary *)messageAttributes
                              modalViewStyle:(IMModalViewStyle)modalViewStyle {
    return [[IMModalViewController alloc] initWithTitle:title
                                        titleAttributes:titleAttribus
                                                message:message
                                      messageAttributes:messageAttributes
                                         modalViewStyle:modalViewStyle];
}


#pragma mark - Initialize methods
- (instancetype)initWithTitle:(NSString *)title
              titleAttributes:(NSDictionary *)titleAttribus
                      message:(NSString *)message
            messageAttributes:(NSDictionary *)messageAttributes
               modalViewStyle:(IMModalViewStyle)modalViewStyle {
    if (self = [super init]) {
        _modalViewTitle                 =   title;
        if (titleAttribus) {
            _modalViewTitleAttributes   =   [NSDictionary dictionaryWithDictionary:titleAttribus];
        }
        //
        _modalViewMessage               =   message;
        if (messageAttributes) {
            _modalViewMessageAttributes =   [NSDictionary dictionaryWithDictionary:messageAttributes];
        }
        _modalViewStyle                 =   modalViewStyle;
        //
        self.modalTransitionStyle       =   UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle     =   UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)modalViewAddAction:(IMModalViewAction *)modalViewAction {
    if (!self.actionsMutArr) {
        self.actionsMutArr  =   [NSMutableArray array];
    }
    //
    [self.actionsMutArr addObject:modalViewAction];
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self configureModalView];
}

#pragma mark - Private methods
- (void)configureModalView {
    [self.view setBackgroundColor:RGBACOLOR(0.0f, 0.0f, 0.0f, 0.1)];
    //
    CGFloat modalViewWidth      =   CGRectGetWidth(self.view.bounds)-16.0f*2;
    CGFloat contentViewHeight   =   0.0f;
    if (self.modalViewTitle.length > 0) {
        contentViewHeight   +=  ModalViewItemHeight;
    }
    if (self.modalViewMessage.length > 0) {
        contentViewHeight   +=  ModalViewItemHeight;
    }
    UIView *headerContentView   =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, modalViewWidth, contentViewHeight)];
    contentViewHeight       +=  self.actionsMutArr.count * ModalViewItemHeight;
    // Cancel action
    self.modalContentView   =   [[UIView alloc] initWithFrame:CGRectZero];
    switch (self.modalViewStyle) {
        case IMModalViewStyleAlert:
        {
            [self.modalContentView setFrame:CGRectMake(16.0f, CGRectGetMidY(self.view.frame)-contentViewHeight/2.0f, modalViewWidth, contentViewHeight)];
        }
            break;
        case IMModalViewStyleActionSheet:
        {
            [self.modalContentView setFrame:CGRectMake(16.0f, CGRectGetMaxY(self.view.frame)-contentViewHeight-16.0f, modalViewWidth, contentViewHeight)];
        }
            break;
        default:
            break;
    }
    [self.modalContentView setBackgroundColor:[UIColor clearColor]];
    self.modalContentView.layer.cornerRadius    =   5.0f;
    self.modalContentView.layer.masksToBounds   =   YES;
    [self.view addSubview:self.modalContentView];
    //
    self.offsetY    =   0.0f;
    
    if (self.modalViewTitle) {
        UILabel *modalViewTitleLabel        =   [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, modalViewWidth, ModalViewItemHeight)];
        [modalViewTitleLabel setBackgroundColor:[UIColor whiteColor]];
        modalViewTitleLabel.textColor       =   [UIColor blackColor];
        modalViewTitleLabel.font            =   [UIFont systemFontOfSize:14.0f];
        modalViewTitleLabel.textAlignment   =   NSTextAlignmentCenter;
        if (self.modalViewTitleAttributes) {
            NSAttributedString *attributeTitle  =   [[NSAttributedString alloc] initWithString:self.modalViewTitle
                                                                                    attributes:self.modalViewTitleAttributes];
            modalViewTitleLabel.attributedText  =   attributeTitle;
        } else {
            modalViewTitleLabel.text            =   self.modalViewTitle;
        }
        [headerContentView   addSubview:modalViewTitleLabel];
        self.offsetY    += ModalViewItemHeight;
    }
    //
    if (self.modalViewMessage) {
        UILabel *modalViewMessageLabel        =   [[UILabel alloc] initWithFrame:CGRectMake(0.0f, ModalViewItemHeight, modalViewWidth, ModalViewItemHeight)];
        [modalViewMessageLabel setBackgroundColor:[UIColor whiteColor]];
        modalViewMessageLabel.textColor       =   [UIColor blackColor];
        modalViewMessageLabel.font            =   [UIFont systemFontOfSize:14.0f];
        modalViewMessageLabel.textAlignment   =   NSTextAlignmentCenter;
        if (self.modalViewMessageAttributes) {
            NSAttributedString *attributeTitle    =   [[NSAttributedString alloc] initWithString:self.modalViewMessage
                                                                                    attributes:self.modalViewMessageAttributes];
            modalViewMessageLabel.attributedText  =   attributeTitle;
        } else {
            modalViewMessageLabel.text            =   self.modalViewMessage;
        }
        [headerContentView   addSubview:modalViewMessageLabel];
        self.offsetY    += ModalViewItemHeight;
    }
    headerContentView.layer.cornerRadius    =   5.0f;
    headerContentView.layer.masksToBounds   =   YES;
    [self.modalContentView addSubview:headerContentView];
    //
    [self configureModalViewActions];
}

- (void)configureModalViewActions {
    CGFloat modalViewWidth      =   CGRectGetWidth(self.view.bounds)-16.0f*2;
    switch (self.modalViewStyle) {
        case IMModalViewStyleAlert:
        {
            if (self.actionsMutArr.count == 2) {
                for (NSInteger index = 0; index < self.actionsMutArr.count; index++) {
                    IMModalViewAction *aModalViewAction = self.actionsMutArr[index];
                    [aModalViewAction setFrame:CGRectMake(index==0?(0.0f):((modalViewWidth-1.0f)/2)+1.0f, self.offsetY, (modalViewWidth-1.0f)/2, ModalViewItemHeight)];
                    [aModalViewAction setUpModalViewAction];
                    [self.modalContentView addSubview:aModalViewAction];
                }

            } else {
                for (NSInteger index = 0; index < self.actionsMutArr.count; index++) {
                    IMModalViewAction *aModalViewAction = self.actionsMutArr[index];
                    [aModalViewAction setFrame:CGRectMake(0.0f, self.offsetY+index*ModalViewItemHeight, modalViewWidth, ModalViewItemHeight)];
                    [aModalViewAction setUpModalViewAction];
                    [self.modalContentView addSubview:aModalViewAction];
                }
            }
           
        }
            break;
        case IMModalViewStyleActionSheet:
        {
            for (NSInteger index = 0; index < self.actionsMutArr.count; index++) {
                IMModalViewAction *aModalViewAction = self.actionsMutArr[index];
                [aModalViewAction setFrame:CGRectMake(0.0f, self.offsetY+index*ModalViewItemHeight, modalViewWidth, ModalViewItemHeight)];
                [aModalViewAction setUpModalViewAction];
                [self.modalContentView addSubview:aModalViewAction];
            }
        }
        default:
            break;
    }
    
}

@end
