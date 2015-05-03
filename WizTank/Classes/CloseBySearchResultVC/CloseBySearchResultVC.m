//
//  CloseBySearchResultVC.m
//  WizTank
//
//  Created by Nawaz Mac on 2/23/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import "CloseBySearchResultVC.h"
#import "LocationDetailVC.h"
#import "WizTankAppDelegate.h"
#import "MapView.h"
#import "FindPlacesBL.h"
#import "SearchPlacesBO.h"
#import "LocationsBO.h"
#import "CloseByBO.h"

@implementation CloseBySearchResultVC
@synthesize tblCell;
@synthesize isCloseByResults,searchquery,placesArray,searchQuery;


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
	if (self.isCloseByResults) {
		txt_upperSearchBar.hidden=YES;
		imgV_uppertextfield.hidden=YES;
		btn_Search.hidden=YES;
	}
	else {
		lbl_upperBarText.hidden=YES;
	}
	lbl_totalCount.text=[NSString stringWithFormat:@"%d results",[self.placesArray count]];	
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
	[searchquery release];
    [super dealloc];
	
}
#pragma mark CategoryListView Delegates
-(void)CategoryName:(int)categoryID{
	NSLog(@"Cat ID is%i",categoryID);
	NSNumber *catID = [NSNumber numberWithInt:categoryID];
	[NSThread detachNewThreadSelector:@selector(refinePlacesSearch:) toTarget:self withObject:catID];
}
-(IBAction) btn_Action_back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) btn_Action_refineSearch
{
	CategoryListView *CategoryView = (CategoryListView*)[CategoryListView loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[CategoryView addToTransparentView];
	[CategoryView performSelectorInBackground:@selector(getCategories) withObject:nil];	
	CategoryView.delegate=self;
	[appDelegate.tabBarController.view addSubview:CategoryView];
	
}
-(IBAction) btn_Action_seeOnMap
{
	MapView *mapView = (MapView*)[MapView loadInstanceFromNib];
	WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
	[mapView addToTransparentView];
	[mapView setMapRegion];	
		AddressAnnotation *addresObj = [[AddressAnnotation alloc]init];
		for (int i=0;i< [self.placesArray count]; i++) {
			CloseByBO *locationObjet = (CloseByBO*)[self.placesArray objectAtIndex:i];
			addresObj.title = locationObjet.str_name;
			addresObj.subtitle = @"nawaz";
			addresObj.coordinate =locationObjet.placeLocation; 
			[mapView addAnnotationView:addresObj];
		}
	[addresObj release];
	[appDelegate.tabBarController.view addSubview:mapView];
}
-(IBAction) btn_Action_Name
{	
	NSArray *array = self.placesArray;
	NSString *name = @"officialName";
	NSSortDescriptor *nameDescriptor =[[[NSSortDescriptor alloc] initWithKey:name ascending:YES
																	selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray * descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	NSArray * sortedArray =
	[array sortedArrayUsingDescriptors:descriptors];
	self.placesArray = [sortedArray mutableCopy];
	[tbl_results reloadData];
	
}
-(IBAction) btn_Action_Distance
{
	LocationsBO *indexObj = (LocationsBO*)[self.placesArray objectAtIndex:0];
	NSLog(@"indexObj is %f",indexObj.distance);
	
	NSArray *array = self.placesArray;
	NSString *name = @"distance";
	NSSortDescriptor *nameDescriptor =[[[NSSortDescriptor alloc] initWithKey:name ascending:YES] autorelease];
	NSArray * descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
	NSArray * sortedArray =
	[array sortedArrayUsingDescriptors:descriptors];
	NSLog(@"Sorted Array count is %i",[array count]);
	self.placesArray = [sortedArray mutableCopy];
	
	LocationsBO *indexObjAfter = (LocationsBO*)[self.placesArray objectAtIndex:0];
	NSLog(@"indexObj after is %f",indexObjAfter.distance);
	
	[tbl_results reloadData];	
	
}
-(IBAction) btn_Action_Search
{
	if ([txt_upperSearchBar.text isEqualToString:@""]|| txt_upperSearchBar.text==nil) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please enter business name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];				
	}
	else {
		[txt_upperSearchBar resignFirstResponder];
		indicator.hidden = NO;
		[indicator startAnimating];
		[NSThread detachNewThreadSelector:@selector(searchPlaces) toTarget:self withObject:nil];
	}
	
}
#pragma mark 
#pragma mark searchPlaces
-(void)searchPlaces
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL searchPlaces:txt_upperSearchBar.text:0];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)refinePlacesSearch:(id)Sender{
	int cateID = [Sender intValue];
	NSLog(@"cateID%i",cateID);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[FindPlacesBL searchPlaces:self.searchQuery:cateID];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4SearchPlacesCall:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)RemoveSpinner4SearchPlacesCall:(id)Sender{	
	[indicator stopAnimating];
	indicator.hidden=YES;
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]) {
		NSError *error=[dic objectForKey:@"error"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if([dic objectForKey:SuccessKey]) {
		NSMutableArray *searchResult=[dic objectForKey:SuccessKey];
		NSLog(@"searchResult is %i",[searchResult count]);
		lbl_totalCount.text=[NSString stringWithFormat:@"%i results",[searchResult count]];
		self.placesArray = searchResult;
		[tbl_results reloadData];
	}	
}
#pragma mark -
#pragma mark UITableView Delegate and Datasource Methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	/*	if (!isCloseByResults) {
	 return	[self.placesArray count];
	 }
	 else {*/
	return 1;
	//	}
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	/*	if (!isCloseByResults) {
	 SearchPlacesBO *places = (SearchPlacesBO*)[self.placesArray objectAtIndex:section];	
	 return [places.locations count];	
	 }
	 else {*/
	return [self.placesArray count];
	//	}
	
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"CloseByCustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CloseByCustomCell" owner:self options:nil];
		cell = tblCell;
		self.tblCell = nil;
	}
	if (!isCloseByResults) {
		LocationsBO  *locations = (LocationsBO *)[self.placesArray objectAtIndex:indexPath.row];
		SearchPlacesBO *businessOBJ = locations.businessObject;
		UILabel *lblName = (UILabel*)[cell.contentView viewWithTag:311];
		lblName.text = businessOBJ.officialName;
		UILabel *lblDistance = (UILabel*)[cell.contentView viewWithTag:113];
		lblDistance.text = [NSString stringWithFormat:@"%.2f km",locations.distance];
	}
	else {
		CloseByBO  *closeBy = (CloseByBO *)[self.placesArray objectAtIndex:indexPath.row];	
		lbl_Name.text = closeBy.str_name;
		lbl_Location.text = closeBy.str_vicinity;
		lbl_Distance.text = [NSString stringWithFormat:@"%f",closeBy.f_distance];
	}	
	UIButton *btn_Photo=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_Photo.frame=CGRectMake(0,0,20,22);
	btn_Photo.tag=indexPath.row;
	btn_Photo.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
	btn_Photo.titleLabel.hidden=YES;
	[btn_Photo setBackgroundImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateNormal];
	[btn_Photo addTarget:self action:@selector(AccesoryViewButtonPressed:)  forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView=btn_Photo;
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	/////////////
	return cell;
}
-(void)AccesoryViewButtonPressed:(id)Sender{
	UIButton *btn=(UIButton *)Sender;
	NSLog(@"button tag is %d",btn.tag);
	NSLog(@"button title is %@",btn.titleLabel.text);
	LocationDetailVC *obj=[[LocationDetailVC alloc] initWithNibName:@"LocationDetailVC" bundle:nil];
	obj.placesObjet = [self.placesArray objectAtIndex:btn.tag];
	//obj.locationDetailsIndex = [btn.titleLabel.text intValue]; 
	[self.navigationController pushViewController:obj animated:YES];
	[obj release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{");
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



@end
