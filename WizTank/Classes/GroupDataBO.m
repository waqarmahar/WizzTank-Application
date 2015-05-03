//
//  GroupDataBO.m
//  WizTank
//
//  Created by Shafqat on 2/13/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "GroupDataBO.h"


@implementation GroupDataBO

@synthesize arr_PplFollowingMe;
@synthesize arr_PplMeFollowing;
@synthesize arr_Recommendations;
@synthesize arr_Favorites;

//+ (GroupDataBO *)Getinstance
//{
//	@synchronized(self)
//    {
//		if (obj_GroupData == NULL){
//			obj_GroupData = [[self alloc] init];
//			obj_GroupData.arr_PplFollowingMe=[[NSMutableArray alloc] init];
//			obj_GroupData.arr_PplMeFollowing=[[NSMutableArray alloc] init];
//			obj_GroupData.arr_Recommendations=[[NSMutableArray alloc] init];
//			obj_GroupData.arr_Favorites=[[NSMutableArray alloc] init];
//		}
//    }
//	return(obj_GroupData);
//}
-(id) init{
	
	arr_PplFollowingMe=[[NSMutableArray alloc] init];
	arr_PplMeFollowing=[[NSMutableArray alloc] init];
	arr_Recommendations=[[NSMutableArray alloc] init];
	arr_Favorites=[[NSMutableArray alloc] init];
	return self;
}
-(void)dealloc
{
	[arr_PplFollowingMe release];
	[arr_PplMeFollowing release];
	[arr_Recommendations release];
	[arr_Favorites release];
	
	[super dealloc];
}

@end
