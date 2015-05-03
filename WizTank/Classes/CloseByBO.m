//
//  CloseByBO.m
//  WizTank
//
//  Created by Shafqat on 1/6/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "CloseByBO.h"


@implementation CloseByBO

@synthesize str_name;
@synthesize str_vicinity;
@synthesize placeLocation;
@synthesize f_distance;

-(void)dealloc
{
	[str_name release];
	[str_vicinity release];
	
	[super dealloc];
}

- (NSComparisonResult) compareByName:(CloseByBO*) record
{    
	return [self.str_name compare:record.str_name];
}
- (NSComparisonResult) compareByLocation:(CloseByBO*) record
{    
	return [self.str_vicinity compare:record.str_vicinity];
}
- (NSComparisonResult) compareByDistance:(CloseByBO*) record
{    
	//return [self.f_distance compare:record.f_distance];
	if (self.f_distance < record.f_distance) {
		return NSOrderedAscending;
	}
	else if(self.f_distance==record.f_distance){
		return	 NSOrderedSame;
	}
	else {
		return  NSOrderedDescending;
	}

	
}
@end
