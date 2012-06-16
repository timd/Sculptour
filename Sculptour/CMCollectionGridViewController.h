//
//  CMCollectionGridViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface CMCollectionGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, strong) AQGridView *gridView;

@end
