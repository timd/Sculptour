//
//  CMWorkViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "CMWorkViewController_iPhone.h"
#import "Work.h"
#import "Image.h"

#import "CMAppDelegate.h"

#import "CMWorkDetailViewController_iPhone.h"
#import "CMWorkPhotosViewController_iPhone.h"
#import "CMWorkCollectionViewController_iPhone.h"

#import "CLLocation+CLExtensions.h"

#define kCMDetailsTabTag 0
#define kCMPhotosTabTag 1
#define kCMCollectionTabTag 2


@interface CMWorkViewController_iPhone ()

@end

@implementation CMWorkViewController_iPhone

@synthesize work=_work;

@synthesize tabBar=_tabBar;
@synthesize currentTabView=_currentTabView;
@synthesize detailViewController_iPhone=_detailViewController_iPhone;
@synthesize photosViewController_iPhone=_photosViewController_iPhone;
@synthesize collectionViewController_iPhone=_collectionViewController_iPhone;

@synthesize questionMarkLabel=_questionMarkLabel;
@synthesize distanceLabel=_distanceLabel;
@synthesize streetNameLabel=_streetNameLabel;
@synthesize collectButton=_collectButton;
@synthesize artistLabel=_artistLabel;


///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)collectWork:(id)sender
{
    self.work.collected = [NSNumber numberWithBool: YES];
    [[NSManagedObjectContext defaultContext] MR_save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: CMWorkCollectedNotification
                                                        object: self.work];
    
    [self updateUI];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    int item_tag = item.tag;
    
    switch (item_tag) 
    {
        case kCMDetailsTabTag:
            
            if (self.detailViewController_iPhone == nil)
            {
                self.detailViewController_iPhone = [[CMWorkDetailViewController_iPhone alloc] init];
                self.detailViewController_iPhone.parentController = self;

            }
            self.detailViewController_iPhone.work = self.work;
            
            if (self.navigationItem.rightBarButtonItem) {
                // TODO: Be consistent...
//                self.navigationItem.rightBarButtonItem = nil;
            }
            
            [[self.currentTabView view] removeFromSuperview];
            self.currentTabView = self.detailViewController_iPhone;
            [self.view addSubview: [self.currentTabView view]];
            
            break;
            
        case kCMPhotosTabTag:
            
        {
            
            if (self.photosViewController_iPhone == nil)
            {
                self.photosViewController_iPhone = [[CMWorkPhotosViewController_iPhone alloc] init];
                self.photosViewController_iPhone.parentController = self;
            }
            self.photosViewController_iPhone.work = self.work;
            
            // Add "take photo" button to navbar
            UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto)];
            self.navigationItem.rightBarButtonItem = photoButton;
            
            [[self.currentTabView view] removeFromSuperview];
            self.currentTabView = self.photosViewController_iPhone;
            [self.view addSubview: [self.currentTabView view]];
            
            break;
        }
            
        case kCMCollectionTabTag:
            
            if (self.collectionViewController_iPhone == nil)
            {
                self.collectionViewController_iPhone = [[CMWorkCollectionViewController_iPhone alloc] init];
                self.collectionViewController_iPhone.parentController = self;
            }
            self.collectionViewController_iPhone.work = self.work;
            
            if (self.navigationItem.rightBarButtonItem) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            
            [[self.currentTabView view] removeFromSuperview];
            self.currentTabView = self.collectionViewController_iPhone;
            [self.view addSubview: [self.currentTabView view]];
            
            break;
            
        default:
            break;
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)updateUI
{
    if ([self.work.collected boolValue] == YES)
    {
        self.tabBar.hidden = NO;
        self.questionMarkLabel.hidden = YES;
        self.distanceLabel.hidden = YES;
        self.streetNameLabel.hidden = YES;        
        self.collectButton.hidden = YES;
        self.artistLabel.hidden = YES;
        
        // this doesn't seem to cause the delegate method to be called
        [self.tabBar setSelectedItem: [[self.tabBar items] objectAtIndex: 0]];
        [self tabBar: self.tabBar
       didSelectItem: [[self.tabBar items] objectAtIndex: 0]];        
    }
    else 
    {
        if (self.currentTabView)
            [[self.currentTabView view] removeFromSuperview];
        
        self.tabBar.hidden = YES;
        self.questionMarkLabel.hidden = NO;
        self.distanceLabel.hidden = NO;
        self.streetNameLabel.hidden = NO;
        self.artistLabel.hidden = NO;
        
        CLLocation *here = SharedCurrentLocation;
        
        if (here != nil)
        {
            CLLocation *workLocation = [[CLLocation alloc] initWithLatitude: [self.work.latitude doubleValue]
                                                                  longitude: [self.work.longitude doubleValue]];
            CLLocation *here = SharedCurrentLocation;
            
            float distance = [workLocation distanceFromLocation: here];
            
            
			
			// now work out the direction
			float radians = [here bearingInRadiansTowardsLocation: workLocation];
			
			NSString *direction;
			if ((radians >= ((1.0 * M_PI) / 8.0)) && (radians < ((3.0 * M_PI) / 8.0)))
				direction = @"north east";
			else if ((radians >= ((3.0 * M_PI) / 8.0)) && (radians < ((5.0 * M_PI) / 8.0)))
				direction = @"east";
			else if ((radians >= ((5.0 * M_PI) / 8.0)) && (radians < ((7.0 * M_PI) / 8.0)))
				direction = @"south east";
			else if ((radians >= ((7.0 * M_PI) / 8.0)) && (radians < ((9.0 * M_PI) / 8.0)))
				direction = @"south";
			else if ((radians >= ((9.0 * M_PI) / 8.0)) && (radians < ((11.0 * M_PI) / 8.0)))
				direction = @"south west";
			else if ((radians >= ((11.0 * M_PI) / 8.0)) && (radians < ((13.0 * M_PI) / 8.0)))
				direction = @"west";
			else if ((radians >= ((13.0 * M_PI) / 8.0)) && (radians < ((15.0 * M_PI) / 8.0)))
				direction = @"north west";
			else 
				direction = @"north";
            
            
            self.distanceLabel.text = [NSString stringWithFormat: @"%.1f km to the %@", distance / 1000.0, direction];
            
            
            self.collectButton.hidden = distance > 10.0;
            
        }
        else 
        {
            self.distanceLabel.text = @"Unknown distance";
            self.collectButton.hidden = YES;
        }
        
        self.streetNameLabel.text = self.work.place;
        self.artistLabel.text = self.work.artist;
        
        self.collectButton.hidden = NO;
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork:(Work *)work
{
    _work = work;
    
    self.title = work.title;
    
    [self updateUI];
}

///////////////////////////////////////////////////////////////////////////////
//
- (id)init
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.work)
        [self updateUI];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


///////////////////////////////////////////////////////////////////////////////
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Photo methods

-(void)takePhoto {
    
    NSLog(@"takePhoto");
    
#if TARGET_IPHONE_SIMULATOR
    [self showActionSheet];
#else
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showActionSheet];
    } else {
        [self takeSimulatorSafePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
#endif
    
}


-(void)showActionSheet {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose source of photo" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take photo", @"Choose from library", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"button = %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
            // dismiss, no action
            break;
            
        case 1:
            // Use camera
            [self takeSimulatorSafePhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
            
        case 2:
            // Use library
            [self takeSimulatorSafePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        default:
            break;
            
    }
}

-(void)takeSimulatorSafePhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Check if the camera's available - if not, switch to the PhotoLibrary
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Set the image picker to the valid type
    [imagePicker setSourceType:sourceType];
    [imagePicker setAllowsEditing:NO];
    [imagePicker setDelegate:self];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self presentModalViewController:imagePicker animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // This UIIMagePickerController delegate method is called by the image picker when 
    // it's dismissed as a result of choosing an image from the Photo Library, 
    // or taking an image with the camera
    
    // Get image from picker
    UIImage *takenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"takenImage = %@", takenImage);
    
    // Create a new image for the current Work
    
    NSData *pngData = UIImagePNGRepresentation(takenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory 
    
    // Create the filename
    NSString *imageFilename = [NSString stringWithFormat:@"image-%@", [NSDate date]];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageFilename]];
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    NSLog(@"imageFilename = %@", imageFilename);
    NSLog(@"filePath = %@", filePath);
    
    Image *newImage = [Image MR_createEntity];
    newImage.file = imageFilename;
    newImage.userGenerated = [NSNumber numberWithBool:YES];
    [self.work addImagesObject:newImage];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self dismissModalViewControllerAnimated:YES];  
    
    [self updateUI];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self dismissModalViewControllerAnimated:YES];
    
}


@end
