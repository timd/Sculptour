//
//  CMRootMenuViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMRootMenuViewController.h"
#import "CMCatagoryTopLevelViewController_iPhone.h"
#import "CMMapViewController.h"
#import "CMInstructionsViewController.h"

@implementation CMRootMenuViewController

@synthesize catagoryView_iPhone=_catagoryView_iPhone;
@synthesize mapViewController=_mapViewController;
@synthesize instructionsViewController=_instructionsViewController;

///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)showInstructions:(id)sender
{
    if (self.instructionsViewController == nil)
    {
        self.instructionsViewController = [[CMInstructionsViewController alloc] init];
    }
    
    [self.navigationController pushViewController: self.instructionsViewController
                                         animated: YES];
}


///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)showCollections:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        if (self.catagoryView_iPhone == nil)
        {
            self.catagoryView_iPhone = [[CMCatagoryTopLevelViewController_iPhone alloc] init];
        }
        
        [self.navigationController pushViewController: self.catagoryView_iPhone
                                             animated: YES];
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)showMap:(id)sender
{
    if (self.mapViewController == nil)
    {
        self.mapViewController = [[CMMapViewController alloc] init];
    }
    [self.navigationController pushViewController: self.mapViewController
                                         animated: YES];
}



///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Sculptour";
}

@end
