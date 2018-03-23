//
//  IMModalViewAction.h
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMModalViewAction;

typedef NS_ENUM(NSInteger, IMModalViewActionStyle) {
    IMModalViewActionStyleDefault   =   0,
    IMModalViewActionStyleCancel    =   1
};

typedef void (^IMModalViewActionHandler) (IMModalViewAction *action);

@interface IMModalViewAction : UIView

@property (nonatomic, copy  )   NSString                 *title;
@property (nonatomic, copy  )   NSDictionary             *attributeDict;
@property (nonatomic, assign)   IMModalViewActionStyle   style;
@property (nonatomic, copy  )   IMModalViewActionHandler actionHandler;

//
+ (instancetype)modalViewActionWithTitle:(NSString *)title
                           attributeDict:(NSDictionary *)attributeDict
                                   style:(IMModalViewActionStyle)style
                                 handler:(IMModalViewActionHandler)handler;
//
- (void)setUpModalViewAction;

@end
