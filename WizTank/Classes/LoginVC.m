//
//  LoginVC.m
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "LoginVC.h"
#import "ForgotPasswordVC.h"
#import "RegistrationVC.h"
@implementation LoginVC
@synthesize str_username;
@synthesize str_password;

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
#pragma mark View Loading and Unloading Methods
- (void)viewDidLoad {
    [super viewDidLoad];
	lbl_UpperBarText.text=NSLocalizedString(@"SignInTitle", nil);
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:NO];
	txt_password.text=@"";
	txt_username.text=@"";
}
/*-(void)viewDidAppear:(BOOL)animated{
	
}
- (void)viewWillDisappear:(BOOL)animated{
	
}
-(void)viewDidDisappear:(BOOL)animated{
	
}
 */
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
-(IBAction) btn_Action_ForgotPassword
{
	ForgotPasswordVC *objForgot=[[ForgotPasswordVC alloc] initWithNibName:@"ForgotPasswordVC" bundle:nil];
	[self.navigationController pushViewController:objForgot animated:YES];
	[objForgot release];
}
-(IBAction) btn_Action_SignIn
{
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];
	///Disabling the Buttons///
    btn_SignIn.enabled = NO;
	btn_SignUp.enabled= NO;
	btn_ForgotPassword.enabled=NO;
    ///////////////////
    txt_password.enabled = NO;
    txt_username.enabled = NO;
	str_username=txt_username.text;
	str_password=txt_password.text;
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
    [NSThread detachNewThreadSelector:@selector(performLogin) toTarget:self withObject:nil];
}
-(IBAction) btn_Action_SignUp
{
	RegistrationVC *obj_register=[[RegistrationVC alloc] initWithNibName:@"RegistrationVC" bundle:nil];
	obj_register.isRegistration=YES;
	[self.navigationController pushViewController:obj_register animated:YES];
	[obj_register release];
}

#pragma mark Login methods
-(void)performLogin{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSError *error=[LoginBL VerfiyUserInput:str_username password:str_password];
	NSDictionary *dic;
	if ([error code]==0) {
		
		dic=[LoginBL LoginRequest:str_username password:str_password];
        
	}
	else {
		dic=[NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
    
	 [self performSelectorOnMainThread:@selector(removeSpinnerAndLoginView:) withObject:dic waitUntilDone:NO];
    
	 [pool release];
}
-(void)removeSpinnerAndLoginView:(id) results{
	
	activityIndicator.hidden = YES;
	[activityIndicator stopAnimating];
	///Disabling the Buttons///
    btn_SignIn.enabled = YES;
	btn_SignUp.enabled= YES;
	btn_ForgotPassword.enabled=YES;
    ///////////////////
    txt_password.enabled = YES;
    txt_username.enabled = YES;
	//[self dismissModalViewControllerAnimated:YES];
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
		//RegisterBO *regBO=[dic objectForKey:SuccessKey];

		

        //[self performSelectorInBackground:@selector(LoadImageFromServer:) withObject:regBO.str_ImageURL];
		[self dismissModalViewControllerAnimated:YES];	
	}
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
}
-(void)LoadImageFromServer:(id)Sender{
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
        NSString *url_image=(NSString *)Sender;
    if (url_image!=nil && ![url_image isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:url_image];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data==nil) {
            [self LoadImageFromServer:url_image];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:UserProfileImage];
			[[NSUserDefaults standardUserDefaults] synchronize];
        }   
    } 
    
    
    [pool drain];
        
}
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	if (textField==txt_username) {
		[scrollView setContentOffset:CGPointMake(0.0,40.0) animated:YES];

	}
	else if(textField==txt_password){
		[scrollView setContentOffset:CGPointMake(0.0,140.0) animated:YES];	
	}
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
	/*[lbl_UpperBarText release];
	[txt_password release];
	[txt_username release];
	[scrollView release];*/
	//[str_password release];
	//[str_username release];
    [super dealloc];
}


@end
