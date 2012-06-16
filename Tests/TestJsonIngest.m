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
#import "Tag.h"

#import "CMDataCreater.h"
#import "CMJsonIngest.h"

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
    
    GHAssertNotNil(self.jsonArray, @"is nil: got error %@", error);
    
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

        if (![[theDict objectForKey:@"image"] isEqual:[NSNull null]]) {
            
            Image *newImage = [Image MR_createEntity];
            newImage.file = [NSString stringWithFormat:@"%d", [theDict objectForKey:@"image"]];
            
            [newWork addImagesObject:newImage];
            
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

    NSSet *images = workOne.images;
    GHAssertNotNil(images, @"images should not be nil");
    
    NSArray *imagesArray = [images allObjects];
    int count = [imagesArray count];
    GHAssertEquals(count, 1, @"should be one image, is %d", count);
    
    // Test Lat/Long
    Work *workTwo = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 2"];
    GHAssertNotNil(workTwo, @"workOne was not found");
    GHAssertEqualObjects(workTwo.latitude, NULL, @"latitude should be NULL, was %@", workTwo.latitude);

}

-(void)testJsonFromFile {

    CMJsonIngest *ingester = [[CMJsonIngest alloc] init];
    
    [ingester ingestJsonWithFilename:@"TestJson"];
    
    // Test results in Core Data
    
    NSArray *worksArray = [Work MR_findAll];
    
    int worksCount = [worksArray count];
    GHAssertEquals(worksCount, 3, @"Should be 3 works, got %d", worksCount);
    
    // 
    Work *workOne = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 1"];
    GHAssertNotNil(workOne, @"workOne was not found");
    
    NSSet *images = workOne.images;
    GHAssertNotNil(images, @"images should not be nil");
    
    NSArray *imagesArray = [images allObjects];
    int count = [imagesArray count];
    GHAssertEquals(count, 1, @"should be one image, is %d", count);
    
    // Test Lat/Long
    Work *workTwo = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 2"];
    GHAssertNotNil(workTwo, @"workOne was not found");
    GHAssertEqualObjects(workTwo.latitude, NULL, @"latitude should be NULL, was %@", workTwo.latitude);
    
}

-(void)testPresenceOfImages {
    
    CMJsonIngest *ingester = [[CMJsonIngest alloc] init];
    
    [ingester ingestJsonWithFilename:@"TestJson"];
    
    Work *workOne = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 1"];
    GHAssertNotNil(workOne, @"workOne was not found");

    NSSet *images = workOne.images;
    NSArray *imagesArray = [images allObjects];
    int count = [imagesArray count];
    GHAssertEquals(count, 1, @"should be one image, is %d", count);
    
    Image *theImage = [imagesArray objectAtIndex:0];
    GHAssertNotNil(theImage, @"theImage should not be nil");
    
    GHAssertEqualStrings(theImage.file, @"1", @"theImage.file should be '1'");

    NSString *fileName = [NSString stringWithFormat:@"%@", theImage.file];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
    
    GHAssertEqualStrings(fileName, @"1", @"should be 1, but is %@", fileName);
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    GHAssertNotNil(image, @"image should not be nil");
    
}

-(void)testCreationOfTags {
    
    CMJsonIngest *ingester = [[CMJsonIngest alloc] init];
    
    [ingester ingestJsonWithFilename:@"TestJson"];
    
    Work *workOne = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 1"];
    GHAssertNotNil(workOne, @"workOne was not found");

    // Given the test JSON
    // When I ingest the JSON
    // Then the first work should have one tag
    // And the tag name should be "foo"
    
    NSSet *tags = workOne.tags;
    NSArray *tagsArray = [tags allObjects];
    int tagsCount = [tagsArray count];
    GHAssertEquals(tagsCount, 1, @"expected 1 tag, got %d", tagsCount);
    
    Tag *theTag = [tagsArray objectAtIndex:0];
    GHAssertEqualStrings(theTag.name, @"foo", @"expected tag.name = foo, got %@", theTag.name);
    
    // Given the test JSON
    // When I ingest the JSON
    // Then the second work should have no tags

    Work *workTwo = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 2"];
    GHAssertNotNil(workTwo, @"workTwo was not found");
    
    NSSet *workTwoTags = workTwo.tags;
    NSArray *workTwoTagsArray = [workTwoTags allObjects];
    int workTwoTagCount = [workTwoTagsArray count];
    GHAssertEquals(workTwoTagCount, 0, @"expected 0 tag, got %d", tagsCount);

    // Given the test JSON
    // When I ingest the JSON
    // Then the third work should have two tags
    // And the first tag should be foo
    // And the second tag should be bar
    
    Work *workThree = [Work MR_findFirstByAttribute:@"artist" withValue:@"Artist 3"];
    GHAssertNotNil(workThree, @"workThree was not found");
    
    NSSet *workThreeTags = workThree.tags;
    NSArray *workThreeTagsArray = [workThreeTags allObjects];
    int workThreeTagCount = [workThreeTagsArray count];
    GHAssertEquals(workThreeTagCount, 2, @"expected 0 tag, got %d", tagsCount);

    NSInteger fooIndex = [workThreeTagsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Tag *theTag = (Tag *)obj;
        return ([theTag.name isEqualToString:@"foo"]);
    }];
    
    GHAssertNotEquals(NSNotFound, fooIndex, @"should have found a foo tag");

    NSInteger barIndex = [workThreeTagsArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        Tag *theTag = (Tag *)obj;
        return ([theTag.name isEqualToString:@"bar"]);
    }];
    
    GHAssertNotEquals(NSNotFound, barIndex, @"should have found a bar tag");
    
    // Given the test JSON
    // When I ingest the JSON
    // Then the tag "foo" should have two Works
    // And the tag "bar" should have one Work
    
    NSArray *tagFooArray = [Tag MR_findByAttribute:@"name" withValue:@"foo"];
    int tagFooArrayCount = [tagFooArray count];
    GHAssertEquals(tagFooArrayCount, 1, @"there should be 1 tagFoo, got %d", tagFooArrayCount);
    
    Tag *fooTag = [tagFooArray objectAtIndex:0];
    NSSet *fooWorksSet = fooTag.work;
    int fooWorksCount = [fooWorksSet count];
    GHAssertEquals(fooWorksCount, 2, @"foo should have 2 works, got %d", fooWorksCount);

    NSArray *tagBarArray = [Tag MR_findByAttribute:@"name" withValue:@"bar"];
    int tagBarArrayCount = [tagBarArray count];
    GHAssertEquals(tagBarArrayCount, 1, @"there should be 1 tagBars, got %d", tagFooArrayCount);

    Tag *barTag = [tagBarArray objectAtIndex:0];
    NSSet *barWorksSet = barTag.work;
    int barWorksCount = [barWorksSet count];
    GHAssertEquals(barWorksCount, 1, @"bar should have 1 work, got %d", fooWorksCount);

}

@end
