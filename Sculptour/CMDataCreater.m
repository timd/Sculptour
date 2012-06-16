//
//  CMDataCreater.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMDataCreater.h"
#import "MagicalRecord.h"

#import "Work.h"
#import "Image.h"

@implementation CMDataCreater

-(id)init {
    self = [super init];
    if (self) {
        // Initialisation
    }
    
    return self;
}

-(void)createDummyData {
    
    for (NSInteger count = 0; count < 10; count++) {

        // Create dummy Work data for test purposes
        
        Work *newWork = [Work createEntity];
 
        newWork.artist = [NSString stringWithFormat:@"Artist_%d", count];
        newWork.title = [NSString stringWithFormat:@"Work %d", count];
        newWork.date = @"2012";
        newWork.collected = NO;
        newWork.material = @"Bronze";
        newWork.place = @"High Street";
        newWork.size = @"100cm x 100cm x 100cm";
        newWork.url = @"http://www.visitharlow.com/places-to-visit--things-to-do/harlow-sculpture-collection/the-collection/bird";
        newWork.text = @"A staggering work of heartbreaking genius";
        newWork.longitude = [NSNumber numberWithFloat:51.768809];
        newWork.latitude = [NSNumber numberWithFloat:0.090572];
        
        // Create dummy Image data for test purposes
        Image *newImage = [Image createEntity];
        newImage.file = [NSString stringWithFormat:@"image_%d.png", count];
        newImage.url = @"http://www.google.com/image.png";
        newImage.work = newWork;
        [newWork addImagesObject:newImage];
        
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_save];
    
}

@end
