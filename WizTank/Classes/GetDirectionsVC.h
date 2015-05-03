//
//  GetDirectionsVC.h
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedDirectionVC.h"
#import "WaitingView.h"

@interface GetDirectionsVC : UIViewController <UITextFieldDelegate>{
	IBOutlet UITextField *txt_startLocation;
	IBOutlet UITextField *txt_EndLocation;
	IBOutlet UIScrollView *scrollView;
	WaitingView *_waitingView;
	NSCharacterSet *blockedCharacters;
}
-(IBAction)btn_Action_back;
-(IBAction)btn_Action_done;
-(IBAction)btn_Action_seeOnMap;
-(void)getDirections;
-(void)UnLoadWaitingView;
-(void)LoadWaitingView;
@end
