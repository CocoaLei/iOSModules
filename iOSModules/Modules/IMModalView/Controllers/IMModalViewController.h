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

+ (instancetype)modalViewControllerWithTitle:(NSString *)title message:(NSString *)message modalViewStyle:(IMModalViewStyle)modalViewStyle;
- (void)modalViewAddAction:(IMModalViewAction *)modalViewAction;

@end
