//
//  IMModalViewController.h
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMModalViewAction.h"

typedef NS_ENUM(NSInteger,IMModalViewStyle) {
    IMModalViewStyleAlert        =   0,
    IMModalViewStyleActionSheet  =   1
};

@interface IMModalViewController : UIViewController

// Base module
@property (nonatomic, copy  )   NSString        *modalViewTitle;
@property (nonatomic, copy  )   NSDictionary    *modalViewTitleAttributes;
@property (nonatomic, copy  )   NSString        *modalViewMessage;
@property (nonatomic, copy  )   NSDictionary    *modalViewMessageAttributes;
@property (nonatomic, assign)   IMModalViewStyle modalViewStyle;

+ (instancetype)modalViewControllerWithTitle:(NSString *)title
                            titleAttributes:(NSDictionary *)titleAttribus
                                     message:(NSString *)message
                           messageAttributes:(NSDictionary *)messageAttributes
                              modalViewStyle:(IMModalViewStyle)modalViewStyle;
//
- (void)modalViewAddAction:(IMModalViewAction *)modalViewAction;

@end
