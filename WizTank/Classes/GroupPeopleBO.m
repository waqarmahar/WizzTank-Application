//
//  GroupPeopleBO.m
//  WizTank
//
//  Created by Shafqat on 2/10/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "GroupPeopleBO.h"


@implementation GroupPeopleBO

@synthesize str_countryName;
@synthesize str_fName;
@synthesize str_gender;
@synthesize str_imgPath;
@synthesize str_lName;
@synthesize str_userID;
@synthesize isFollowing;

-(void)dealloc{
	
	[str_countryName release];
	[str_fName release];
	[str_gender release];
	[str_imgPath release];
	[str_lName release];
	[str_userID release];
	[super dealloc];
}

@end
