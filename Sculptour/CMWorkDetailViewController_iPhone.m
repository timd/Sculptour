//
//  CMWorkDetailViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkDetailViewController_iPhone.h"
#import "Work.h"

#import "GRMustache.h"

@interface CMWorkDetailViewController_iPhone ()

@end

@implementation CMWorkDetailViewController_iPhone

@synthesize webView=_webView;
@synthesize work=_work;


///////////////////////////////////////////////////////////////////////////////
//
- (void)updateUI
{
    NSError *error = nil;
    NSString *renderedHTML = [GRMustacheTemplate renderObject: self.work
                                                 fromResource: @"Details"
                                                       bundle: nil
                                                        error: &error];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"Details"
                                         withExtension: @"mustache"];
    [self.webView loadHTMLString: renderedHTML
                         baseURL: url];    
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork:(Work *)work
{
    _work = work;
    
    if (self.view)
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
    
    if (self.work != nil)
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
