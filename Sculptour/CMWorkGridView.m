//
//  CMWorkGridView.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "CMWorkGridView.h"
#import "Work.h"
#import "Image.h"
#import "CMAppDelegate.h"

@implementation CMWorkGridView

@synthesize work=_work;



///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork: (Work*)work
{
    _work = work;
    
    title.text = work.title;
    
    if ([work.collected isEqualToNumber: [NSNumber numberWithBool: YES]])
    {
        Image *workImage = [work.images anyObject];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:workImage.file ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        imageView.image = image;
        
        colorView.backgroundColor = [UIColor whiteColor];
    }
    else 
    {
        UIImage *image = [UIImage imageNamed: @"qmark"];
        imageView.image = image;
        
        CLLocation *artLocation = [[CLLocation alloc] initWithLatitude: [self.work.latitude floatValue]
                                                             longitude: [self.work.longitude floatValue]];
        CLLocation *here = SharedCurrentLocation;        
        float distance = [artLocation distanceFromLocation: here];
        
        if (distance > 5000.0)
            distance = 5000.0;
        
        float closeness = distance / 5000.0;
        if (closeness > 1.0)
            closeness = 1.0;
        
        NSLog(@"distance, closeness: %f, %f", distance, closeness);
        
        UIColor * color = [UIColor colorWithRed: closeness 
                                          green: 1.0 - closeness
                                           blue: 0.0 
                                          alpha: 1.0];
        colorView.backgroundColor = color;
    }
}
                  


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithFrame: (CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame: frame
                reuseIdentifier: reuseIdentifier];
    if (self) 
    {
//        title = [[UILabel alloc] initWithFrame: CGRectMake(0.0, 0.0, self.bounds.size.width, 25.0)];
        //        [self.contentView addSubview: title];  
        
        colorView = [[UIView alloc] initWithFrame: CGRectMake(15.0, 15.0, self.bounds.size.width - 30.0, self.bounds.size.height - 30.0)];
        [self.contentView addSubview: colorView];      
        
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake(5.0, 5.0, self.bounds.size.width - 10.0, self.bounds.size.height - 10.0)];        
        [self.contentView addSubview: imageView];
    }
    return self;
}

@end
