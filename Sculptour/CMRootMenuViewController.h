//
//  CMRootMenuViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMCatagoryTopLevelViewController_iPhone;

@interface CMRootMenuViewController : UIViewController

@property (nonatomic, strong) CMCatagoryTopLevelViewController_iPhone *catagoryView_iPhone;

- (IBAction)showInstructions:(id)sender;
- (IBAction)showCollections:(id)sender;
- (IBAction)showMap:(id)sender;

@end
