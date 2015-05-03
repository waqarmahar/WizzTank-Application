//
//  GroupsBarItem.m
//  WizTank
//
//  Created by Shafqat on 1/18/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "GroupsBarItem.h"
#import "WizTankAppDelegate.h"
#import "GroupPeopleBO.h"
#import "AsyncImageView.h"
@implementation GroupsBarItem

@synthesize tbl_cellFavorites,tbl_cellFollowers;
@synthesize str_SearchPeopleText;
@synthesize SearchPeopleResults;
@synthesize PressedButtonIndex;
@synthesize obj_SharedGroupData;

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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.view=nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"logout"
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"FavoriteOrRecommended"
												  object:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	btnSelected = 0;
	btn_back.hidden = YES;
	[btn_meFollowing setHighlighted:YES];
	lbl_SearchResults.hidden = YES;
	isSearchResultScreen = NO;
	lbl_heading.text=@"People I am Following";
	numberOfRows4Table=0;
	self.obj_SharedGroupData=[[GroupDataBO alloc] init];
	////////Call for people I am following////////
	
	
	[self btn_Action_meFollowing];
	isLoadingFirstTime=YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleFavoriteOrRecommended:) name:@"FavoriteOrRecommended" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallviewDidUnload) name:@"logout" object:nil];
	/////////////////////////////////////////////
}
-(void) CallviewDidUnload{
	
	[self.SearchPeopleResults removeAllObjects];
	[self.obj_SharedGroupData.arr_Favorites removeAllObjects];
	[self.obj_SharedGroupData.arr_Recommendations removeAllObjects];
	[self.obj_SharedGroupData.arr_PplFollowingMe removeAllObjects];
	[self.obj_SharedGroupData.arr_PplMeFollowing removeAllObjects];
	///////////////////////////////////////
	
	 [self viewDidUnload];
	
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


#pragma mark dealloc
- (void)dealloc {
    
	[obj_SharedGroupData release];
	[SearchPeopleResults release];
	[tbl_cellFavorites release];
	[tbl_cellFollowers release];
	[str_SearchPeopleText release];
	[super dealloc];
}
#pragma mark change button state
-(void)changeButtonState:(id)Sender
{
	UIButton *btn=(UIButton *)Sender;
	[btn setHighlighted:YES];
}
-(void)HideOrShowButtons:(BOOL) isHide
{
	btn_meFollowing.hidden=isHide;
	btn_FollowingMe.hidden=isHide;
	btn_favorites.hidden=isHide;
	btn_recommendations.hidden=isHide;
	lbl_SearchResults.hidden=!isHide;
	lbl_heading.hidden=isHide;
	isSearchResultScreen=isHide;
}
-(void)SetTablePosition:(int)IncrementedValue
{
	lbl_tableHeaderLine.frame=CGRectMake(lbl_tableHeaderLine.frame.origin.x,
										 lbl_tableHeaderLine.frame.origin.y+IncrementedValue,
										 lbl_tableHeaderLine.frame.size.width,
										 lbl_tableHeaderLine.frame.size.height);
	////////////////////////////////////////////
	tbl_details.frame=CGRectMake(tbl_details.frame.origin.x,
								 tbl_details.frame.origin.y+IncrementedValue,
								 tbl_details.frame.size.width,
								 tbl_details.frame.size.height);
	///////////////////////////////////////////
	
}
#pragma mark IBActions
-(IBAction)btn_Action_back
{
	if (isSearchResultScreen) {
		imgV_txtBackground.frame=CGRectMake(imgV_txtBackground.frame.origin.x-65,
											imgV_txtBackground.frame.origin.y,
											imgV_txtBackground.frame.size.width+65,
											imgV_txtBackground.frame.size.height);
		
		txt_searchField.frame=CGRectMake(txt_searchField.frame.origin.x-65,
										 txt_searchField.frame.origin.y,
										 txt_searchField.frame.size.width+65,
										 txt_searchField.frame.size.height);
		btn_back.hidden=YES;
		////////Display The Buttons//////
		[self HideOrShowButtons:NO];
		[self SetTablePosition:40];
	}
	txt_searchField.text=@"";
	[self btn_Action_meFollowing];
	
}
-(IBAction)btn_Action_SearchPeople
{
	self.str_SearchPeopleText=txt_searchField.text;
	if (str_SearchPeopleText!=nil && ![str_SearchPeopleText isEqualToString:@""]) {
		if (!isSearchResultScreen) {
			imgV_txtBackground.frame=CGRectMake(imgV_txtBackground.frame.origin.x+65,
												imgV_txtBackground.frame.origin.y,
												imgV_txtBackground.frame.size.width-65,
												imgV_txtBackground.frame.size.height);
			
			txt_searchField.frame=CGRectMake(txt_searchField.frame.origin.x+65,
											 txt_searchField.frame.origin.y,
											 txt_searchField.frame.size.width-65,
											 txt_searchField.frame.size.height);
			btn_back.hidden=NO;
			////////HIDES The Button//////
			[self HideOrShowButtons:YES];
			[self SetTablePosition:-40];
		}
		
		btnSelected=4;
		[txt_searchField resignFirstResponder];
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(SearchPeopleNetworkCall) toTarget:self withObject:nil];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
														message:@"Search People field cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

}
-(IBAction)btn_Action_meFollowing
{
	btnSelected=0;
	lbl_heading.text=@"People I am Following";
	[self performSelectorOnMainThread:@selector(changeButtonState:) withObject:btn_meFollowing waitUntilDone:NO];
	[btn_FollowingMe setHighlighted:NO];
	[btn_favorites setHighlighted:NO];
	[btn_recommendations setHighlighted:NO];
	///////////////////////////
	
	if ([self.obj_SharedGroupData.arr_PplMeFollowing count]>0) {
		[tbl_details reloadData];	
	}
	else {
		[self performSelectorOnMainThread:@selector(LoadWaitingView) withObject:nil waitUntilDone:NO];

		[NSThread detachNewThreadSelector:@selector(LoadDataForPplIamFollowing) toTarget:self withObject:nil];
	}
}
-(IBAction)btn_Action_FollowingMe
{
	btnSelected=1;
	lbl_heading.text=@"People Following me";
	[btn_meFollowing setHighlighted:NO];
	[self performSelectorOnMainThread:@selector(changeButtonState:) withObject:btn_FollowingMe waitUntilDone:NO];
	[btn_favorites setHighlighted:NO];
	[btn_recommendations setHighlighted:NO];
	///////////////////////////
	///////////////////////////
	
		[self performSelectorOnMainThread:@selector(LoadWaitingView) withObject:nil waitUntilDone:NO];
		
		[NSThread detachNewThreadSelector:@selector(LoadDataForPplFollowingMe) toTarget:self withObject:nil];
	

}
-(IBAction)btn_Action_favorites
{
	btnSelected=2;
    lbl_heading.text=@"My Favorites";
	///////////////////////////
	[btn_meFollowing setHighlighted:NO];
	[btn_FollowingMe setHighlighted:NO];
	//[btn_favorites setHighlighted:YES];
	[self performSelectorOnMainThread:@selector(changeButtonState:) withObject:btn_favorites waitUntilDone:NO];
	[btn_recommendations setHighlighted:NO];
	///////////////////////////
	if ([self.obj_SharedGroupData.arr_Favorites count]>0) {
		[tbl_details reloadData];	
	}
	else {
		[self performSelectorOnMainThread:@selector(LoadWaitingView) withObject:nil waitUntilDone:NO];
		
		[NSThread detachNewThreadSelector:@selector(LoadDataForFavorites) toTarget:self withObject:nil];
	}
}
-(IBAction)btn_Action_recommendations
{
	btnSelected=3;
	lbl_heading.text=@"Recommendation";
	///////////////////////////
	[btn_meFollowing setHighlighted:NO];
	[btn_FollowingMe setHighlighted:NO];
	[btn_favorites setHighlighted:NO];
	//[btn_recommendations setHighlighted:YES];
	[self performSelectorOnMainThread:@selector(changeButtonState:) withObject:btn_recommendations waitUntilDone:NO];
	///////////////////////////
	if ([self.obj_SharedGroupData.arr_Recommendations count]>0) {
		[tbl_details reloadData];	
	}
	else {
		[self performSelectorOnMainThread:@selector(LoadWaitingView) withObject:nil waitUntilDone:NO];
		
		[NSThread detachNewThreadSelector:@selector(LoadDataForRecommendation) toTarget:self withObject:nil];
	}
}
-(IBAction)btn_Action_followPerson:(id)Sender
{
	UIButton *btn=(UIButton *)Sender;

	PressedButtonIndex=btn.tag;
	if (btnSelected==0) {
		
	}
	else if(btnSelected==4)
	{
		GroupPeopleBO *obj=[self.SearchPeopleResults objectAtIndex:PressedButtonIndex];
		NSString *userID=[NSString stringWithFormat:@"%@",obj.str_userID];
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(followPersonCall:) toTarget:self withObject:userID];
	}
}
-(IBAction)btn_Action_unFollowPerson:(id)Sender
{
	UIButton *btn=(UIButton *)Sender;
	PressedButtonIndex=btn.tag;
	GroupPeopleBO *obj=[self.obj_SharedGroupData.arr_PplMeFollowing objectAtIndex:PressedButtonIndex];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
													message:[NSString stringWithFormat: @"Do you want to unfolllow %@",obj.str_fName] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
	[alert show];
	[alert release];
	
}
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:
			;
			NSLog(@"0");
			if (btnSelected==0) {
				GroupPeopleBO *obj=[self.obj_SharedGroupData.arr_PplMeFollowing objectAtIndex:PressedButtonIndex];
				NSString *userID=[NSString stringWithFormat:@"%@",obj.str_userID];
				[self LoadWaitingView];
				[NSThread detachNewThreadSelector:@selector(UnfollowPersonCall:) toTarget:self withObject:userID];
			}
			else if(btnSelected==4)
			{
				GroupPeopleBO *obj=[self.SearchPeopleResults objectAtIndex:PressedButtonIndex];
				NSString *userID=[NSString stringWithFormat:@"%@",obj.str_userID];
				[self LoadWaitingView];
				[NSThread detachNewThreadSelector:@selector(UnfollowPersonCall:) toTarget:self withObject:userID];
			}
			
			break;
		case 1:
			
			;
			
			
			break;
			
		default:
			break;
	}	
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
	if (btnSelected==0 || btnSelected==1 || btnSelected==4 ) {
		    return 80;	
	}
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
	int rows=0;
	if (btnSelected==4) {

		rows=[self.SearchPeopleResults count];
		numberOfRows4Table=rows;
		if (rows==0) {
			[self UnLoadWaitingView];
		}
		return rows;
	}
	else if(btnSelected==0)
	{
		rows=[self.obj_SharedGroupData.arr_PplMeFollowing count];
		numberOfRows4Table=rows;
		if (rows==0 && !isLoadingFirstTime) {
			[self UnLoadWaitingView];
		}
		isLoadingFirstTime=NO;
		return rows;
		
	}
	else if(btnSelected==1){
		rows=[self.obj_SharedGroupData.arr_PplFollowingMe count];
		numberOfRows4Table=rows;
		if (rows==0) {
			[self UnLoadWaitingView];
		}
		return rows;	
	}
	else if(btnSelected==2){
		rows=[self.obj_SharedGroupData.arr_Favorites count];
		numberOfRows4Table=rows;
		if (rows==0) {
			[self UnLoadWaitingView];
		}
		return rows;	
	}
	else if(btnSelected==3){
		rows=[self.obj_SharedGroupData.arr_Recommendations count];
		numberOfRows4Table=rows;
		if (rows==0) {
			[self UnLoadWaitingView];
		}
		return rows;	
	}
	numberOfRows4Table=rows;
	return 10;
	
}// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	if (indexPath.row==(numberOfRows4Table-1)) {
		if (_waitingView!=nil) {
			[self UnLoadWaitingView];
		}
	}
	*/
	return [self GetCell:tableView cellForRowAtIndexPath:indexPath];
	

}
#pragma mark Load Cell
-(UITableViewCell *) getCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier3 = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier3];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier3] autorelease];
		
	}
	cell.textLabel.font=[UIFont systemFontOfSize:18.0];
	if (btnSelected==2) {
		FavoriteBO *obj=[self.obj_SharedGroupData.arr_Favorites objectAtIndex:indexPath.row];
		cell.textLabel.text=obj.str_bussinessName;
	}
	else if(btnSelected==3) {
		FavoriteBO *obj=[self.obj_SharedGroupData.arr_Recommendations objectAtIndex:indexPath.row];
		cell.textLabel.text=obj.str_bussinessName;
	}

	
	
	return cell;
}
-(UITableViewCell *) GetCellForCase0and4:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"GroupsPeople";
	UITableViewCell *cell=nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"FollowersCell" owner:self options:nil];
		cell = self.tbl_cellFollowers;
		self.tbl_cellFollowers = nil;
	}
	NSArray *subViews=[cell.contentView subviews];
	for (int i=0;i<[subViews count];i++) {
		UIView *tempView=[subViews objectAtIndex:i];
		if (tempView.tag!=4444 && tempView.tag!=6666) {
			[tempView removeFromSuperview];//	Removing Follow/Unfollow button from cell
		}
	}
	////////////////////////////////////
	UIButton *btn_unfollow=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_unfollow.frame=CGRectMake(250,58,60,20);
	btn_unfollow.tag=indexPath.row;
	if (btnSelected==0) {
		
		/////////////////////////////////
		UILabel *lbl=(UILabel *)[cell.contentView viewWithTag:6666];
		GroupPeopleBO *obj=[self.obj_SharedGroupData.arr_PplMeFollowing objectAtIndex:indexPath.row];
		lbl.text=[NSString stringWithFormat:@"%@ %@",obj.str_fName,obj.str_lName];
		
		////////////////////////////////
		if (obj.isFollowing) {
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow.png"] forState:UIControlStateNormal];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_pressed.png"] forState:UIControlStateSelected];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_pressed.png"] forState:UIControlStateHighlighted];
			[btn_unfollow addTarget:self action:@selector(btn_Action_unFollowPerson:) forControlEvents:UIControlEventTouchUpInside];	
		}
		else {
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow.png"] forState:UIControlStateNormal];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow_pressed.png"] forState:UIControlStateSelected];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow_pressed.png"] forState:UIControlStateHighlighted];
			[btn_unfollow addTarget:self action:@selector(btn_Action_followPerson:) forControlEvents:UIControlEventTouchUpInside];	
		}

		////////////////////////////////
		
		/////////////////////////////////////////
		/////testing the image loading//////
		if (obj.str_imgPath!=nil && ![obj.str_imgPath isEqualToString:@""]) {
			AsyncImageView *iconImg = [[AsyncImageView alloc] initWithFrame:CGRectMake(8,0,60,85)];
			iconImg.tag = indexPath.row;
			iconImg.spinnerCenter = iconImg.center;
			iconImg.backgroundColor = [UIColor clearColor];
			//[iconImg loadImageFromURL:[NSURL URLWithString:@"http://174.129.194.38/katie/api/files/32_52141_14910.png"]];
			[iconImg loadImageFromURL:[NSURL URLWithString:obj.str_imgPath]];
			[cell.contentView addSubview:iconImg];
			[iconImg release];	
		}
		
		
		//////////////////////////////////////////
	}
	else if(btnSelected==1){
		/////////////////////////////////
		UILabel *lbl=(UILabel *)[cell.contentView viewWithTag:6666];
		GroupPeopleBO *obj=[self.obj_SharedGroupData.arr_PplFollowingMe objectAtIndex:indexPath.row];
		lbl.text=[NSString stringWithFormat:@"%@ %@",obj.str_fName,obj.str_lName];
		
		/////testing the image loading//////
		if (obj.str_imgPath!=nil && ![obj.str_imgPath isEqualToString:@""]) {
			AsyncImageView *iconImg = [[AsyncImageView alloc] initWithFrame:CGRectMake(8,0,60,85)];
			iconImg.tag = indexPath.row;
			iconImg.spinnerCenter = iconImg.center;
			iconImg.backgroundColor = [UIColor clearColor];
			//[iconImg loadImageFromURL:[NSURL URLWithString:@"http://174.129.194.38/katie/api/files/32_52141_14910.png"]];
			[iconImg loadImageFromURL:[NSURL URLWithString:obj.str_imgPath]];
			[cell.contentView addSubview:iconImg];
			[iconImg release];	
		}
	}
	else if(btnSelected==4){
		GroupPeopleBO *obj=[self.SearchPeopleResults objectAtIndex:indexPath.row];
		UILabel *lbl=(UILabel *)[cell.contentView viewWithTag:6666];
		lbl.text=[NSString stringWithFormat:@"%@ %@",obj.str_fName,obj.str_lName];
		if (obj.isFollowing) {
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow.png"] forState:UIControlStateNormal];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_pressed.png"] forState:UIControlStateSelected];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_unfollow_pressed.png"] forState:UIControlStateHighlighted];
			[btn_unfollow addTarget:self action:@selector(btn_Action_unFollowPerson:) forControlEvents:UIControlEventTouchUpInside];
		}
		else {
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow.png"] forState:UIControlStateNormal];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow_pressed.png"] forState:UIControlStateSelected];
			[btn_unfollow setBackgroundImage:[UIImage imageNamed:@"btn_follow_pressed.png"] forState:UIControlStateHighlighted];
			[btn_unfollow addTarget:self action:@selector(btn_Action_followPerson:) forControlEvents:UIControlEventTouchUpInside];		
		}
		/////testing the image loading//////
		if (obj.str_imgPath!=nil && ![obj.str_imgPath isEqualToString:@""]) {
			AsyncImageView *iconImg = [[AsyncImageView alloc] initWithFrame:CGRectMake(8,0,60,85)];
			iconImg.tag = indexPath.row;
			iconImg.spinnerCenter = iconImg.center;
			iconImg.backgroundColor = [UIColor clearColor];
			//[iconImg loadImageFromURL:[NSURL URLWithString:@"http://174.129.194.38/katie/api/files/32_52141_14910.png"]];
			[iconImg loadImageFromURL:[NSURL URLWithString:obj.str_imgPath]];
			[cell.contentView addSubview:iconImg];
			[iconImg release];	
		}
		
	}
	
	////////////////////////////////////
	[cell.contentView addSubview:btn_unfollow];
	////////////////////////////////////
	
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	return cell;
		
}
-(UITableViewCell *) GetCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCell *cell=nil;

	switch (btnSelected) {
		case 0:
			;
			return [self GetCellForCase0and4:tableView cellForRowAtIndexPath:indexPath];	
			break;
		case 4:
			;
			return [self GetCellForCase0and4:tableView cellForRowAtIndexPath:indexPath];	
			break;
	
		case 1:
			;
			
			return [self GetCellForCase0and4:tableView cellForRowAtIndexPath:indexPath];	
			break;
			
		case 2:
			;
			
			return [self getCell:tableView cellForRowAtIndexPath:indexPath];
			break;
			
		case 3:
			;
			return [self getCell:tableView cellForRowAtIndexPath:indexPath];	
			break;
			
		default:
			return nil;
			break;
	}
}
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self btn_Action_SearchPeople];
	[textField resignFirstResponder];
	return YES;	
}
#pragma mark SearchPeople
-(void)SearchPeopleNetworkCall
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSDictionary *dic=[GroupsBL SearchPeopleInBubble:self.str_SearchPeopleText];
	
	[self performSelectorOnMainThread:@selector(HandleSearchPeolpleResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandleSearchPeolpleResponse:(id)results
{
	NSDictionary *dict=(NSDictionary *)results;
	if ([dict objectForKey:FailureKey]) 
	{
		NSError *error=[dict objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.SearchPeopleResults=[dict objectForKey:SuccessKey];
		lbl_SearchResults.text=[NSString stringWithFormat:@"%d results in Bubble",[self.SearchPeopleResults count]];
		btnSelected=4;
		txt_searchField.text=self.str_SearchPeopleText;

		[tbl_details reloadData];
	}
	[self UnLoadWaitingView];
}
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
#pragma mark Unfollow
-(void)UnfollowPersonCall:(id)Sender{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSString *uID=(NSString *)Sender;
	NSDictionary *dic=[GroupsBL UnfollowPerson:uID isFollow:0];
	[self performSelectorOnMainThread:@selector(HandleUnfollowPersonResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandleUnfollowPersonResponse:(id)Sender{
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		if (btnSelected==0) {
			[self.obj_SharedGroupData.arr_PplMeFollowing removeObjectAtIndex:PressedButtonIndex];
		}
		else if(btnSelected==4)
		{
			@try {
				GroupPeopleBO *obj=[self.SearchPeopleResults objectAtIndex:PressedButtonIndex];
				//NSUInteger index=[self.obj_SharedGroupData.arr_PplMeFollowing indexOfObject:obj];
				NSUInteger index=NSNotFound;
				for (int i=0;i<[self.obj_SharedGroupData.arr_PplMeFollowing count];i++) {
					GroupPeopleBO *arr_Obj=[self.obj_SharedGroupData.arr_PplMeFollowing objectAtIndex:i];
					if ([obj.str_userID isEqualToString:arr_Obj.str_userID]) {
						index=i;
						break;
					}
				}
				if (index!=NSNotFound) {
					[self.obj_SharedGroupData.arr_PplMeFollowing removeObjectAtIndex:index];
					obj.isFollowing=NO;
				}
				else {
					NSLog(@"does not found the index");
				}	
			}
			@catch (NSException * e) {
				
			}
	
		}
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
#pragma mark Follow
-(void)followPersonCall:(id)Sender{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	
	NSString *uID=(NSString *)Sender;
	NSDictionary *dic=[GroupsBL UnfollowPerson:uID isFollow:1];
	[self performSelectorOnMainThread:@selector(HandlefollowPersonResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandlefollowPersonResponse:(id)Sender{
	NSDictionary *dic=(NSDictionary *)Sender;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		NSLog(@"followed");
		if (btnSelected==0) {
			
		}
		else if(btnSelected==4)
		{
			[self.obj_SharedGroupData.arr_PplMeFollowing addObject:[self.SearchPeopleResults objectAtIndex:PressedButtonIndex]];
			GroupPeopleBO *obj=[self.SearchPeopleResults objectAtIndex:PressedButtonIndex];
			obj.isFollowing=YES;
		}
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
#pragma mark People I am following
-(void)LoadDataForPplIamFollowing
{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[GroupsBL PplIamFollowing];
	
	[self performSelectorOnMainThread:@selector(HandlePplIamFollowingResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandlePplIamFollowingResponse:(id) results
{
	NSDictionary *dic=(NSDictionary *)results;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.obj_SharedGroupData.arr_PplMeFollowing=(NSMutableArray *)[dic objectForKey:SuccessKey];
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
#pragma mark People Following Me
-(void)LoadDataForPplFollowingMe{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[GroupsBL PplFollowingMe];
	
	[self performSelectorOnMainThread:@selector(HandlePplFollowingMeResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandlePplFollowingMeResponse:(id)results{
	NSDictionary *dic=(NSDictionary *)results;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.obj_SharedGroupData.arr_PplFollowingMe=(NSMutableArray *)[dic objectForKey:SuccessKey];
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
#pragma mark Favorites
-(void)LoadDataForFavorites{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[GroupsBL MyFavorites];
	
	[self performSelectorOnMainThread:@selector(HandleFavoritesResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandleFavoritesResponse:(id)results{
	NSDictionary *dic=(NSDictionary *)results;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.obj_SharedGroupData.arr_Favorites=(NSMutableArray *)[dic objectForKey:SuccessKey];
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
#pragma mark Recommendations
-(void)LoadDataForRecommendation{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	NSDictionary *dic=[GroupsBL MyRecommendations];
	
	[self performSelectorOnMainThread:@selector(HandleRecommendationResponse:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
-(void)HandleRecommendationResponse:(id)results{
	NSDictionary *dic=(NSDictionary *)results;
	if ([dic objectForKey:FailureKey]) 
	{
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else
	{
		self.obj_SharedGroupData.arr_Recommendations=(NSMutableArray *)[dic objectForKey:SuccessKey];
		[tbl_details reloadData];
		
	}
	[self UnLoadWaitingView];
}
-(void)HandleFavoriteOrRecommended:(NSNotification *)note{
	NSDictionary *dic=(NSDictionary *)[note object];
	
	FavoriteBO *favObj=[[FavoriteBO alloc] init];
	LocationsBO *locObj=nil;
	if ([dic objectForKey:@"favorite"]) {
		locObj=(LocationsBO *)[dic objectForKey:@"favorite"];	
	}
	else if([dic objectForKey:@"recommend"]){
		locObj=(LocationsBO *)[dic objectForKey:@"recommend"];
	}
	favObj.str_areaName=locObj.area;
	favObj.str_bussinessId=[NSString stringWithFormat:@"%d",locObj.businessObject.businessID];
	
	favObj.str_bussinessName=locObj.businessObject.officialName;
	favObj.str_locationId=[NSString stringWithFormat:@"%d",locObj.locationId];
	if ([dic objectForKey:@"favorite"]) {
		[self.obj_SharedGroupData.arr_Favorites addObject:favObj];
	}
	else if([dic objectForKey:@"recommend"]){
		[self.obj_SharedGroupData.arr_Recommendations addObject:favObj];
	}
	[favObj release];
}
@end
