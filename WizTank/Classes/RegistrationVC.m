//
//  RegistrationVC.m
//  WizTank
//
//  Created by Shafqat on 1/3/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "RegistrationVC.h"
#import "LoginBL.h"
#import "LoginVC.h"
#import "WizTankAppDelegate.h"
#import "AsyncImageView.h"

#define radians( degrees ) ( degrees * 3.1417 / 180 )

@implementation RegistrationVC

@synthesize obj_register,profileImage;
@synthesize isRegistration,isCancel;

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
	
	self.obj_register=[[RegisterBO alloc] init];
	self.obj_register.picData=nil;
	////////////////////////////////////////////////
	if (self.isRegistration) {
		lbl_upperBarText.text=NSLocalizedString(@"SignUpTitle", nil);
	}
	else {
		lbl_upperBarText.text=@"My Profile";
		scrollView.contentSize=CGSizeMake(320,520);
		imgV_HeaderBar.frame=CGRectMake(0,0,320,95);
		/////////////////////Setting the images of the two buttons///////////////
		////////////////////////
		//[self SetBackButtonImage];
        btn_Back.hidden=YES;
		[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_logout.png" ofType:nil]] 
							forState:UIControlStateNormal];
		[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_logout_pressed.png" ofType:nil]] 
							forState:UIControlStateSelected];
		[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_logout_pressed.png" ofType:nil]] 
							forState:UIControlStateHighlighted];
		////////////////////////
		[self EnableOrDisable:NO];
		//////Set the text of eache button;
		//[self SetRegistrationObject];
	}
	///////////////////////////////////////////////////////////////
	GenderArray=[[NSArray arrayWithObjects:@"Male",@"Female",nil] retain];
	NSString *CountryString;
	@try {
		//CountryString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryList.csv" ofType:nil]];	
		CountryString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryList.csv" ofType:nil]
												encoding:NSUTF8StringEncoding error:nil];
	}
	@catch (NSException * e) {
		NSLog(@"Could not able to read the file");
		CountryString=[NSString stringWithString:@"Kuwait\nUnited States\nCanada"];
	}
	@finally {
		
	}
	txt_phone.inputAccessoryView=view_PhoneNumberView;
	countryNames=[[CountryString componentsSeparatedByString:@"\n"] retain];
}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
		if (!self.isRegistration)
		{
            
            txt_email.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            //[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            txt_Fname.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"fname"];
            txt_Lname.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"lname"];
            txt_country.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"country"];
            txt_Gender.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"gener"];
            txt_dob.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
			//[self performSelectorInBackground:@selector(setBackgroundImg:) withObject:userInfo];
			
		}
}
-(void)setBackgroundImg{
	
    NSData *data=(NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:UserProfileImage];
    UIImage *img=[UIImage imageWithData:data];
	[btn_ImageSelector setBackgroundImage:img forState:UIControlStateNormal];
	[btn_ImageSelector setBackgroundImage:img forState:UIControlStateSelected];
	[btn_ImageSelector setBackgroundImage:img forState:UIControlStateHighlighted];
	
}
#pragma mark WaitingView Methods
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark TextField Delegates
-(void) ResignAllFields{
	[txt_Fname resignFirstResponder];
		[txt_Lname resignFirstResponder];
		[txt_Gender resignFirstResponder];
		[txt_dob resignFirstResponder];
		[txt_country resignFirstResponder];
		[txt_phone resignFirstResponder];
		[txt_email resignFirstResponder];
		[txt_password resignFirstResponder];
		
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	CGFloat yIndex=0.0;
	SelectedTextField=textField;
	[datePickerView removeFromSuperview];
	if(textField==txt_phone){
		yIndex=170.0;
	}
	else if(textField==txt_email || textField==txt_password){
		yIndex=230.0;
	}
	[scrollView setContentOffset:CGPointMake(0.0,yIndex) animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	SelectedTextField=textField;

	if (textField==txt_dob || textField==txt_Gender || textField==txt_country) {
		[self ResignAllFields];
		CGFloat yIndex=0.0;
		if (textField==txt_Gender) {
			yIndex=20.0;
			[GenderAndCountryPicker reloadAllComponents];
			GenderAndCountryPicker.frame=CGRectMake(0,60,
													GenderAndCountryPicker.frame.size.width,
													GenderAndCountryPicker.frame.size.height);
			[datePickerView addSubview:GenderAndCountryPicker];
			datePickerView.frame=CGRectMake(0,textField.frame.origin.y+10,datePickerView.frame.size.width, datePickerView.frame.size.height);
			[self.view addSubview:datePickerView];
		}
		else if(textField==txt_dob){
			yIndex=90.0;
			dobDate.maximumDate=[NSDate date];
			 dobDate.date=[NSDate dateWithTimeIntervalSince1970:0];
			 dobDate.frame=CGRectMake(0,60,dobDate.frame.size.width,dobDate.frame.size.height);
			 [datePickerView addSubview:dobDate];
			 datePickerView.frame=CGRectMake(0,textField.frame.origin.y-50,datePickerView.frame.size.width, datePickerView.frame.size.height);
			[GenderAndCountryPicker selectRow:0 inComponent:0 animated:NO]; 
			[self.view addSubview:datePickerView];
		}
		else if(textField==txt_country){
			yIndex=120.0;
			[GenderAndCountryPicker reloadAllComponents];
			GenderAndCountryPicker.frame=CGRectMake(0,55,
													GenderAndCountryPicker.frame.size.width,
													GenderAndCountryPicker.frame.size.height);
			[datePickerView addSubview:GenderAndCountryPicker];
			datePickerView.frame=CGRectMake(0,textField.frame.origin.y-80,datePickerView.frame.size.width, datePickerView.frame.size.height);
			[GenderAndCountryPicker selectRow:0 inComponent:0 animated:NO];
			[self.view addSubview:datePickerView];
		}
		[scrollView setContentOffset:CGPointMake(0.0,yIndex) animated:YES];
		return NO;
	}
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//	if (textField==txt_Fname) {
		self.obj_register.str_Fname=txt_Fname.text;
//	}
//	else if(textField==txt_Lname){
		self.obj_register.str_Lname=txt_Lname.text;
//	}
//	else if(textField==txt_phone){
		self.obj_register.str_phone=txt_phone.text;
//	}
//	else if(textField==txt_email){
		self.obj_register.str_email=txt_email.text;
//	}
//	else if(textField==txt_password){
		self.obj_register.str_password=txt_password.text;
		self.obj_register.str_dob=txt_dob.text;
	    self.obj_register.str_country = txt_country.text;
	    self.obj_register.str_gender = txt_Gender.text;
	
//	}
	[textField resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
	[textField resignFirstResponder];

	return YES;	
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
#pragma mark IBActions
-(IBAction) btn_Action_PhoneNumberDone
{
	obj_register.str_phone=txt_phone.text;
	[txt_phone resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
}
-(IBAction) btn_Action_PhoneNumberCancel
{
	if ([txt_phone.text isEqualToString:@""]) {
		txt_phone.text=@"";
		obj_register.str_phone=@"";	
	}
	
	[txt_phone resignFirstResponder];
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
}
-(IBAction) btn_Action_Done
{
	if (SelectedTextField==txt_dob) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MM-dd-yyyy"];
		txt_dob.text = [formatter stringFromDate:dobDate.date];
		self.obj_register.str_dob=txt_dob.text;
		[formatter release];
	}
	if (SelectedTextField==txt_Gender) {
		self.obj_register.str_gender=[GenderArray objectAtIndex:[GenderAndCountryPicker selectedRowInComponent:0]];
		txt_Gender.text=self.obj_register.str_gender;
	}
	if (SelectedTextField==txt_country) {
		self.obj_register.str_country=[countryNames objectAtIndex:[GenderAndCountryPicker selectedRowInComponent:0]];
		txt_country.text=self.obj_register.str_country;
	}
	[datePickerView removeFromSuperview];
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
}
-(IBAction) btn_Action_Cancel
{
	[datePickerView removeFromSuperview];
	[scrollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
	[self ResignAllFields];
}
-(IBAction) btn_Action_ImageSelector
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}
-(IBAction) btn_Action_back
{
	if (self.isRegistration) {
		[self.navigationController popViewControllerAnimated:YES];	
	}
	else {
		if (isEditButtonPressed) {
			///save button is pressed check for changes and send it to the server and then
			//change the image of the button
			activityIndicator.hidden=NO;
			[activityIndicator startAnimating];
			isEditButtonPressed=NO;
			[self EnableOrDisable:NO];
			[self SetBackButtonImage];
			[NSThread detachNewThreadSelector:@selector(UpdateUser) toTarget:self withObject:nil];	
			[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_logout.png" 
																											  ofType:nil]] forState:UIControlStateNormal];
		}
		else {
			[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_Save.png" ofType:nil]] 
								forState:UIControlStateNormal];
			[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_Save_pressed.png" ofType:nil]] 
								forState:UIControlStateSelected];
			[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_Save_pressed.png" ofType:nil]] 
								forState:UIControlStateHighlighted];
			isEditButtonPressed=YES;
			[self EnableOrDisable:YES];
			[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_cancel.png" 
																							ofType:nil]] forState:UIControlStateNormal];
			[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_cancel_pressed.png" ofType:nil]] 
								forState:UIControlStateSelected];
			[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_cancel_pressed.png" ofType:nil]] 
									forState:UIControlStateHighlighted];
	

			isCancel = YES;
			[txt_Fname becomeFirstResponder];
			/////Change the image of the button here///	
		}

		
	}

	
}
-(IBAction) btn_Action_SignUp
{
	
	if (self.isRegistration) {
		[self ResignAllFields];
		btn_Back.enabled=NO;
		btn_register.enabled=NO;
		btn_ImageSelector.enabled=NO;
		activityIndicator.hidden=NO;
		[activityIndicator startAnimating];
		[NSThread detachNewThreadSelector:@selector(performRegistration) toTarget:self withObject:nil];	
		
	}
	else {
		if (isEditButtonPressed) {
			isEditButtonPressed =NO;
			[btn_register setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_logout.png" 
																											  ofType:nil]] forState:UIControlStateNormal];
			[self setBackgroundImg];
			[self ResignAllFields];
			self.obj_register.picData=nil;
			[self SetBackButtonImage];
	
		}
		else {
			_waitingView = (WaitingView*)[WaitingView loadInstanceFromNib];
			WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
			[_waitingView startAnimation];
			[appDelegate.tabBarController.view addSubview:_waitingView];
			[NSThread detachNewThreadSelector:@selector(LogoutUser) toTarget:self withObject:nil];			
		}

		
	}

	
}
#pragma mark Logout user
-(void)LogoutUser{
	NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
	//NSDictionary *dic=[LoginBL LogoutUser];
	[self performSelectorOnMainThread:@selector(HandleLogOutResponse:) withObject:nil waitUntilDone:NO];
	
	[pool drain];
	
}
-(void)HandleLogOutResponse:(id)results
{
	[_waitingView removeOverlayView];
	/*NSDictionary *dic=(NSDictionary *)results;
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
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserProfileImage];
		////Post the notification here to Unload all the views of the app////
		self.obj_register.picData=nil;
     */
		[[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
		
		LoginVC *obj_LoginVC=[[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
		UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:obj_LoginVC];
		navController.navigationBarHidden=YES;
		
		WizTankAppDelegate *appDelegate=(WizTankAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.tabBarController.selectedIndex=0;
		[appDelegate.tabBarController presentModalViewController:navController animated:YES];
		[obj_LoginVC release];
		[navController release];	
	//}
}
#pragma mark Registration Methods
-(void) performRegistration{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSError *error=[LoginBL VerfiyRegistrationInput:self.obj_register];
	NSDictionary *dic;
	if ([error code]==0) {
		
		dic=[LoginBL RegisterRequest:self.obj_register];
		if ([dic objectForKey:FailureKey]) {
        
        }
		else if([[dic objectForKey:@"status"] isEqualToString:@"Success"]) {
			/*
			NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.obj_register];
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:myEncodedObject forKey:registrationObjkey];
             */
		}
        
	}
	else {
		dic=[NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	[self performSelectorOnMainThread:@selector(removeSpinnerFromRegistrationView:) withObject:dic waitUntilDone:NO];
	 [pool drain];
}
-(void)removeSpinnerFromUpdatingView:(id)results{
	activityIndicator.hidden = YES;
	[activityIndicator stopAnimating];
    btn_Back.enabled = YES;
	btn_register.enabled= YES;
	btn_ImageSelector.enabled=NO;
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" 
														message:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];		
		[self dismissModalViewControllerAnimated:YES];	
	}
	
}
-(void)removeSpinnerFromRegistrationView:(id)results{
	activityIndicator.hidden = YES;
	[activityIndicator stopAnimating];
    btn_Back.enabled = YES;
	btn_register.enabled= YES;
	btn_ImageSelector.enabled=NO;	
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
		//RegisterBO *registrationBO =(RegisterBO*)[[NSUserDefaults standardUserDefaults] objectForKey:registrationObjkey];
		//[self setBackgroundImg:self.profileImage];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up" 
//														message:@"User registered Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:self.obj_register.picData forKey:UserProfileImage];
		self.isRegistration=NO;
		[self dismissModalViewControllerAnimated:YES];	
	}
	
}
#pragma mark UpdateUser

-(void) UpdateUser{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//[self ResignAllFields];
	NSError *error=[LoginBL VerfiyUpdateInput:self.obj_register :isNewImage];
	NSDictionary *dic;
	if ([error code]==0) {
		dic=[LoginBL updateUser:self.obj_register];
		if ([dic objectForKey:FailureKey]) {
		 NSError *error=[dic objectForKey:@"error"];
		 dic=[NSDictionary dictionaryWithObject:error forKey:FailureKey];	
		 }
		 else if([[dic objectForKey:@"status"] isEqualToString:@"Success"]) {
			 NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.obj_register];
			 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			 [defaults setObject:myEncodedObject forKey:registrationObjkey];
			 isNewImage=NO;
             [defaults setObject:self.obj_register.picData forKey:UserProfileImage];
		 }
	}
	else {
		/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
		 message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		 [alert show];
		 [alert release];*/
		dic=[NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	[self performSelectorOnMainThread:@selector(removeSpinnerFromUpdatingView:) withObject:dic waitUntilDone:NO];
	[pool drain];
}
#pragma mark UIImagePickerController delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
		
	if (img!=nil) {
		self.profileImage = img;
		[btn_ImageSelector setBackgroundImage:img forState:UIControlStateNormal];
		[btn_ImageSelector setBackgroundImage:img forState:UIControlStateSelected];
		[btn_ImageSelector setBackgroundImage:img forState:UIControlStateHighlighted];
		self.obj_register.picData=UIImageJPEGRepresentation([RegistrationVC imageWithImage:img scaledToSizeWithSameAspectRatio:CGSizeMake(50.0,60.0)],0.8);
		//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		//[defaults setObject:self.obj_register.picData forKey:UserProfileImage];
		isNewImage =YES;
	}
	else {
		NSLog(@"img is nill");
	}
	[picker dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark PickerView DataSource and Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (SelectedTextField==txt_Gender) {
		return [GenderArray count];	
	}
	else if(SelectedTextField==txt_country){
		return [countryNames count];
	}
	return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (SelectedTextField==txt_Gender) {
		return [GenderArray objectAtIndex:row];	
	}
	else if(SelectedTextField==txt_country){
		return [countryNames objectAtIndex:row];
	}
	return @"";
} 
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	/*if (SelectedTextField==txt_Gender) {
		self.obj_register.str_gender=[GenderArray objectAtIndex:row];
		txt_Gender.text=[GenderArray objectAtIndex:row];
	}
	else if(SelectedTextField==txt_country){
		self.obj_register.str_country=[countryNames objectAtIndex:row];
		txt_country.text=[countryNames objectAtIndex:row];
	}*/
}
# pragma dealloc
- (void)dealloc {
	/*[lbl_upperBarText release];
	[txt_Fname release];
	[txt_Lname release];
	[txt_Gender release];
	[txt_dob release];
	[txt_country release];
	[txt_phone release];
	[txt_email release];
	[txt_password release];
	[btn_ImageSelector release];
	[dobDate release];
	[datePickerView release];
	[GenderAndCountryPicker release];*/
    [super dealloc];
}
#pragma mark Image Resizing
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
		
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
	
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
    CGContextRef bitmap;
	
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    }   
	
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
	
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return newImage; 
}
#pragma mark disable all fields for update profile
-(void)EnableOrDisable:(BOOL) flag
{
	btn_ImageSelector.enabled=flag;
	txt_Fname.enabled=flag;
	txt_Lname.enabled=flag;
	txt_Gender.enabled=flag;
	txt_dob.enabled=flag;
	txt_country.enabled=flag;
	txt_phone.enabled=flag;
	txt_email.enabled=flag;
	txt_password.enabled=flag;
	
}
-(void)SetRegistrationObject
{
	/*
	self.obj_register.str_Fname=@"ABC";
	self.obj_register.str_Lname=@"XYZ";
	self.obj_register.str_gender=@"Male";
	self.obj_register.str_dob=@"14-04-1987";
	self.obj_register.str_country=@"Pakistan";
	self.obj_register.str_phone=@"45465";
	self.obj_register.str_email=@"abc@gmail.com";
	//self.obj_register.picData=[UIImage imageWithData:]
	 */
	txt_Fname.text=@"ABC";
	txt_Lname.text=@"XYZ";
	txt_Gender.text=@"Male";
	txt_dob.text=@"12-06-1987";
	txt_country.text=@"Pakistan";
	txt_phone.text=@"4546554";
	txt_email.text=@"abc@gmail.com";
	
	
	
	//[btn_ImageSelector setBackgroundImage:[UIImage imageWithContentsOfFile:@"profile_tabBar.png"] forState:UIControlStateNormal];
}
-(void) SetBackButtonImage
{
	[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_edit.png" ofType:nil]] 
						forState:UIControlStateNormal];
	[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_Edit_pressed.png" ofType:nil]] 
						forState:UIControlStateSelected];
	[btn_Back setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"btn_Edit_pressed.png" ofType:nil]] 
						forState:UIControlStateHighlighted];	
}

@end
