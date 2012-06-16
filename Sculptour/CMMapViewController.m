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

@interface CMMapViewController ()


@end

@implementation CMMapViewController

@synthesize mapView=_mapView;
@synthesize detailViewController=_detailViewController;

///////////////////////////////////////////////////////////////////////////////
//
- (MKAnnotationView *)mapView: (MKMapView *)mapView 
            viewForAnnotation: (id <MKAnnotation>)annotation{

	MKPinAnnotationView *annotationView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];

    [annotationView setCanShowCallout: YES];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    CMPlacemark *mark = (CMPlacemark*)annotation;
    Work *work = mark.work;
    
	if (work.collected)
	{
		[annotationView setPinColor: MKPinAnnotationColorPurple];
	}
	else
	{
		[annotationView setPinColor: MKPinAnnotationColorGreen];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *workList = [Work MR_findAll];
    for (Work *work in workList)
    {
        CMPlacemark *placeMark = [[CMPlacemark alloc] initWithWork: work];
        [self.mapView addAnnotation: placeMark];
    }
        
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

@end
