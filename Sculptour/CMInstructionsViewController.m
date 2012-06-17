//
//  CMInstructionsViewController.m
//  Sculptour
//
//  Created by Michael Dales on 17/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMInstructionsViewController.h"
#import "GRMustache.h"

@interface CMInstructionsViewController ()

@end

@implementation CMInstructionsViewController

@synthesize webView=_webView;


///////////////////////////////////////////////////////////////////////////////
//
- (id)init
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    NSString *renderedHTML = [GRMustacheTemplate renderObject: nil
                                                 fromResource: @"Instructions"
                                                       bundle: nil
                                                        error: &error];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource: @"Instructions"
                                         withExtension: @"mustache"];
    [self.webView loadHTMLString: renderedHTML
                         baseURL: url];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
