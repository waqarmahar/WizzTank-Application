//
//  RouteBO.m
//  WizTank
//
//  Created by Nawaz Mac on 2/28/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import "RouteBO.h"


@implementation RouteBO
@synthesize routeName,distance,duration,steps,direction;

-(void)dealloc{
	[routeName release];
	[distance release];
	[duration release];
	[steps release];
	[direction release];
	[super dealloc];
}
@end
