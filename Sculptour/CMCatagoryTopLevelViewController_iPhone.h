//
//  CMCatagoryTopLevelViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCollectionGridViewController;

@interface CMCatagoryTopLevelViewController_iPhone : UITableViewController

@property (nonatomic, strong) NSArray *catagoryList;
@property (nonatomic, strong) CMCollectionGridViewController *collectionView;


@end
