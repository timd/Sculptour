//
//  CMWorkCollectionViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkCollectionViewController_iPhone.h"
#import "CMCollectionGridViewController.h"
#import "CMWorkViewController_iPhone.h"

#import "Work.h"
#import "Tag.h"

#import "NSArray-Set.h"

@interface CMWorkCollectionViewController_iPhone ()

@end

@implementation CMWorkCollectionViewController_iPhone

@synthesize work=_work;
@synthesize tableView=_tableView;
@synthesize noCatagoriesLabel=_noCatagoriesLabel;
@synthesize parentController=_parentController;
@synthesize collectionViewController=_collectionViewController;


///////////////////////////////////////////////////////////////////////////////
//
- (void)updateUI
{
    if (self.work.tags.count == 0)
    {
        self.tableView.hidden = YES;
        self.noCatagoriesLabel.hidden = NO;
    }
    else 
    {
        self.tableView.hidden = NO;
        self.noCatagoriesLabel.hidden = YES;
        [self.tableView reloadData];
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
    
    if (self.work)
        [self updateUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.noCatagoriesLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source


///////////////////////////////////////////////////////////////////////////////
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.work.tags.count;
}


///////////////////////////////////////////////////////////////////////////////
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Catagory Level Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: CellIdentifier];
    }
    
    NSArray *orderedTags = [NSArray arrayByOrderingSet: self.work.tags
                                                 byKey: @"name"
                                             ascending: YES];
    
    Tag *tag = [orderedTags objectAtIndex: indexPath.row];
    
    NSPredicate *collectedPredicate = [NSPredicate predicateWithFormat: @"(ANY tags.name CONTAINS %@) AND (collected == YES)", tag.name];
    NSPredicate *homelessPredicate = [NSPredicate predicateWithFormat: @"latitude != %@ AND latitude != %@", nil, [NSNumber numberWithFloat: 0.0]];    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates: [NSArray arrayWithObjects: collectedPredicate, homelessPredicate, nil]];
    
    NSArray *collected_for_tag = [Work MR_findAllWithPredicate: predicate];
    
    int collected_count = collected_for_tag.count;
    
    cell.textLabel.text = [tag.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"You have %d of %d", collected_count, tag.work.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView delegate methods


///////////////////////////////////////////////////////////////////////////////
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *orderedTags = [NSArray arrayByOrderingSet: self.work.tags
                                                 byKey: @"name"
                                             ascending: YES];
    
    Tag *tag = [orderedTags objectAtIndex: indexPath.row];
    
    NSPredicate *tagPredicate = [NSPredicate predicateWithFormat: @"(ANY tags.name CONTAINS %@)", tag.name];
    NSPredicate *homelessPredicate = [NSPredicate predicateWithFormat: @"latitude != %@ AND latitude != %@", nil, [NSNumber numberWithFloat: 0.0]];    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates: [NSArray arrayWithObjects: tagPredicate, homelessPredicate, nil]];

    NSArray *works_for_tag = [Work MR_findAllWithPredicate: predicate];
    
    if (self.collectionViewController == nil)
    {
        self.collectionViewController = [[CMCollectionGridViewController alloc] init];
    }
    
    self.collectionViewController.title = [tag.name capitalizedString];
    self.collectionViewController.workList = works_for_tag;
    
    [self.parentController.navigationController pushViewController: self.collectionViewController
                                                          animated: YES];
    
}


@end
