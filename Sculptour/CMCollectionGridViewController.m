//
//  CMCollectionGridViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMCollectionGridViewController.h"

@interface CMCollectionGridViewController ()

@end

@implementation CMCollectionGridViewController

@synthesize gridView=_gridView;


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)loadView
{
    [super loadView];
    
    self.gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
        
    [self.view addSubview: self.gridView];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


///////////////////////////////////////////////////////////////////////////////
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - AQGridView data source

///////////////////////////////////////////////////////////////////////////////
//

#pragma mark - AQGridView delegate

@end
