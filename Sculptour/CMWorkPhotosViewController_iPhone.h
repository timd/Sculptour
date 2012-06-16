//
//  CMWorkPhotosViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Work;

@interface CMWorkPhotosViewController_iPhone : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) Work *work;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *imageViewList;

- (IBAction)pageChange;

@end
