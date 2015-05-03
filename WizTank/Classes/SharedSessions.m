//
//  SharedSessions.m
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "SharedSessions.h"
#import "DAL.h"
SharedSessions *SharedSessionsInstance;

@implementation SharedSessions

@synthesize categoryList;

+(SharedSessions *) GetInstance{
	@synchronized(self)
    {
		if (SharedSessionsInstance == NULL){
			SharedSessionsInstance = [[self alloc] init];
			SharedSessionsInstance.categoryList=[[NSMutableArray alloc] init];
			
		}
    }
	return(SharedSessionsInstance);
}
-(void)dealloc{
	[SharedSessionsInstance release];
	[categoryList release];
	
	[super dealloc];
}
-(NSMutableArray *)GetCategoriesList{
	[self UpdateCategoryList];	
	return self.categoryList;
}
-(void)UpdateCategoryList{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSDictionary *catDictionary  = [DAL getCategoriesList];	
	if ([catDictionary objectForKey:FailureKey]) {
		NSError *error=[catDictionary objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([catDictionary objectForKey:SuccessKey]) {
		NSMutableArray*categories = [catDictionary objectForKey:SuccessKey];
		if ([categories count]>1) {
			self.categoryList = categories;
		}
	}
	[pool drain];
}

@end
