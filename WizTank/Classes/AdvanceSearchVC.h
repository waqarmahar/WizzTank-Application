//
//  AdvanceSearchVC.h
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingView.h"

@interface AdvanceSearchVC : UIViewController<UITextFieldDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UITextField *txt_hint;
	IBOutlet UITextField *txt_location;
	WaitingView *_waitingView;
	NSCharacterSet *blockedCharacters;
}
-(IBAction) btn_Action_back;
-(IBAction) btn_Action_Search;
-(void)UnLoadWaitingView;
-(void)LoadWaitingView;

@end
