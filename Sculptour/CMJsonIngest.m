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

@implementation CMJsonIngest

-(id)init {
    
    if (self = [super init]) {
        // custom
    }
    
    return self;
    
}

-(void)ingestJsonWithFilename:(NSString *)filename {
    
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

            
            NSString *key;
            for (key in theDict) {
                NSLog(@"Key: %@, Value: %@", key, [theDict objectForKey:key]);
            }
        
        }
        
        [[NSManagedObjectContext MR_defaultContext] save];
        
    }
    
}

@end
