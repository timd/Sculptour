//
//  CMWorkPhotosViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkPhotosViewController_iPhone.h"
#import "Work.h"
#import "Image.h"
#import "NSArray-Set.h"

@interface CMWorkPhotosViewController_iPhone ()

@end

@implementation CMWorkPhotosViewController_iPhone

@synthesize work=_work;

@synthesize scrollView;
@synthesize pageControl;
@synthesize imageViewList=_imageViewList;


///////////////////////////////////////////////////////////////////////////////
//
- (void)updateUI
{
    if ((self.view == nil) || (self.work == nil))
        return;

    // sort to just to be consistent
    NSArray *imageList = [NSArray arrayByOrderingSet: self.work.images
                                               byKey: @"url"
                                           ascending: YES];
    
    NSLog(@"images: %d", imageList.count);
    // only show the page control if we have to
    if (imageList.count < 2)
    {
        self.pageControl.hidden = YES;
    }
    else
    {
        self.pageControl.numberOfPages = imageList.count;
    }
    
    // work out the scroll area
    CGRect frame = self.scrollView.bounds;
    frame.size.width *= imageList.count;
    self.scrollView.contentSize = frame.size;
    
    [self.scrollView setContentOffset: CGPointMake(0.0, 0.0)
                             animated: NO];
    
    // generate an image view for each image
    NSMutableArray *newImageList = [NSMutableArray arrayWithCapacity: imageList.count];
    frame = self.scrollView.bounds;
    for (Image *workImage in imageList)
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: workImage.url]]];
                
        UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
        [self.scrollView addSubview: imageView];
        frame.origin.x += frame.size.width;
                
        [newImageList addObject: imageView];
    }    
    self.imageViewList = newImageList;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork:(Work *)work
{
    _work = work;
    
    if (self.view != nil)
        [self updateUI];
}


#pragma mark - general UIViewController stuff

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
    self.scrollView = nil;
    self.pageControl = nil;
    
    [super viewDidUnload];
}

#pragma mark - UIScrollView delegate methods


///////////////////////////////////////////////////////////////////////////////
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


///////////////////////////////////////////////////////////////////////////////
//
- (IBAction)pageChange
{
}

@end
