//
//  FavoriteBO.m
//  WizTank
//
//  Created by Shafqat on 2/27/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "FavoriteBO.h"


@implementation FavoriteBO

@synthesize str_areaName;
@synthesize str_bussinessId;
@synthesize str_bussinessName;
@synthesize str_locationId;


-(void)dealloc{
	[str_areaName release];
	[str_bussinessId release];
	[str_bussinessName release];
	[str_locationId release];
	[super dealloc];	
}
@end
