//
//  PlacesTabItem.m
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "PlacesTabItem.h"
#import "FindPlacesBL.h"
#import "FindPlacesBL.h"
#import "SearchResultsVC.h"
#import "CategoryListView.h"
#import "AdvanceSearchVC.h"
#import "WizTankAppDelegate.h"
#import "CloseBySearchResultVC.h"
#import "AutoCompleteView.h"
#import "LocationDetailVC.h"

@implementation PlacesTabItem

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

#pragma mark View Loading and Unloading Methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	locationFinder = [[CLLocationManager alloc] init];
	locationFinder.desiredAccuracy = kCLLocationAccuracyBest;
	locationFinder.delegate = self; // send loc updates to myself
	blockedCharacters = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];

}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	[locationFinder startUpdatingLocation];	
	
}
-(void)viewDidAppear:(BOOL)animated{

}
- (void)viewWillDisappear:(BOOL)animated{
	//[autoComplete removeFromSuperview];
	txt_SearchBar.text =@"";
}
-(void)viewDidDisappear:(BOOL)animated{
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
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{

	
}
- (void)textFieldDidEndEditing:(UITextField *)textField{

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;	
}

#pragma mark 
#pragma mark Autocomplete
-(void)searchAutoCompleteBusiness{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int catID = -1;
	//NSDictionary *dic=[FindPlacesBL searchPlaces:txt_SearchBar.text:catID];
	//[self performSelectorOnMainThread:@selector(addPlacesTable:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)addPlacesTable:(id)Sender{
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]) {
//		NSError *error=[dic objectForKey:FailureKey];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
//														message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
	}
	else if([dic objectForKey:SuccessKey]) {
		NSMutableArray *autoPlacesArray = [dic objectForKey:SuccessKey];
		autoComplete = (AutoCompleteView*)[AutoCompleteView loadInstanceFromNib];
		WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
		autoComplete.frame =CGRectMake(7.0,159.0,260.0,220.0);
		autoComplete.delegate =self;
		[autoComplete setArrays:autoPlacesArray];
		[appDelegate.tabBarController.view addSubview:autoComplete];
	}		
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([txt_SearchBar.text length] == 1) {
		[NSThread detachNewThreadSelector:@selector(searchAutoCompleteBusiness) toTarget:self withObject:nil];
	}	
	else if ([txt_SearchBar.text length]>1) {
			NSString *substring = [NSString stringWithString:txt_SearchBar.text];
			substring = [substring stringByReplacingCharactersInRange:range withString:string];
			[autoComplete searchAutocompleteEntriesWithSubstring:substring];
			return YES;		
	}
	if (range.length ==1) {
		[autoComplete removeFromSuperview];
	}
	return YES;
}
-(void)psuhtoDeTailsVC:(LocationsBO*)businessObject{
	[txt_SearchBar resignFirstResponder];
	LocationDetailVC *obj=[[LocationDetailVC alloc] initWithNibName:@"LocationDetailVC" bundle:nil];
	obj.placesObjet = businessObject;
	txt_SearchBar.text=@"";
	autoComplete=nil;
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];	
}
#pragma mark  IBActions
-(IBAction) btn_Action_findPlace{
	[autoComplete removeFromSuperview];
	if ([txt_SearchBar.text isEqualToString:@""] || txt_SearchBar.text == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please enter the search phrase and click search button"
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];		
		
	}
	else {
		activityIndicator.hidden=NO;
		[activityIndicator startAnimating];
		txt_SearchBar.enabled=NO;
		btn_find.enabled=NO;
		btn_advancedSearched.enabled=NO;
		btn_browse.enabled=NO;
		btn_closeBy.enabled=NO;
		btn_directions.enabled=NO;
		///set the properties here/////
		[NSThread detachNewThreadSelector:@selector(searchPlaces) toTarget:self withObject:nil];
	}	
}
-(IBAction) btn_Action_advancedSearch{
	AdvanceSearchVC *obj=[[AdvanceSearchVC alloc] initWithNibName:@"AdvanceSearchVC" bundle:nil];
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}
-(IBAction) btn_Action_browse{
	CategoryListView *CategoryView = (CategoryListView*)[CategoryListView loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[CategoryView addToTransparentView];
	[CategoryView performSelectorInBackground:@selector(getCategories) withObject:nil];
	CategoryView.delegate=self;
	[appDelegate.tabBarController.view addSubview:CategoryView];
}
-(IBAction) btn_Action_closeBy{
	if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized) {
		[activityIndicator startAnimating];
		activityIndicator.hidden=NO;
		////Disabling the UIControls/////

		txt_SearchBar.enabled=NO;
		btn_find.enabled=NO;
		btn_advancedSearched.enabled=NO;
		btn_browse.enabled=NO;
		btn_closeBy.enabled=NO;
		btn_directions.enabled=NO;
		[NSThread detachNewThreadSelector:@selector(findNearestPlaces) toTarget:self withObject:nil];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Please first allow the application to use the Location Services"
														delegate:self 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
}
-(IBAction) btn_Action_directions{
	GetDirectionsVC *obj=[[GetDirectionsVC alloc] initWithNibName:@"GetDirectionsVC" bundle:nil];
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}
#pragma mark SearchPlaces
-(void)searchPlaces
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int catID = -1;
	NSDictionary *dic=[FindPlacesBL searchPlaces:txt_SearchBar.text:catID];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)RemoveSpinner4SearchPlacesCall:(id)Sender{	
	[activityIndicator stopAnimating];
	activityIndicator.hidden=YES;
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
		SearchResultsVC *searchVC=[[SearchResultsVC alloc] initWithNibName:@"SearchResultsVC" bundle:nil];
		searchVC.placesArray = placesArray;
		searchVC.isCloseByResults =NO;
		searchVC.searchQuery = txt_SearchBar.text;
		txt_SearchBar.text = @"";
		///set the properties here/////
		[self.navigationController pushViewController:searchVC animated:YES];
		[searchVC release];
	}	
	txt_SearchBar.enabled=YES;
	btn_find.enabled=YES;
	btn_advancedSearched.enabled=YES;
	btn_browse.enabled=YES;
	lbl_findWhats.enabled=YES;
	btn_closeBy.enabled=YES;
	btn_directions.enabled=YES;	
}
#pragma mark CloseBy call
-(void)findNearestPlaces
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL CloseByCall];
		
    [self performSelectorOnMainThread:@selector(RemoveSpinner4CloseByCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)RemoveSpinner4CloseByCall:(id)Sender
{
	[activityIndicator stopAnimating];
	activityIndicator.hidden=YES;
	////Disabling the UIControls/////
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
		SearchResultsVC *searchVC=[[SearchResultsVC alloc] initWithNibName:@"SearchResultsVC" bundle:nil];
		searchVC.placesArray = placesArray;
		searchVC.isCloseByResults =NO;
		searchVC.searchQuery =@"refine";
		///set the properties here/////
		[self.navigationController pushViewController:searchVC animated:YES];
		[searchVC release];	
	}
	txt_SearchBar.enabled=YES;
	btn_find.enabled=YES;
	btn_advancedSearched.enabled=YES;
	btn_browse.enabled=YES;
	lbl_findWhats.enabled=YES;
	btn_closeBy.enabled=YES;
	btn_directions.enabled=YES;	
}
#pragma mark locationFinderDelegates
#pragma -- locationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	//NSLog(@"location updated...");
	//if the time interval returned from core location is more than two minutes we ignore it because it might be from an old session
	
	if ( abs([newLocation.timestamp timeIntervalSinceDate: [NSDate date]]) < 120) {
		//[locationFinder stopUpdatingLocation];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:LongitudeKey];
		[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:LatitudeKey];
	}
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	//NSLog(@"location update failed...");
	//NSLog(@"error:%@", [error description]);
	//[self.locationFinder stopUpdatingLocation];
#ifdef TARGET_IPHONE_SIMULATOR
	// Cupertino
	CLLocation *simulatorLocation = [[CLLocation alloc] initWithLatitude:37.33168900 longitude:-122.03073100];
	//////
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",-122.03073100] forKey:LongitudeKey];
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",37.33168900] forKey:LatitudeKey];
	/////
	[self locationManager:locationFinder didUpdateToLocation:simulatorLocation fromLocation:nil];
	[simulatorLocation release];
#else
	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
	 message:FIND_USER_LOCATION_FAIL_MESSASGE
	   delegate:self 
	  cancelButtonTitle:@"OK" 
	  otherButtonTitles:nil];
	 
	 [alert show];
	 [alert release];
	 */
#endif
}
- (void)dealloc {
	[lbl_upperBarText release];
	[txt_SearchBar release];
	[btn_find release];
	[btn_advancedSearched release];
	[btn_browse release];
	[lbl_findWhats release];
	[btn_closeBy release];
	[lbl_get release];
	[btn_directions release];
	[locationFinder release];
    [super dealloc];
}
#pragma mark CategoryListView delegates
-(void)CategoryName:(int)categoryID{
//	NSLog(@"Cat ID is%i",categoryID);
	NSNumber *catID = [NSNumber numberWithInt:categoryID];
	[NSThread detachNewThreadSelector:@selector(refinePlacesSearch:) toTarget:self withObject:catID];	
}
-(void)refinePlacesSearch:(id)Sender{
	int cateID = [Sender intValue];
//	NSLog(@"cateID%i",cateID);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL searchPlaces:@"refine":cateID];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
@end
