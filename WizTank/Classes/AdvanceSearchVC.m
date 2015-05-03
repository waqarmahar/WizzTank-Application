//
//  AdvanceSearchVC.m
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "AdvanceSearchVC.h"
#import "SearchResultsVC.h"
#import "FindPlacesBL.h"
#import "WizTankAppDelegate.h"

@implementation AdvanceSearchVC

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
	if (textField==txt_hint) {
		[scrollView setContentOffset:CGPointMake(0.0,40.0) animated:YES];
		
	}
	else if(textField==txt_location){
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
#pragma mark IBActions
-(IBAction) btn_Action_back
{
	[self.navigationController popViewControllerAnimated:YES];	
}
-(IBAction) btn_Action_Search
{
	if( ([txt_hint.text isEqualToString:@""] || txt_hint.text==nil) || [txt_location.text isEqualToString:@""] ||
			txt_location.text == nil){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" 
														message:@"Please specify keyword and location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
	else {
		[self LoadWaitingView];
		[NSThread detachNewThreadSelector:@selector(advanceSearch) toTarget:self withObject:nil];
	
		}	
}
-(void)advanceSearch{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *searchQuerry = [NSString stringWithFormat:@"%@ in %@",txt_hint.text,txt_location.text];
	int catID=-1;
	NSDictionary *dic=[FindPlacesBL searchPlaces:searchQuerry:catID];
    [self performSelectorOnMainThread:@selector(RemoveSpinner4AdvanceSearch:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)RemoveSpinner4AdvanceSearch:(id)Sender{
		[self  UnLoadWaitingView];
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
			searchVC.isCloseByResults =NO;
			searchVC.searchQuery = txt_hint.text;
			searchVC.placesArray = placesArray;
			[self.navigationController pushViewController:searchVC animated:YES];
			[searchVC release];	
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
