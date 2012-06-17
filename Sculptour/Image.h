//
//  Image.h
//  Sculptour
//
//  Created by Tim Duckett on 17/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Work;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * userGenerated;
@property (nonatomic, retain) Work *work;

@end
