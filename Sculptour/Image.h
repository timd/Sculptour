//
//  Image.h
//  Sculptour
//
//  Created by Tim Duckett on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSManagedObject *work;

@end
