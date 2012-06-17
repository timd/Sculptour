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
    NSLog(@"tags (%d)", tagList.count);
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView == nil)
    {
        self.collectionView = [[CMCollectionGridViewController alloc] init];
    }
    
    NSDictionary *info = [self.catagoryList objectAtIndex: indexPath.row];
    NSPredicate *predicate = [info objectForKey: @"predicate"];
    
    NSArray *workSubSet = [Work MR_findAllWithPredicate: predicate];
    NSLog(@"items: %d", workSubSet.count);
    
    self.collectionView.workList = workSubSet;    
    self.collectionView.title = [info objectForKey: @"title"];
    
    [self.navigationController pushViewController: self.collectionView
                                         animated: YES];
    
}

@end
