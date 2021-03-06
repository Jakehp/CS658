//
//  AppDelegate.h
//  ToDo
//
//  Created by Ryan Hardt on 3/7/14.
//  Copyright (c) 2014 Ryan Hardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
- (NSManagedObjectModel*)managedObjectModel;
-(NSMutableArray*)getToDoList;
@end
