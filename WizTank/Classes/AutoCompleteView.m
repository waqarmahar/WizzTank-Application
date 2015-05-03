//
//  AutoCompleteView.m
//  WizTank
//
//  Created by Nawaz Mac on 3/16/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import "AutoCompleteView.h"
#import "SearchPlacesBO.h"
#import "LocationDetailVC.h"

@implementation AutoCompleteView
@synthesize /*cacheArray,*/placesArray,businessObjects,delegate;

+(UIView*) loadInstanceFromNib {
    UIView *result = nil;
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    return result;
}
-(void)setArrays:(NSMutableArray*)businessesArray{

	cacheArray = businessesArray;
//	NSLog(@"cacheArray%i",cacheArray.count);
//	LocationsBO *obj = (LocationsBO*)[cacheArray objectAtIndex:0];
//	NSLog(@"BsusineesName%@",obj.officialName);
}
#pragma mark 
#pragma mark TableViewDelegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	//NSLog(@"self.cacheArray Count %i",[cacheArray count]);
	return [cacheArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] autorelease];
	}
	LocationsBO *businessObject = (LocationsBO*)[cacheArray objectAtIndex:indexPath.row];
	cell.textLabel.text = businessObject.officialName;
//	cell.textLabel.text = (NSString*)[cacheArray objectAtIndex:indexPath.row];
	return cell;	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	LocationsBO *businessObject = [cacheArray objectAtIndex:indexPath.row];
	[delegate psuhtoDeTailsVC:businessObject];
    [self removeFromSuperview];	
}
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
//	NSLog(@"substring%@",substring);
//	self.placesArray = cacheArray;
/*	for (int i =0; i<[self.placesArray count]; i++) {
		NSString *curString = [[self.placesArray objectAtIndex:i] lowercaseString]; 
		NSRange substringRange = [curString rangeOfString:[substring lowercaseString]];
		if (substringRange.location == NSNotFound) 
		{
			[cacheArray removeObjectAtIndex:i];
		}
		else {
		}
	}	
	*/
	NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"officialName contains[cd] %@", substring];
	[cacheArray filterUsingPredicate:sPredicate];
	[tbl_businesses reloadData];
}
-(void)dealloc{
	[super dealloc];
}
@end
