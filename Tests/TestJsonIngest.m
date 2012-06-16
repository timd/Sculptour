//
//  TestJsonIngest.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
#import "Work.h"
#import "Image.h"

#import "CMDataCreater.h"

@interface TestJsonIngest : GHTestCase { }

@property (nonatomic, strong) NSArray *jsonArray;

@end

@implementation TestJsonIngest

@synthesize jsonArray;

-(void)setUp {
    
    [MagicalRecord setDefaultModelFromClass:[self class]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Sculptour-Test.sql"];
    
//	[MagicalRecord setupCoreDataStackWithInMemoryStore];
    
}

-(void)tearDown {
    
    [Work MR_truncateAll];
    [MagicalRecord cleanUp];
    
}

-(void)testJson {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestJson" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    GHAssertNotNil(data, @"data is nil, should not be");
    
    NSError *error;
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    GHAssertNotNil(self.jsonArray, @"is nil, should not be nil");
    
    int jsonArrayCount = [self.jsonArray count];
    GHAssertEquals(jsonArrayCount, 3, @"expected 3 elements, got %d", jsonArrayCount);

    // INGEST TEST JSON
    
    for (NSDictionary *theDict in self.jsonArray) {
        
        NSLog(@"Index: %d", [self.jsonArray indexOfObject:theDict]);
        
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

        NSString *key;
        for (key in theDict) {
            NSLog(@"Key: %@, Value: %@", key, [theDict objectForKey:key]);
        }
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] save];
    
    NSArray *worksArray = [Work MR_findAll];
    
    int worksCount = [worksArray count];
    GHAssertEquals(worksCount, 3, @"Should be 3 works, got %d", worksCount);
    
    // 
    Work *workOne = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 1"];
    GHAssertNotNil(workOne, @"workOne was not found");
    
    // Test Lat/Long
    Work *workTwo = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 2"];
    GHAssertNotNil(workTwo, @"workOne was not found");
    GHAssertEqualObjects(workTwo.latitude, NULL, @"latitude should be NULL, was %@", workTwo.latitude);

}

@end
