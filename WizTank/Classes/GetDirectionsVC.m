//
//  GetDirectionsVC.m
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "GetDirectionsVC.h"
#import "MapView.h"
#import "WizTankAppDelegate.h"
#import "DAL.h"

@implementation GetDirectionsVC
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
	blockedCharacters = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
- (void)dealloc {
    [super dealloc];
}
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	if (textField==txt_startLocation) {
		[scrollView setContentOffset:CGPointMake(0.0,40.0) animated:YES];		
	}
	else if(textField==txt_EndLocation){
		[scrollView setContentOffset:CGPointMake(0.0,100.0) animated:YES];	
	}
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
	[textField resignFirstResponder];
	return YES;	
}
- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
	NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "] invertedSet];
	if ([characters isEqualToString:@""]) {
		return YES;
	}
	return ([characters stringByTrimmingCharactersInSet:nonNumberSet].length > 0);		
}
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 
 }*/
#pragma mark IBActions
-(IBAction)btn_Action_back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btn_Action_done
{
	if ([txt_EndLocation.text isEqualToString:@""] || txt_EndLocation.text == nil){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please specify destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}	
	else {
		if ([txt_startLocation.text isEqualToString:@""] || txt_startLocation.text == nil){
			if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized) {
				[self LoadWaitingView];
				[NSThread detachNewThreadSelector:@selector(getRoutes) toTarget:self withObject:nil];
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
																message:@"Please change your Location Services settings to use your current location"
															   delegate:self 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}				
		}
		else {
			[self LoadWaitingView];
			[NSThread detachNewThreadSelector:@selector(getRoutes) toTarget:self withObject:nil];
		}
	}	
}
-(void)getRoutes{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *countryName = @"kuwait";
	NSDictionary*dic ;  //= [DAL getRoutes:txt_startLocation.text:txt_EndLocation.text];
	if ([txt_startLocation.text isEqualToString:@""] || txt_startLocation.text == nil){
		NSString *startinglatLong = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] 
																		 objectForKey:LatitudeKey],[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];
		dic = [DAL getRoutes:startinglatLong :[NSString stringWithFormat:@"%@ %@",txt_EndLocation.text,countryName]];
	}
	else {
	    dic = [DAL getRoutes:txt_startLocation.text:[NSString stringWithFormat:@"%@ %@",txt_EndLocation.text,countryName]];
	}
	[self performSelectorOnMainThread:@selector(RemoveSpinner4RoutesCall:) withObject:dic waitUntilDone:NO];
	[pool release];	
}
-(IBAction)btn_Action_seeOnMap
{
	if([txt_EndLocation.text isEqualToString:@""] ||
	   txt_EndLocation.text == nil){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please specify destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	else {
		if ([txt_startLocation.text isEqualToString:@""] || txt_startLocation.text == nil){
			if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized) {
				[self LoadWaitingView];
				[NSThread detachNewThreadSelector:@selector(getDirections) toTarget:self withObject:nil];
			}
			else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
																message:@"Please change your Location Services settings to use your current location"
															   delegate:self 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}				
		}
		else {
			[self LoadWaitingView];
			[NSThread detachNewThreadSelector:@selector(getDirections) toTarget:self withObject:nil];
		}		
	}
}
-(void)getDirections{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary*dic;
	
//	  NSLocale *locale = [NSLocale currentLocale];
//    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
//    NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
		
	NSString *countryName = @"kuwait";	
	NSLog(@"countryName%@",countryName);
	
	/*
	NSString *localTime = [[NSTimeZone systemTimeZone] description];
	NSString* localTimeComponent = [[localTime componentsSeparatedByString:@" ("] objectAtIndex:0];
	NSArray *leftSide = [localTimeComponent componentsSeparatedByString:@" "];
	NSString *countryName = [leftSide objectAtIndex:[leftSide count]-1];
	NSLog(@"countryName%@",countryName);*/
	
	if ([txt_startLocation.text isEqualToString:@""]){
		NSString *startinglatLong = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] 
																		  objectForKey:LatitudeKey],[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];
		dic = [DAL RequestToGetDirectionsForGivenDestinations:startinglatLong:[NSString stringWithFormat:@"%@ %@",txt_EndLocation.text,countryName]];
	}
	else {
	    dic = [DAL RequestToGetDirectionsForGivenDestinations:[NSString stringWithFormat:@"%@ %@",txt_startLocation.text,countryName]:[NSString stringWithFormat:@"%@ %@",txt_EndLocation.text,countryName]];
	}
	[self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
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
		[txt_startLocation resignFirstResponder];
		[txt_EndLocation resignFirstResponder];
		[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
		NSMutableArray *routesArray=[dic objectForKey:SuccessKey];
		DetailedDirectionVC *detailsVC=[[DetailedDirectionVC alloc] initWithNibName:@"DetailedDirectionVC" bundle:nil];
		detailsVC.routesArray = routesArray;
		if ([txt_startLocation.text isEqualToString:@""] || txt_startLocation.text == nil){		
			NSString *startinglatLong = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] 
																			 objectForKey:LatitudeKey],[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];
			detailsVC.sourceLocation = startinglatLong;
		}
		else {
			detailsVC.sourceLocation = txt_startLocation.text;
		}
		detailsVC.destinationLocation = [NSString stringWithFormat:@"%@ kuwait",txt_EndLocation.text];
		[self.navigationController pushViewController:detailsVC animated:YES];
		[detailsVC release];		
	}
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
		[txt_startLocation resignFirstResponder];
		[txt_EndLocation resignFirstResponder];
		[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
		NSMutableArray *PointsArray=[dic objectForKey:PointsArayForRouteKey];
		MapView *mapView = (MapView*)[MapView loadInstanceFromNib];
		WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)	[[UIApplication sharedApplication] delegate];
		[mapView AddDirectionRoute:PointsArray];
		[mapView addToTransparentView];
		[appDelegate.tabBarController.view addSubview:mapView];
	}
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
