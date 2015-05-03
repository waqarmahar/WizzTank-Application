//
//  SearchPlacesBO.m
//  WizTank
//
//  Created by Nawaz Mac on 2/13/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import "SearchPlacesBO.h"


@implementation SearchPlacesBO
@synthesize businessID,categories,description,email,fax,locations,officialName,phone,thumbnail,website,recommended_By;

-(void) dealloc{
	//[categories release];
	//[description release];
	//[email release];
	[fax release];
	[locations release];
	[officialName release];
	[phone release];
	[thumbnail release];
	[website release];
	[recommended_By release];
	[super dealloc];
}

@end
