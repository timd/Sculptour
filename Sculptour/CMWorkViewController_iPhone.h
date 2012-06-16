//
//  CMWorkViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Work;

@class CMWorkDetailViewController_iPhone;
//@class CMWorkPhotosViewController_iPhone;
//@class CMWorkCollectionViewController_iPhone;


@interface CMWorkViewController_iPhone : UIViewController <UITabBarDelegate>

@property (nonatomic, strong) Work *work;

@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) id currentTabView;
@property (nonatomic, strong) CMWorkDetailViewController_iPhone *detailViewController_iPhone;
//@property (nonatomic, strong) CMWorkPhotosViewController_iPhone *photosViewController_iPhone;
//@property (nonatomic, strong) CMWorkCollectionViewController_iPhone *collectionViewController_iPhone;

@property (nonatomic, strong) IBOutlet UILabel *questionMarkLabel;
@property (nonatomic, strong) IBOutlet UILabel *streetNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UIButton *collectButton;

- (IBAction)collectWork:(id)sender;

@end
