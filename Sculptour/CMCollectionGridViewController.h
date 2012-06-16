//
//  CMCollectionGridViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class CMWorkViewController_iPhone;

@interface CMCollectionGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, strong) AQGridView *gridView;
@property (nonatomic, strong) NSArray *workList;

@property (nonatomic, strong) CMWorkViewController_iPhone *workViewController_iPhone;

@end
