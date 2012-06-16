//
//  CMWorkViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Work;

@interface CMWorkViewController_iPhone : UIViewController

@property (nonatomic, strong) Work *work;

@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) IBOutlet UILabel *questionMarkLabel;
@property (nonatomic, strong) IBOutlet UILabel *streetNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;

@end
