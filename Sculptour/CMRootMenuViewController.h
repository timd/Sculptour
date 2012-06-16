//
//  CMRootMenuViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCatagoryTopLevelViewController_iPhone;
@class CMMapViewController;

@interface CMRootMenuViewController : UIViewController

@property (nonatomic, strong) CMCatagoryTopLevelViewController_iPhone *catagoryView_iPhone;
@property (nonatomic, strong) CMMapViewController *mapViewController;

- (IBAction)showInstructions:(id)sender;
- (IBAction)showCollections:(id)sender;
- (IBAction)showMap:(id)sender;

@end
