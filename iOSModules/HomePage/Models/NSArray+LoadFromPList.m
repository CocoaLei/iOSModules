//
//  NSArray+LoadFromPList.m
//  iOSModules
//
//  Created by 石城磊 on 27/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import "NSArray+LoadFromPList.h"

@implementation NSArray (LoadFromPList)

+ (NSArray *)loadArrayFromPListAtPath:(NSString *)plistFilePath {
    return [[NSArray alloc] initWithContentsOfFile:plistFilePath];
}

- (BOOL)saveArrayToPListAtPath:(NSString *)plistFilePath {
    return [self writeToFile:plistFilePath atomically:YES];
}

@end
