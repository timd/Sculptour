//
//  CMPlacemark.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMPlacemark.h"
#import "Work.h"

@implementation CMPlacemark

@synthesize coordinate=_coordinate;
@synthesize work=_work;


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithWork: (Work*)work
{
    self = [super init];
    if (self != nil)
    {
        self.work = work;
        
        _coordinate.latitude = [work.latitude floatValue];
        _coordinate.longitude = [work.longitude floatValue];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (NSString*)title
{
    return self.work.title;
}


///////////////////////////////////////////////////////////////////////////////
//
- (NSString*)subtitle
{
    return [NSString stringWithFormat: @"By %@", self.work.artist];
}


@end
