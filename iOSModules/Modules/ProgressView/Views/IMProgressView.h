//
//  IMProgressView.h
//  iOSModules
//
//  Created by 石城磊 on 19/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMProgressViewActionType) {
    IMProgressViewActionTypeNone    =   0,
    IMProgressViewActionTypeSuccess =   1,
    IMProgressViewActionTypeFailure =   2
};

@interface IMProgressView : UIView

@property (nonatomic, readonly) CGFloat progress;
@property (nonatomic, assign  ) CGFloat animationDuration;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)performAction:(IMProgressViewActionType)actionType animated:(BOOL)animated;


@end
