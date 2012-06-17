//
//  CMWorkCollectionViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Work;
@class CMWorkViewController_iPhone;
@class CMCollectionGridViewController;

@interface CMWorkCollectionViewController_iPhone : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Work *work;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *noCatagoriesLabel;
@property (nonatomic, strong) CMWorkViewController_iPhone *parentController;
@property (nonatomic, strong) CMCollectionGridViewController *collectionViewController;


@end
