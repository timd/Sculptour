//
//  CMAppDelegate.h
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBConnect.h"


extern NSString * const CMLocationUpdateNotification;

#define SharedCurrentLocation ((CMAppDelegate *)[[UIApplication sharedApplication] delegate]).lastPoint
#define SharedLocationManager ((CMAppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager

@class CMRootMenuViewController;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, FBSessionDelegate> {
    
    Facebook *facebook;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) CMRootMenuViewController *menuController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) CLLocationManager	*locationManager;
@property (nonatomic, strong) CLLocation *lastPoint;

@property (nonatomic, strong) Facebook *facebook;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
