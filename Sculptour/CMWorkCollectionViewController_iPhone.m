//
//  CMWorkCollectionViewController_iPhone.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkCollectionViewController_iPhone.h"

#import "Work.h"
#import "Tag.h"

#import "NSArray-Set.h"

@interface CMWorkCollectionViewController_iPhone ()

@end

@implementation CMWorkCollectionViewController_iPhone

@synthesize work=_work;
@synthesize tableView=_tableView;
@synthesize noCatagoriesLabel=_noCatagoriesLabel;



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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(ANY tags.name CONTAINS %@) AND (collected == YES)", tag.name];
    NSArray *collected_for_tag = [Work MR_findAllWithPredicate: predicate];
    
    int collected_count = collected_for_tag.count;
    
    cell.textLabel.text = [tag.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"You have %d of %d", collected_count, tag.work.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
