//
//  IMDatePicker.h
//  iOSModules
//
//  Created by 石城磊 on 29/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDateBlock)(NSDictionary *dateDict);

@interface IMDatePicker : UIView

@property (nonatomic, copy )    DidSelectDateBlock selectDateCompletionHandler;

@end
