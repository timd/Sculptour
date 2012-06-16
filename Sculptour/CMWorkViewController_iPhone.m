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

#import "CMAppDelegate.h"

@interface CMWorkViewController_iPhone ()

@end

@implementation CMWorkViewController_iPhone

@synthesize work=_work;

@synthesize tabBar=_tabBar;

@synthesize questionMarkLabel=_questionMarkLabel;
@synthesize distanceLabel=_distanceLabel;
@synthesize streetNameLabel=_streetNameLabel;

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
    }
    else 
    {
        self.tabBar.hidden = YES;
        self.questionMarkLabel.hidden = NO;
        self.distanceLabel.hidden = NO;
        self.streetNameLabel.hidden = NO;
        
        CLLocation *here = SharedCurrentLocation;
        
        if (here != nil)
        {
            CLLocation *workLocation = [[CLLocation alloc] initWithLatitude: [self.work.latitude doubleValue]
                                                                  longitude: [self.work.longitude doubleValue]];
            float distance = [workLocation distanceFromLocation: SharedCurrentLocation];
            
            self.distanceLabel.text = [NSString stringWithFormat: @"%.1f km", distance / 1000.0];
        }
        else 
        {
            self.distanceLabel.text = @"Unknown distance";
        }
        
        self.streetNameLabel.text = self.work.place;
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork:(Work *)work
{
    _work = work;
    
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

@end
