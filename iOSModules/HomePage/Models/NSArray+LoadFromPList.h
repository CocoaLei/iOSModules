//
//  NSArray+LoadFromPList.h
//  iOSModules
//
//  Created by 石城磊 on 27/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LoadFromPList)

+ (NSArray *)loadArrayFromPListAtPath:(NSString *)plistFilePath;
- (BOOL)saveArrayToPListAtPath:(NSString *)plistFilePath;

@end
