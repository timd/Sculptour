//
//  CMJsonIngest.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMJsonIngest.h"

#import "Work.h"
#import "Image.h"
#import "Tag.h"

@implementation CMJsonIngest

-(id)init {
    
    if (self = [super init]) {
        // custom
    }
    
    return self;
    
}

-(void)ingestJsonWithFilename:(NSString *)filename {
    
    // Drop all existing records
    [Work MR_truncateAll];
    [Image MR_truncateAll];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    NSArray *JSONarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (!JSONarray) {
        
        NSLog(@"Error parsing JSON: %@", error);
        
    } else {   
                
        for (NSDictionary *theDict in JSONarray) {
        
            NSLog(@"Index: %d", [JSONarray indexOfObject:theDict]);
            
            Work *newWork = [Work MR_createEntity];
            
            // text
            // size
            // artist
            // location
            // internal
            // work
            // material
            
            if ([[theDict objectForKey:@"text"] isEqual:[NSNull null]]) {
                newWork.text = @"";
            } else {
                newWork.text = [theDict objectForKey:@"text"];
            }
            newWork.size = [theDict objectForKey:@"size"];
            newWork.artist = [theDict objectForKey:@"artist"];
            newWork.place = [theDict objectForKey:@"location"];
            newWork.internal = [theDict objectForKey:@"internal"];
            newWork.title = [theDict objectForKey:@"work"];
            newWork.material = [theDict objectForKey:@"material"];
            
            if ([[theDict objectForKey:@"latitude"] isEqual:[NSNull null]]) {
                newWork.latitude = nil;
            } else {
                newWork.latitude = [theDict objectForKey:@"latitude"];
            }

            if ([[theDict objectForKey:@"longitude"] isEqual:[NSNull null]]) {
                newWork.longitude = nil;
            } else {
                newWork.longitude = [theDict objectForKey:@"longitude"];
            }

            if (![[theDict objectForKey:@"image"] isEqual:[NSNull null]]) {
                
                Image *newImage = [Image MR_createEntity];
                newImage.file = [theDict objectForKey:@"image"];
                
                [newWork addImagesObject:newImage];
                
            }
            
            // Handle tags
            NSArray *tagsArray = [theDict objectForKey:@"tags"];
            NSLog(@"tagsArray = %@", tagsArray);
            
            // Iterate across the tags array
            for (NSDictionary *tagDict in tagsArray) {

                NSLog(@"tagDict = %@", tagDict);
                NSLog(@"value = %@", [tagDict valueForKey:@"tag"]);
                
                // See if there's already an existing tag with this name
                NSArray *tags = [Tag MR_findByAttribute:@"name" withValue:[tagDict valueForKey:@"tag"]];
                if ([tags count] == 0) {
                    // No tag currently exists, create a new one
                    Tag *newTag = [Tag MR_createEntity];
                    [newTag setName:[tagDict objectForKey:@"tag"]];
                    [newWork addTagsObject:newTag];
                } else {
                    Tag *theTag = [tags objectAtIndex:0];
                    [newWork addTagsObject:theTag];
                }
                
            }

            NSString *key;
            for (key in theDict) {
                NSLog(@"Key: %@, Value: %@", key, [theDict objectForKey:key]);
            }
        
        }
        
        [[NSManagedObjectContext MR_defaultContext] save];
        
    }
    
}

@end
