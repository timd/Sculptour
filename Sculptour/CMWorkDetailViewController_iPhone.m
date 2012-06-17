//
//  CMWorkDetailViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkDetailViewController_iPhone.h"
#import "Work.h"
#import "CMAppDelegate.h"

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

- (IBAction)didTapFacebookButton:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"piglet.jpg"];
    NSData* imageData = UIImageJPEGRepresentation(image, 90);
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = appDelegate.facebook;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[facebook accessToken], 
                                    @"access_token",
                                    @"This is a photo of Piglet", 
                                    @"message",
                                    imageData, 
                                    @"source",
                                    nil];
    
    [facebook requestWithGraphPath:@"me/photos" 
                         andParams:params
                     andHttpMethod:@"POST" 
                       andDelegate:self];
}

-(void)requestLoading:(FBRequest *)request {
    
}

-(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}

-(void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Error from Facebook request: %@", [error localizedDescription]);
    
}

-(void)request:(FBRequest *)request didLoad:(id)result {
    
}

@end
