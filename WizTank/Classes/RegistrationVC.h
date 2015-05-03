//
//  RegistrationVC.h
//  WizTank
//
//  Created by Shafqat on 1/3/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterBO.h"
#import "WaitingView.h"


@interface RegistrationVC : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
	IBOutlet UILabel *lbl_upperBarText;
	IBOutlet UITextField *txt_Fname;
	IBOutlet UITextField *txt_Lname;
	IBOutlet UITextField *txt_Gender;
	IBOutlet UITextField *txt_dob;
	IBOutlet UITextField *txt_country;
	IBOutlet UITextField *txt_phone;
	IBOutlet UITextField *txt_email;
	IBOutlet UITextField *txt_password;
	//IBOutlet UIImageView *imgV_pic;
	IBOutlet UIButton *btn_ImageSelector;
	IBOutlet UIScrollView *scrollView;
	////////Date picker/////////
	IBOutlet UIDatePicker *dobDate;
	IBOutlet UIView *datePickerView;
	IBOutlet UIPickerView *GenderAndCountryPicker;
	NSMutableArray *countryNames;
	NSMutableArray *GenderArray;
	UITextField *SelectedTextField;
	RegisterBO *obj_register;
	
	IBOutlet UIButton *btn_Back;
	IBOutlet UIButton *btn_register;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UIImageView *imgV_HeaderBar;
	BOOL isRegistration;
	BOOL isEditButtonPressed;
	IBOutlet UIView *view_PhoneNumberView;
	////////////////
	UIImage *profileImage;
	WaitingView *_waitingView;
	BOOL isCancel;
	BOOL isNewImage;
	///////////////

}
@property BOOL isRegistration;
@property BOOL isCancel;
@property (nonatomic,retain) RegisterBO *obj_register;
@property (nonatomic,retain) UIImage *profileImage;
-(IBAction) btn_Action_PhoneNumberCancel;
-(IBAction) btn_Action_PhoneNumberDone;
-(IBAction) btn_Action_Done;
-(IBAction) btn_Action_Cancel;
-(IBAction) btn_Action_back;
-(IBAction) btn_Action_SignUp;
-(IBAction) btn_Action_ImageSelector;

-(void) performRegistration;
-(void)removeSpinnerFromRegistrationView:(id)results;
-(void)removeSpinnerFromUpdatingView:(id)results;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
-(void)EnableOrDisable:(BOOL) flag;
-(void)SetRegistrationObject;
-(void) SetBackButtonImage;
-(void)LogoutUser;
-(void)HandleLogOutResponse:(id)results;
//-(void)setBackgroundImg:(RegisterBO*)userInfo;
-(void)setBackgroundImg;	
-(void)LoadWaitingView;
-(void)UnLoadWaitingView;
@end
