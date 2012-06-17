//
//  CMCatagoryTopLevelViewController.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMCatagoryTopLevelViewController_iPhone.h"
#import "CMCollectionGridViewController.h"

#import "Tag.h"
#import "Work.h"

@interface CMCatagoryTopLevelViewController_iPhone ()

@end

@implementation CMCatagoryTopLevelViewController_iPhone

@synthesize catagoryList=_catagoryList;
@synthesize collectionView=_collectionView;


///////////////////////////////////////////////////////////////////////////////
//
- (void)buildMenu
{
    NSMutableArray *collections = [NSMutableArray array];
    
    // first add in all the tags
    NSArray *tagList = [Tag MR_findAll];
    
    for (Tag *tag in tagList)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"ANY tags.name CONTAINS %@", tag.name];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys: predicate, @"predicate", [tag.name capitalizedString], @"title", nil];        
        [collections addObject: info];
    }
    
    // now add the special cases
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"collected == NO"];//, [NSNumber numberWithBool: NO]];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys: predicate, @"predicate", @"Uncollected", @"title", nil];        
    [collections addObject: info];
    
    self.catagoryList = collections;
}


///////////////////////////////////////////////////////////////////////////////
//
- (id)init
{
    self = [super initWithStyle: UITableViewStylePlain];
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Categories";
    [self buildMenu];
    
    [self.tableView reloadData];
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

#pragma mark - Table view data source


///////////////////////////////////////////////////////////////////////////////
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


///////////////////////////////////////////////////////////////////////////////
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.catagoryList.count;
    else
        return 0;
}


///////////////////////////////////////////////////////////////////////////////
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Level Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                          reuseIdentifier: CellIdentifier];
    }
    
    NSDictionary *info = [self.catagoryList objectAtIndex: indexPath.row];
        
    cell.textLabel.text = [info objectForKey: @"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView == nil)
    {
        self.collectionView = [[CMCollectionGridViewController alloc] init];
    }
    
    NSDictionary *info = [self.catagoryList objectAtIndex: indexPath.row];
    NSPredicate *tagPredicate = [info objectForKey: @"predicate"];    
    NSPredicate *homelessPredicate = [NSPredicate predicateWithFormat: @"latitude != %@ AND latitude != %@", nil, [NSNumber numberWithFloat: 0.0]];    
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates: [NSArray arrayWithObjects: tagPredicate, homelessPredicate, nil]];
    
    NSArray *workSubSet = [Work MR_findAllWithPredicate: predicate];
    
    self.collectionView.workList = workSubSet;    
    self.collectionView.title = [info objectForKey: @"title"];
    
    [self.navigationController pushViewController: self.collectionView
                                         animated: YES];
    
}

@end
