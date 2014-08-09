//
//  DAAppDelegate.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
