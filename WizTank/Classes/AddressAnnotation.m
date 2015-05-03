//
//  AddressAnnotation.m
//  iCarpool
//
//  Created by Aasim Naseem Siddiqui on 12/6/10.
//  Copyright 2010 GenITeam. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation
@synthesize coordinate,title,subtitle;

-(void)dealloc{
	[title release];
	[subtitle release];
	[super dealloc];
}
@end
