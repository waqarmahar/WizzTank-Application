//
//  DetailedDirectionVC.m
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "DetailedDirectionVC.h"
#import "MapView.h"
#import "WizTankAppDelegate.h"
#import "RouteBO.h"
#import "DAL.h"
#import "WaitingView.h"
#import "FindPlacesBL.h"

@implementation DetailedDirectionVC

@synthesize tbl_Cell,routesArray,selectedIndex,sourceLocation,destinationLocation,delegate;

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
	self.selectedIndex = 0;
}
- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [tbl_routes selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
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
#pragma mark -
#pragma mark UITableView Delegate and Datasource Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView==tbl_routesDetails) 
	{
		RouteBO *routeObject = (RouteBO*)[self.routesArray objectAtIndex:self.selectedIndex];
		RouteBO *obj  = (RouteBO*)[routeObject.steps objectAtIndex:indexPath.row];
		CGSize size = [obj.direction sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f]
									 constrainedToSize:CGSizeMake(260,300)
										 lineBreakMode:UILineBreakModeWordWrap];
		if (size.height == 0) {
			size.height = 20.0;
		}
		//NSLog(@"size.height%f",size.height);
		return size.height+10.0;
	}
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	if (tableView==tbl_routes) {
		tbl_routesDetails.delegate=self;
		tbl_routesDetails.dataSource=self;
		return [self.routesArray count];
		
	}
	else if(tableView==tbl_routesDetails) {
		RouteBO *obj = (RouteBO*)[self.routesArray objectAtIndex:self.selectedIndex];
		return [obj.steps count];
	}
	else {
		return 0;	
	}
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView==tbl_routes) {
		RouteBO *routeObject = (RouteBO*)[self.routesArray objectAtIndex:indexPath.row];
		static NSString *MyIdentifier = @"CustomCell4DetailedDirections";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"CustomCell4DetailedDirections" owner:self options:nil];
			cell = self.tbl_Cell;
			self.tbl_Cell = nil;
			UILabel *lblName = (UILabel*)[cell.contentView viewWithTag:511];
			lblName.text = routeObject.routeName;
			UILabel *distance = (UILabel*)[cell.contentView viewWithTag:512];
			distance.text = routeObject.distance;
			UILabel *lblDuration = (UILabel*)[cell.contentView viewWithTag:513];
			lblDuration.text = routeObject.duration;
		}
		cell.selectionStyle=UITableViewCellSelectionStyleGray;		
		return cell;
	}
	else if(tableView==tbl_routesDetails) {
		RouteBO *routeObject = (RouteBO*)[self.routesArray objectAtIndex:self.selectedIndex];
		static NSString *MyIdentifier = @"CustomCell4RouteSteps";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil){
		[[NSBundle mainBundle] loadNibNamed:@"CustomCell4RouteSteps" owner:self options:nil];
		cell = self.tbl_Cell;
		self.tbl_Cell = nil;
		}
		UILabel *step = (UILabel*)[cell.contentView viewWithTag:611];
		RouteBO *obj  = (RouteBO*)[routeObject.steps objectAtIndex:indexPath.row];
		NSString *routeStep = [obj.direction stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
		step.text = routeStep;
		[step setFont:[UIFont fontWithName:@"Helvetica" size:17.0f]];
		
		CGSize size = [obj.direction sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f]
								constrainedToSize:CGSizeMake(260,300)
									lineBreakMode:UILineBreakModeWordWrap];
		if (size.height == 0) {
			size.height = 20.0;
		}
		step.frame = CGRectMake(step.frame.origin.x, step.frame.origin.y,step.frame.size.width,size.height);
		return cell;
	}
	return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (tableView==tbl_routes) {
		self.selectedIndex = indexPath.row;
		[tbl_routesDetails reloadData];	
	}
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
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 
 }*/
#pragma mark IBActions
-(IBAction)btn_Action_back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btn_Action_search
{
	if ([txt_searchfield.text isEqualToString:@""]|| txt_searchfield.text==nil) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please enter business name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];				
	}
	else {
		[txt_searchfield resignFirstResponder];
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(searchPlaces) toTarget:self withObject:nil];
	}		
}
#pragma mark 
#pragma mark searchPlaces
-(void)searchPlaces
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL searchPlaces:txt_searchfield.text:-1];
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
		[delegate reloadPlaces:placesArray];
		NSArray *array = [self.navigationController viewControllers];
		UIViewController    *requiredVC = [DetailedDirectionVC getRequiredViewControllerFromStack:array nibName:@"SearchResultsVC"];
		if (requiredVC) {
			[self.navigationController popToViewController:requiredVC animated:NO];
		}
	}		
}
//////
+(UIViewController*)getRequiredViewControllerFromStack:(NSArray*)viewControllers nibName:(NSString*)requiredNibName{
	UIViewController    *requiredVC = nil;
	for (requiredVC in viewControllers) {
		if ([requiredVC.nibName isEqualToString:requiredNibName]) {
			break;
		}
	}
	return requiredVC;
}
-(IBAction)btn_Action_reportAnIssue
{
	ReportAnIssue *obj = (ReportAnIssue*)[ReportAnIssue loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[obj addToTransparentView];
	obj.delegate=self;
	[appDelegate.tabBarController.view addSubview:obj];
}

-(IBAction)btn_Action_seeOnMap
{
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(getDirections) toTarget:self withObject:nil];	
}
-(void)getDirections{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary*dic = [DAL RequestToGetDirectionsForGivenDestinations:self.sourceLocation:self.destinationLocation];
	[self performSelectorOnMainThread:@selector(RemoveSpinner4DirectionCall:) withObject:dic waitUntilDone:NO];
	[pool release];
}
-(void)RemoveSpinner4DirectionCall:(id)Sender{	
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
		NSMutableArray *PointsArray=[dic objectForKey:PointsArayForRouteKey];
		MapView *mapView = (MapView*)[MapView loadInstanceFromNib];
		WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)	[[UIApplication sharedApplication] delegate];
		[mapView AddDirectionRoute:PointsArray];
		[mapView addToTransparentView];
		[appDelegate.tabBarController.view addSubview:mapView];
	}	
}	

#pragma mark issue Delegates
-(void)IssueText:(NSString *)txt
{
	NSLog(@"issue is %@",txt);	
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
