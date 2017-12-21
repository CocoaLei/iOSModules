//
//  AppDelegate.h
//  iOSModules
//
//  Created by 石城磊 on 21/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

