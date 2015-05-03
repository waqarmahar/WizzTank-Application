//
//  ForgotPasswordVC.m
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "LoginBL.h"

@implementation ForgotPasswordVC

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
	lbl_forgotPasswordText.text=NSLocalizedString(@"ForgotPasswordTitle", nil);
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
	
}
- (void)viewWillDisappear:(BOOL)animated{
	
}
-(void)viewDidDisappear:(BOOL)animated{
	
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
#pragma mark IBActions
-(IBAction) btn_Action_Back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) btn_action_Submit
{
	btn_back.enabled=NO;
	btn_Submit.enabled=NO;
	[activityIndicator startAnimating];
	activityIndicator.hidden=NO;
	[NSThread detachNewThreadSelector:@selector(performForgotPasswordAction) toTarget:self withObject:nil];
}
#pragma mark Submit Button Mehtods
-(void)performForgotPasswordAction{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *error=[LoginBL VerfiyUserInput4ForgotPassword:txt_emailAddress.text];
	NSDictionary *dic;
	if ([error code]==0) {
		
		dic=[LoginBL ForgotPasswordRequest:txt_emailAddress.text];
		
	}
	else {

		dic=[NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
    [self performSelectorOnMainThread:@selector(removeSpinnerFromForgotView:) withObject:dic waitUntilDone:NO];
    [pool release];
}
-(void)removeSpinnerFromForgotView:(id) results{
	btn_Submit.enabled=YES;
	btn_back.enabled=YES;
	activityIndicator.hidden=YES;
	[activityIndicator stopAnimating];
	///////////////////////////////
	NSDictionary *dic=(NSDictionary *) results;
	if ([dic objectForKey:SuccessKey]) {
		NSString *str_Msg=[dic objectForKey:SuccessKey];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
														message:str_Msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if([dic objectForKey:FailureKey]) {
		NSError *error=[dic objectForKey:FailureKey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	///////////////////////////////
	
}
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	[scrollView setContentOffset:CGPointMake(0.0,60.0) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
	[textField resignFirstResponder];
	return YES;	
}
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 
 }*/

#pragma mark dealloc

- (void)dealloc {
	/*[scrollView release];

	[lbl_forgotPasswordText release];
	[txt_emailAddress release];*/
    [super dealloc];
}


@end
