//
//  MyTest.m
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
#import "Work.h"
#import "Image.h"

#import "CMDataCreater.h"

@interface CoreDataTest : GHTestCase { }
@end

@implementation CoreDataTest

-(void)setUp {
    
    [MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
    
}

-(void)tearDown {
    
    [MagicalRecord cleanUp];
}

-(void)testCoreData {
    /*
    Work *newWork = [Work createEntity];
    GHAssertNotNil(newWork, @"is nil, shouldn't be");
    
    Image *newImage = [Image createEntity];
    GHAssertNotNil(newImage, @"is nil, shouldn't be");
    */
}

-(void)testSeedData {
    
    CMDataCreater *dataCreater = [[CMDataCreater alloc] init];
    
    NSArray *allWorks = [Work MR_findAll];
    
    int resultsCount = [allWorks count];
    GHAssertEquals(resultsCount, 0, @"should be 0");
    
    [dataCreater createDummyData];
    
    NSArray *nextResults = [Work MR_findAll];
    int nextCount = [nextResults count];
    GHAssertEquals(nextCount, 10, @"should be 10 elements, got %d", nextCount);
    
}

@end
