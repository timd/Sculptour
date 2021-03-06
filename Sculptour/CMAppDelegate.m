//
//  CMAppDelegate.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMAppDelegate.h"
#import "CMRootMenuViewController.h"
#import "CMDataCreater.h"
#import "CMJsonIngest.h"
#import "DCIntrospect.h"

NSString * const CMLocationUpdateNotification = @"CMLocationUpdateNotification";
NSString * const CMWorkCollectedNotification = @"CMWorkCollectedNotification";

@implementation CMAppDelegate

@synthesize window = _window;
@synthesize navController=_navController;
@synthesize menuController=_menuController;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize locationManager=_locationManager;
@synthesize lastPoint=_lastPoint;

@synthesize facebook;

///////////////////////////////////////////////////////////////////////////////
//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.menuController = [[CMRootMenuViewController alloc] initWithNibName:@"CMRootMenuViewController_iPhone" bundle:nil];
    } else {
        self.menuController = [[CMRootMenuViewController alloc] initWithNibName:@"CMRootMenuViewController_iPad" bundle:nil];
    }
    
    self.navController = [[UINavigationController alloc] initWithRootViewController: self.menuController];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"sculptour.sql"];
    CMJsonIngest *jsonIngester = [[CMJsonIngest alloc] init];
    [jsonIngester ingestJsonWithFilename:@"harlow"];

    // Setup Facebook
    facebook = [[Facebook alloc] initWithAppId:@"408333842536848" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                nil];
        [facebook authorize:permissions];
    }
    
    
	// setup globally accessible location manager
	self.locationManager = [[CLLocationManager alloc] init];    
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
    
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    [MagicalRecord cleanUp];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Sculptour" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Sculptour.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Location methods

///////////////////////////////////////////////////////////////////////////////
//
- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation 
		   fromLocation: (CLLocation *)oldLocation
{	
    CLLocationCoordinate2D coordinate = newLocation.coordinate; 
    
    if ((coordinate.latitude == 0.0) && (coordinate.longitude == 0.0))
        return;
    
	// check that an update is really necessary here
	if (self.lastPoint != nil)
	{       
        
		if ((self.lastPoint.coordinate.latitude == coordinate.latitude) &&
			(self.lastPoint.coordinate.longitude == coordinate.longitude))
		{
			return;
		}
	}
	
	self.lastPoint = newLocation;
	
	// if anyone has asked to be updated after this, tell them about it
	[[NSNotificationCenter defaultCenter] postNotificationName: (NSString*)CMLocationUpdateNotification
														object: self];									
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)locationManager:(CLLocationManager *)manager 
	   didFailWithError:(NSError *)error 
{
	if (error.code == kCLErrorDenied)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't get location"
														message: @"We couldn't get your location! To use Sculptour you should head over to your phone's settings and enable it under the location preferences."
													   delegate:nil
											  cancelButtonTitle:@"Okay" 
											  otherButtonTitles:nil]; 
		[alert show]; 
	}
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)locationManager: (CLLocationManager *)manager 
	   didUpdateHeading: (CLHeading *)newHeading
{
}


///////////////////////////////////////////////////////////////////////////////
//
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
	return NO;
}

#pragma mark -
#pragma mark Facebook delegate methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

-(void)fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}
 
-(void)fbDidNotLogin:(BOOL)cancelled {  
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
}

-(void)fbSessionInvalidated {
}

@end
