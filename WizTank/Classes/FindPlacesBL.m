//
//  FindPlacesBL.m
//  WizTank
//
//  Created by Shafqat on 1/6/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "FindPlacesBL.h"
#import "DAL.h"

@implementation FindPlacesBL

+(NSDictionary *)CloseByCall{
	return [DAL CloseByCall];
}
+(NSDictionary *)searchPlaces:(NSString*)searchQuerry:(int)catID{
	return [DAL searchPlaces:searchQuerry:catID];
}

@end
