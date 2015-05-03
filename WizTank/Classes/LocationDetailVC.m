//
//  LocationDetailVC.m
//  WizTank
//
//  Created by Shafqat on 1/17/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "LocationDetailVC.h"
#import "MapView.h"
#import "DetailedDirectionVC.h"
#import "WizTankAppDelegate.h"
#import "RecommendedByBO.h"
#import "CategoryListBO.h"
#import "LocationsBO.h"
#import "DAL.h"
#import "SearchResultsVC.h"
#import "FindPlacesBL.h"

@implementation LocationDetailVC

@synthesize tbl_cell,placesObjet,destinationLocation,delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	scrollView.contentSize=CGSizeMake(320,[placesObjet.businessObject.locations count]*50.0+370.0);
	tbl_branches.frame=CGRectMake(tbl_branches.frame.origin.x,
								  tbl_branches.frame.origin.y,
								  tbl_branches.frame.size.width,
								  [placesObjet.businessObject.locations count]*50.0);
	[tbl_branches setBounces:YES];
	FavoriteORrecommend=-1;
	blockedCharacters = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];
}
-(void)viewWillAppear:(BOOL)animated{
		NSString *recommendedBy = nil;
		NSString *categroies = nil; 
		lbl_ProductName.text = self.placesObjet.officialName;
		recommendedBy = self.placesObjet.recommendedBy;
		lbl_recommendedBy.text = recommendedBy;
		NSArray* components = [self.placesObjet.recommendedBy componentsSeparatedByString:@","];
		if ([self.placesObjet.recommendedBy isEqualToString:@""]) {
			lbl_recommendedCount.text = [NSString stringWithFormat:@"0"];
		}
		else {
			lbl_recommendedCount.text = [NSString stringWithFormat:@"%i",[components count]];	
		}
		for (int j = 0; j<[self.placesObjet.businessObject.categories count]; j++) {
			CategoryListBO *categoryList = (CategoryListBO*)[self.placesObjet.businessObject.categories objectAtIndex:j];
			categroies =  categoryList.str_name;
			[categroies stringByAppendingFormat:@" > %@" ,categroies];
		}
		lbl_categoryType.text = categroies; 	
		lbl_webAddress.text = placesObjet.businessObject.website;
		btn_contact.titleLabel.text = [NSString stringWithFormat:@"Ph: %@",placesObjet.phone];
		lbl_webAddress.text = [NSString stringWithFormat:@"Web:%@",placesObjet.businessObject.website];
		if ([placesObjet.phone isEqualToString:@"(null)"]) {
			lbl_contact.text = [NSString stringWithFormat:@"Ph:"];
		}
		else {
			lbl_contact.text = [NSString stringWithFormat:@"Ph:%@",placesObjet.phone];
		}

}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark dealloc
- (void)dealloc {
	[destinationLocation release];
	[placesObjet release];
	[tbl_cell release];
    [super dealloc];
}
#pragma mark table Delegates
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	return [placesObjet.businessObject.locations count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *MyIdentifier = @"LocationDetailCustomCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LocationDetailCustomCell" owner:self options:nil];
		cell = self.tbl_cell;
		self.tbl_cell = nil;
	}
	LocationsBO  *locationOBJ = (LocationsBO *)[placesObjet.businessObject.locations objectAtIndex:indexPath.row];	
	UILabel *lblName = (UILabel*)[cell.contentView viewWithTag:211];
	lblName.text = locationOBJ.area;
	
	UILabel *lblDistance = (UILabel*)[cell.contentView viewWithTag:212];
	lblDistance.text = [NSString stringWithFormat:@"%.1f km",locationOBJ.distance];
		
	UIButton *btn_getDirection=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_getDirection.frame=CGRectMake(160,8,75,38);
	btn_getDirection.tag=indexPath.row;
	[btn_getDirection setBackgroundImage:[UIImage imageNamed:@"btn_getDirections.png"] forState:UIControlStateNormal];
	[btn_getDirection setBackgroundImage:[UIImage imageNamed:@"btn_getDirectionsSelected.png"] forState:UIControlStateSelected];
	[btn_getDirection setBackgroundImage:[UIImage imageNamed:@"btn_getDirectionsSelected.png"] forState:UIControlStateHighlighted];
	
	[btn_getDirection addTarget:self action:@selector(btn_Action_GetDirection:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:btn_getDirection];
	///////////////////////////////////////////////////
	UIButton *btn_SeeOnMap=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_SeeOnMap.frame=CGRectMake(240,8,75,38);
	btn_SeeOnMap.tag=indexPath.row;
	[btn_SeeOnMap setBackgroundImage:[UIImage imageNamed:@"btn_seeOnMap2.png"] forState:UIControlStateNormal];
	[btn_SeeOnMap setBackgroundImage:[UIImage imageNamed:@"btn_seeOnMap_Selected2.png"] forState:UIControlStateSelected];
	[btn_SeeOnMap setBackgroundImage:[UIImage imageNamed:@"btn_seeOnMap_Selected2.png"] forState:UIControlStateHighlighted];
	[btn_SeeOnMap addTarget:self action:@selector(btn_Action_SeeOnMap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:btn_SeeOnMap];
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	return cell;	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}
#pragma mark
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;	
}
#pragma mark IBActions
-(IBAction)btn_Action_GetDirection:(id)sender
{	
	[self LoadWaitingView];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"index",nil];
	[NSThread detachNewThreadSelector:@selector(getRoutes:) toTarget:self withObject:dict];
}
-(void)getRoutes:(NSDictionary*)sender{
	UIButton *btn = [sender objectForKey:@"index"];
	LocationsBO *location = (LocationsBO*)[placesObjet.businessObject.locations objectAtIndex:btn.tag];
	self.destinationLocation = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *startinglatLong = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] 
																		objectForKey:LatitudeKey],[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];
	
	NSDictionary*dic = [DAL getRoutes:startinglatLong:self.destinationLocation];
	[self performSelectorOnMainThread:@selector(RemoveSpinner4RoutesCall:) withObject:dic waitUntilDone:NO];
	[pool release];	
}
-(void)RemoveSpinner4RoutesCall:(id)Sender{	
	[self UnLoadWaitingView];
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]){
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	else if ([dic objectForKey:SuccessKey]) {
		NSMutableArray *routesArray=[dic objectForKey:SuccessKey];
				DetailedDirectionVC *detailsVC=[[DetailedDirectionVC alloc] initWithNibName:@"DetailedDirectionVC" bundle:nil];
				detailsVC.routesArray = routesArray;
				NSString *startinglatLong = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] 
																						objectForKey:LatitudeKey],[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];
				detailsVC.sourceLocation = startinglatLong;
				detailsVC.delegate =self.delegate;
				detailsVC.destinationLocation = self.destinationLocation;
				[self.navigationController pushViewController:detailsVC animated:YES];
				[detailsVC release];
		
	}
}	
-(IBAction)btn_Action_SeeOnMap:(id)sender
{
	UIButton *btn=(UIButton *)sender;
	//NSLog(@"button tag is %d",btn.tag);
	MapView *mapView = (MapView*)[MapView loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[mapView addToTransparentView];
	[mapView setMapRegion];
	LocationsBO *location = (LocationsBO*)[placesObjet.businessObject.locations objectAtIndex:btn.tag];
	AddressAnnotation *addressObj = [[AddressAnnotation alloc] init];
	addressObj.title = location.officialName;
	addressObj.subtitle = location.area;
	CLLocationCoordinate2D location2D;
	location2D.latitude = location.latitude;
	location2D.longitude = location.longitude;
	addressObj.coordinate = location2D;
	[mapView addAnnotationView:addressObj];
	[addressObj release];
	[appDelegate.tabBarController.view addSubview:mapView];
}
-(IBAction)btn_Action_back
{
	[self.navigationController popViewControllerAnimated:YES];	
}
-(IBAction)btn_Action_Search
{
	if ([txt_searchField.text isEqualToString:@""]|| txt_searchField.text==nil) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please enter business name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];				
	}
	else {
		[txt_searchField resignFirstResponder];
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(searchPlaces) toTarget:self withObject:nil];
	}	
}
-(IBAction)btn_Action_addToFavorites
{
	[self LoadWaitingView];
	[NSThread detachNewThreadSelector:@selector(addTofavorite) toTarget:self withObject:nil];
}
-(IBAction)btn_Action_reportAnIusse
{
	ReportAnIssue *obj = (ReportAnIssue*)[ReportAnIssue loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[obj addToTransparentView];
	obj.delegate=self;
	[appDelegate.tabBarController.view addSubview:obj];
}
-(IBAction)btn_Action_recommend
{	
	[self LoadWaitingView];
	[NSThread detachNewThreadSelector:@selector(recommendLocation) toTarget:self withObject:nil];
}
-(IBAction)btn_Action_share
{
	
}
-(IBAction)btn_Action_callNumber
{
	
}
-(IBAction)btn_Action_SortOnLocation
{
	NSArray *array = self.placesObjet.businessObject.locations;
	NSString *name = @"area";
	NSSortDescriptor *nameDescriptor =[[[NSSortDescriptor alloc] initWithKey:name ascending:YES
																	selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray * descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	NSArray * sortedArray =
	[array sortedArrayUsingDescriptors:descriptors];
	self.placesObjet.businessObject.locations = [sortedArray mutableCopy];	
	[tbl_branches reloadData];		
}
-(IBAction)btn_Action_SortOnDistance
{
	NSArray *array = self.placesObjet.businessObject.locations;
	NSString *name = @"distance";
	NSSortDescriptor *nameDescriptor =[[[NSSortDescriptor alloc] initWithKey:name ascending:YES] autorelease];
	NSArray * descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	NSArray * sortedArray =
	[array sortedArrayUsingDescriptors:descriptors];
	self.placesObjet.businessObject.locations = [sortedArray mutableCopy];	
	[tbl_branches reloadData];		
	
}
#pragma mark 
#pragma mark searchPlaces
-(void)searchPlaces
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL searchPlaces:txt_searchField.text:-1];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)RemoveSpinner4SearchPlacesCall:(id)Sender{	
	[self UnLoadWaitingView];
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]) {
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([dic objectForKey:SuccessKey]) {
		NSMutableArray *placesArray=[dic objectForKey:SuccessKey];
//		delegate.placesArray = placesArray;
//		delegate.isCloseByResults =NO;
//		delegate.searchQuery =txt_searchField.text; 	
		[delegate reloadPlaces:placesArray];
		[self.navigationController popViewControllerAnimated:YES];
	}		
}
#pragma mark addToFavourite
-(void)addTofavorite{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int locationID = self.placesObjet.locationId;
	NSDictionary *dic=[DAL addToFavorites:locationID];
	FavoriteORrecommend=1;
	[self performSelectorOnMainThread:@selector(RemoveSpinnerForFavoriteCall:) withObject:dic waitUntilDone:NO];
	[pool release];	

}
-(void)recommendLocation{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int locationID = self.placesObjet.locationId;
	NSDictionary *dic=[DAL recommendLocation:locationID];
	FavoriteORrecommend=2;
	[self performSelectorOnMainThread:@selector(RemoveSpinnerForFavoriteCall:) withObject:dic waitUntilDone:NO];
	[pool release];	
}
-(void)RemoveSpinnerForFavoriteCall:(id)Sender{	
	[self UnLoadWaitingView];
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([[dic objectForKey:@"status"] isEqualToString:FailureKey]) {
		NSString *message = [(NSError*)[dic objectForKey:@"error"] localizedDescription];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([[dic objectForKey:@"status"] isEqualToString:SuccessKey]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" 
														message:[dic objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		////////////////////////////////////////////////////////
		if (FavoriteORrecommend==1) {
			NSDictionary *dic=[NSDictionary dictionaryWithObject:self.placesObjet forKey:@"favorite"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteOrRecommended" object:dic];	
		}
		else if(FavoriteORrecommend==2){
			NSDictionary *dic=[NSDictionary dictionaryWithObject:self.placesObjet forKey:@"recommend"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteOrRecommended" object:dic];
		}
		////////////////////////////////////////////////////////
		FavoriteORrecommend=-1;
	}		
}
#pragma mark delegate Methods
-(void)IssueText:(NSString *)txt
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self LoadWaitingView];
	int locationID = self.placesObjet.locationId;
	NSDictionary *dic=[DAL reportAnIssue:locationID:txt];	
	[self performSelectorOnMainThread:@selector(RemoveSpinnerForFavoriteCall:) withObject:dic waitUntilDone:NO];
	[pool release];	
	
}
#pragma mark OverLayView
-(void)LoadWaitingView{
	_waitingView = (WaitingView*)[WaitingView loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[_waitingView startAnimation];
	[appDelegate.tabBarController.view addSubview:_waitingView];	
}
-(void)UnLoadWaitingView{
	[_waitingView removeOverlayView];
	_waitingView=nil;	
}
@end
