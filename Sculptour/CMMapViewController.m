//
//  CMMapViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMMapViewController.h"
#import "Work.h"
#import "CMPlacemark.h"
#import "CMWorkViewController_iPhone.h"
#import "CMAppDelegate.h"

@interface CMMapViewController ()


@end

@implementation CMMapViewController

@synthesize mapView=_mapView;
@synthesize detailViewController=_detailViewController;

///////////////////////////////////////////////////////////////////////////////
//
- (MKAnnotationView *)mapView: (MKMapView *)mapView 
            viewForAnnotation: (id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MKUserLocation class]])
        return nil;    
    
	MKPinAnnotationView *annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];

    [annotationView setCanShowCallout: YES];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    CMPlacemark *mark = (CMPlacemark*)annotation;
    Work *work = mark.work;
    
	if (work.collected)
	{
		[annotationView setPinColor: MKPinAnnotationColorGreen];
	}
	else
	{
		[annotationView setPinColor: MKPinAnnotationColorRed];
	}
    
	return annotationView;
}



///////////////////////////////////////////////////////////////////////////////
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CMPlacemark *annocation = (CMPlacemark*)[view annotation];
    
    if (self.detailViewController == nil)
    {
        self.detailViewController = [[CMWorkViewController_iPhone alloc] init];
    }
    self.detailViewController.work = annocation.work;
    
    [self.navigationController pushViewController: self.detailViewController
                                         animated: YES];
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
- (void)workCollectedNotification: (NSNotification*)notification
{
    NSArray *annotations = [self.mapView annotations];    
    [self.mapView removeAnnotations: annotations];
    
    // ignore stuff with no lat/lng
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"latitude != %@ AND latitude != %@", nil, [NSNumber numberWithFloat: 0.0]];    
    NSArray *workList = [Work MR_findAllWithPredicate: predicate];

    
    for (Work *work in workList)
    {
        CMPlacemark *placeMark = [[CMPlacemark alloc] initWithWork: work];
        [self.mapView addAnnotation: placeMark];                
    }   
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Harlow";
    
    [self.mapView setShowsUserLocation: YES];
    CLLocationCoordinate2D coord;
    coord.latitude = 51.765608948854236; 
    coord.longitude = 0.10488510131835938;
    
    MKCoordinateSpan span = {.latitudeDelta = 0.05, .longitudeDelta = 0.05};
    MKCoordinateRegion region = {coord, span};
    [self.mapView setRegion:region];
    
    
    // ignore stuff with no lat/lng
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"latitude != %@ AND latitude != %@", nil, [NSNumber numberWithFloat: 0.0]];    
    NSArray *workList = [Work MR_findAllWithPredicate: predicate];
    for (Work *work in workList)
    {
        CMPlacemark *placeMark = [[CMPlacemark alloc] initWithWork: work];
        [self.mapView addAnnotation: placeMark];                
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(workCollectedNotification:) 
                                                 name: CMWorkCollectedNotification
                                               object: nil];
        
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    self.mapView = nil;
    [super viewDidUnload];
}


///////////////////////////////////////////////////////////////////////////////
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
