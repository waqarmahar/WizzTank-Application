//
//  GroupsBL.m
//  WizTank
//
//  Created by Shafqat on 2/10/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "GroupsBL.h"


@implementation GroupsBL

+(NSDictionary *)SearchPeopleInBubble:(NSString *)searchText
{
	return [DAL SearchPeopleInBubble:searchText];	
}
+(NSDictionary *)UnfollowPerson:(NSString *)uID isFollow:(int)value{
	return [DAL UnfollowPerson:uID isFollow:value];
}
+(NSDictionary *)PplIamFollowing{
	return [DAL PplIamFollowing];
}
+(NSDictionary *)PplFollowingMe{
	return [DAL PplFollowingMe];	
}
+(NSDictionary *)MyFavorites{
	return [DAL MyFavorites];
}
+(NSDictionary *)MyRecommendations{
	return [DAL MyRecommendations];	
}
@end
