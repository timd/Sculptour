//
//  CMPlacemark.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Work;

@interface CMPlacemark : NSObject <MKAnnotation>

- (id)initWithWork: (Work*)work;

@property (nonatomic, strong) Work *work;

@end
