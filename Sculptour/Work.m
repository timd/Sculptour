//
//  Work.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "Work.h"
#import "Image.h"
#import "Tag.h"


@implementation Work

@dynamic artist;
@dynamic collected;
@dynamic date;
@dynamic internal;
@dynamic latitude;
@dynamic longitude;
@dynamic material;
@dynamic place;
@dynamic size;
@dynamic text;
@dynamic title;
@dynamic url;
@dynamic images;
@dynamic tags;



///////////////////////////////////////////////////////////////////////////////
//
- (NSString*)fileURLForOneImage
{
    if (self.images.count < 1)
        return nil;
    
    Image *image = [self.images anyObject];
    NSString *path = [[NSBundle mainBundle] pathForResource: image.file ofType: @"jpg"];
    NSURL *url = [NSURL fileURLWithPath: path];
    path = [NSString stringWithFormat: @"%@", url];
    
    return path;    
}

@end
