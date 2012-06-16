//
//  CMMapViewController.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CMWorkViewController_iPhone;

@interface CMMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CMWorkViewController_iPhone *detailViewController;

@end
