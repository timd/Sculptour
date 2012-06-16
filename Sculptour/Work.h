//
//  Work.h
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface Work : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * material;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * collected;
@property (nonatomic, retain) NSNumber * internal;
@property (nonatomic, retain) NSSet *images;
@end

@interface Work (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
