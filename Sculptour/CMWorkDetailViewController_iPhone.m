//
//  CMWorkDetailViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Twitter/TWTweetComposeViewController.h>

#import "CMWorkDetailViewController_iPhone.h"
#import "Work.h"
#import "Image.h"
#import "CMAppDelegate.h"
#import "CMWorkViewController_iPhone.h"


#import "GRMustache.h"

@interface CMWorkDetailViewController_iPhone ()

@end

@implementation CMWorkDetailViewController_iPhone

@synthesize webView=_webView;
@synthesize work=_work;
@synthesize parentController = _parentController;


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
- (void)share: (id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle: @"Title" 
                                                            delegate: self 
                                                   cancelButtonTitle: @"Cancel" 
                                              destructiveButtonTitle: nil
                                                   otherButtonTitles: @"Share on Facebook", @"Share on Twitter", nil];
    [popupQuery showInView:self.view];

}


///////////////////////////////////////////////////////////////////////////////
//
- (void)postToTwitter
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText: [NSString stringWithFormat: @"I found the %@ sculpture in Harlow!", self.work.title]];
    
    [self presentModalViewController:twitter animated:YES];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {            
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
    };

}


///////////////////////////////////////////////////////////////////////////////
//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self didTapFacebookButton: nil];
            break;
            
        case 1:
            [self postToTwitter];
            break;
            
        default:
            break;
    }
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.work != nil)
        [self updateUI];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.parentController.navigationItem.rightBarButtonItem = share;
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
    
    // Get the image to post to Facebook
    UIImage *image = nil;

    NSSet *imagesSet = self.work.images;
    NSArray *imagesArray = [imagesSet allObjects];

    Image *workImage = [imagesArray objectAtIndex:0];
    
    if ([workImage.userGenerated isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        
        // Retrieve filepath as png from user docs directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory 
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", workImage.file];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
        image = [UIImage imageWithContentsOfFile:filePath];
        
    } else {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:workImage.file ofType:@"jpg"];
        image = [UIImage imageWithContentsOfFile:filePath];
        
    }
    
    NSData* imageData = UIImageJPEGRepresentation(image, 90);
    NSString *photoCaption = [NSString stringWithFormat:@"%@ - %@", self.work.artist, self.work.title];
    
    CMAppDelegate *appDelegate = (CMAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = appDelegate.facebook;
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[facebook accessToken], 
                                    @"access_token",
                                    photoCaption, 
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
