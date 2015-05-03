//
//  ForgotPasswordVC.h
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForgotPasswordVC : UIViewController<UITextFieldDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UITextField *txt_emailAddress;
	IBOutlet UILabel *lbl_forgotPasswordText;
	/////////////////////////////////////////
	IBOutlet UIButton *btn_back;
	IBOutlet UIButton *btn_Submit;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

-(void)performForgotPasswordAction;

-(IBAction) btn_Action_Back;
-(IBAction) btn_action_Submit;

-(void)removeSpinnerFromForgotView:(id) results;
@end
