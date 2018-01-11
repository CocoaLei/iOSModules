//
//  IMPhotoPreview.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/11.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "IMPhotoPreview.h"

@interface IMPhotoPreview ()

@property (nonatomic, copy) NSArray *photos;

@end

@implementation IMPhotoPreview

- (instancetype)initWithFrame:(CGRect)frame photos:(NSArray *)photos {
    if (self = [super initWithFrame:frame]) {
        self.photos =   photos;
    }
    return self;
}

@end
