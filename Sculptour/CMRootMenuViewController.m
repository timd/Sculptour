//
//  CMRootMenuViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMRootMenuViewController.h"
#import "CMCatagoryTopLevelViewController_iPhone.h"

@implementation CMRootMenuViewController

@synthesize catagoryView_iPhone=_catagoryView_iPhone;


///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)showInstructions:(id)sender
{
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
}


@end
