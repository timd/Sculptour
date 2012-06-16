//
//  SculptourTests.m
//  SculptourTests
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "SculptourTests.h"
#import "Work.h"
#import "Image.h"
#import "CMDataCreater.h"

@implementation SculptourTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
   	[MagicalRecord setDefaultModelFromClass:[self class]];
	[MagicalRecord setupCoreDataStackWithInMemoryStore];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    [MagicalRecord cleanUp];
    
}

- (void)testExample
{

    Work *testWork = [Work MR_createEntity];
    testWork.artist = @"Foo";
    STAssertNotNil(testWork, @"testWork is nil, shouldn't be");
    
}

@end
