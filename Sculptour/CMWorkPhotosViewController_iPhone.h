//
//  CMWorkPhotosViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Work;
@class CMWorkViewController_iPhone;

@interface CMWorkPhotosViewController_iPhone : UIViewController<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) Work *work;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) CMWorkViewController_iPhone *parentController;

@property (nonatomic, strong) NSArray *imageViewList;

- (IBAction)pageChange;
- (void)takePhoto;

@end
