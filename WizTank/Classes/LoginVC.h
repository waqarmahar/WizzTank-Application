//
//  LoginVC.h
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBL.h"

@interface LoginVC : UIViewController<UITextFieldDelegate> {
	IBOutlet UILabel *lbl_UpperBarText;
	IBOutlet UITextField *txt_username;
	IBOutlet UITextField *txt_password;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	/////////////////////////////
	IBOutlet UIButton *btn_SignIn;
	IBOutlet UIButton *btn_SignUp;
	IBOutlet UIButton *btn_ForgotPassword;
	NSString *str_username;
	NSString *str_password;
}

@property(nonatomic,copy)	NSString *str_username;
@property(nonatomic,copy)	NSString *str_password;

-(IBAction) btn_Action_ForgotPassword;
-(IBAction) btn_Action_SignIn;
-(IBAction) btn_Action_SignUp;


-(void)performLogin;
-(void)removeSpinnerAndLoginView:(id) results;
-(void)LoadImageFromServer:(id)Sender;
@end
