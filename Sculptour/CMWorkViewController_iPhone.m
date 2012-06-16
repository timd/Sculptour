//
//  CMWorkViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkViewController_iPhone.h"
#import "Work.h"

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
    }
    else 
    {
        self.tabBar.hidden = YES;
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
    // Do any additional setup after loading the view from its nib.
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
