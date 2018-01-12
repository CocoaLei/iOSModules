//
//  UIImage+FileSize.m
//  iOSModules
//
//  Created by 石城磊 on 2018/1/12.
//  Copyright © 2018年 石城磊. All rights reserved.
//

#import "UIImage+FileSize.h"

@implementation UIImage (FileSize)

+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

@end
