//
//  IMModalViewAction.m
//  iOSModules
//
//  Created by 石城磊 on 21/03/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMModalViewAction.h"

@interface IMModalViewAction ()

@property (nonatomic, copy  )   NSString                 *title;
@property (nonatomic, copy  )   NSDictionary             *attributeDict;
@property (nonatomic, assign)   IMModalViewActionStyle   style;
@property (nonatomic, copy  )   IMModalViewActionHandler actionHandler;

@end

@implementation IMModalViewAction

+ (instancetype)modalViewActionWithTitle:(NSString *)title
                           attributeDict:(NSDictionary *)attributeDict
                                   style:(IMModalViewActionStyle)style
                                 handler:(IMModalViewActionHandler)handler {
    return [[IMModalViewAction alloc] initWithTitle:title attributeDict:attributeDict style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title
                attributeDict:(NSDictionary *)attributeDict
                        style:(IMModalViewActionStyle)style
                      handler:(IMModalViewActionHandler)handler {
    if (self = [super init]) {
        self.title          =   title;
        self.attributeDict  =   attributeDict;
        self.style          =   style;
        self.actionHandler  =   handler;
        [self setUpModalViewAction];
    }
    return self;
}

#pragma mark - Set up view
- (void)setUpModalViewAction {
    UILabel *titleLabel =   [[UILabel alloc] initWithFrame:self.bounds];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    //
    if (!self.attributeDict) {
        NSAttributedString *attributedString    =   [[NSAttributedString alloc] initWithString:self.title attributes:self.attributeDict];
        [titleLabel setAttributedText:attributedString];
    } else {
        [titleLabel setText:self.title];
    }
    [self addSubview:titleLabel];
    //
    UITapGestureRecognizer *modalViewActionTap  =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    modalViewActionTap.numberOfTapsRequired     =   1;
    modalViewActionTap.numberOfTouchesRequired  =   1;
    [self addGestureRecognizer:modalViewActionTap];
}

- (void)tapAction:(id)sender {
    if (self.actionHandler) {
        self.actionHandler(self);
    }
}

@end
