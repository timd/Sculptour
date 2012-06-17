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
    
    NSString *path = nil;
    
    if ([image.userGenerated isEqualToNumber:[NSNumber numberWithInt:1]]) {
        
        // Retrieve filepath as png from user docs directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory 
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", image.file];
        path = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
        
    } else {
        
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: workImage.url]]];
        path = [[NSBundle mainBundle] pathForResource:image.file ofType:@"jpg"];
        
    }

    NSURL *url = [NSURL fileURLWithPath: path];
    path = [NSString stringWithFormat: @"%@", url];
    
    return path;    
}

@end
