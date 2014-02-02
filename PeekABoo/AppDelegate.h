//
//  AppDelegate.h
//  PeekABoo
//
//  Created by Apple on 30/01/14.
//  Copyright (c) 2014 Tablified Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *navController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
