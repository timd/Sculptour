//
//  NSArray-Set.h
//
//  Created by Michael Dales on 17/01/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray(Set) 

+ (id)arrayByOrderingSet: (NSSet *)set 
				   byKey: (NSString *)key 
			   ascending: (BOOL)ascending;

@end
