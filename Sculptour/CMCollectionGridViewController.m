//
//  CMCollectionGridViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMCollectionGridViewController.h"
#import "CMWorkGridView.h"
#import "Work.h"
#import "CMWorkViewController_iPhone.h"

@interface CMCollectionGridViewController ()

@end

@implementation CMCollectionGridViewController

@synthesize gridView=_gridView;
@synthesize workList=_workList;
@synthesize workViewController_iPhone=_workViewController_iPhone;

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
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.layoutDirection = AQGridViewLayoutDirectionVertical;
        
    [self.view addSubview: self.gridView];
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Insert tag here";
    
    self.workList = [Work MR_findAll];
    
    [self.gridView reloadData];
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
- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    return CGSizeMake(100, 100);
}


///////////////////////////////////////////////////////////////////////////////
//
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.workList.count;
}


///////////////////////////////////////////////////////////////////////////////
//
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    
    CMWorkGridView *cell = (CMWorkGridView*)[self.gridView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil)
    {
        cell = [[CMWorkGridView alloc] initWithFrame: CGRectMake(0.0, 0.0, 100.0, 10.0)
                                     reuseIdentifier: reuseIdentifier];
    }
    
    Work *work = [self.workList objectAtIndex: index];
    cell.work = work;
    
    return cell;
}


#pragma mark - AQGridView delegate


///////////////////////////////////////////////////////////////////////////////
//
- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    if (self.workViewController_iPhone == nil)
    {
        self.workViewController_iPhone = [[CMWorkViewController_iPhone alloc] init];
    }
    
    Work *work = [self.workList objectAtIndex: index];
    self.workViewController_iPhone.work = work;
    
    [self.navigationController pushViewController: self.workViewController_iPhone
                                         animated: YES];
    
}


@end
