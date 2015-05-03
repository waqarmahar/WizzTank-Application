//
//  CategoryListBO.m
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "CategoryListBO.h"


@implementation CategoryListBO

@synthesize categoryID;
@synthesize str_name;
@synthesize subCategoriesList;

-(id) init{
		
	if ([super init]) {
		subCategoriesList=[[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc{
	[str_name release];
	[subCategoriesList release];
	
	[super dealloc];
}

@end
