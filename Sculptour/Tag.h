//
//  Tag.h
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Work;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *work;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addWorkObject:(Work *)value;
- (void)removeWorkObject:(Work *)value;
- (void)addWork:(NSSet *)values;
- (void)removeWork:(NSSet *)values;

@end
