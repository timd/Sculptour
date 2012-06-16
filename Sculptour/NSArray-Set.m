//
//  NSArray-Set.m
//
//  Created by Michael Dales on 17/01/2010.
//  Copyright 2010 Michael Dales. All rights reserved.
//

#import "NSArray-Set.h"


@implementation NSArray(Set) 


+ (id)arrayByOrderingSet: (NSSet *)set 
				   byKey: (NSString *)key 
			   ascending: (BOOL)ascending 
{
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[set count]]; 
	for (id oneObject in set)
		[ret addObject: oneObject];
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey: key 
															   ascending: ascending];
	[ret sortUsingDescriptors: [NSArray arrayWithObject: descriptor]]; 
	
	return ret;
} 


@end
