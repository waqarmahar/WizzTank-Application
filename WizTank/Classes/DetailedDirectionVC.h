//
//  DetailedDirectionVC.h
//  WizTank
//
//  Created by Shafqat on 1/16/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportAnIssue.h"
#import "WaitingView.h"
#import "SearchResultsVC.h"

@interface DetailedDirectionVC : UIViewController <ReportIssueProtocol,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITextField *txt_searchfield;
	IBOutlet UITableView *tbl_routes;
	IBOutlet UITableView *tbl_routesDetails;
	IBOutlet UITableViewCell *tbl_Cell;
	NSMutableArray *routesArray;
	int selectedIndex;
	WaitingView *_waitingView;
	NSString *sourceLocation;
	NSString *destinationLocation;
	SearchResultsVC *delegate;
}
@property(nonatomic,retain) UITableViewCell *tbl_Cell;
@property(nonatomic,retain) NSMutableArray *routesArray;
@property(nonatomic,readwrite) int selectedIndex;
@property(nonatomic,retain) NSString *sourceLocation;
@property(nonatomic,retain) NSString *destinationLocation; 
@property(nonatomic,retain) SearchResultsVC *delegate;
-(IBAction)btn_Action_back;
-(IBAction)btn_Action_search;
-(IBAction)btn_Action_reportAnIssue;
-(IBAction)btn_Action_seeOnMap;
-(void)IssueText:(NSString *)txt;
-(void)RemoveSpinner4DirectionCall:(id)Sender;
-(void)getDirections;
-(void)UnLoadWaitingView;
-(void)LoadWaitingView;
+(UIViewController*)getRequiredViewControllerFromStack:(NSArray*)viewControllers nibName:(NSString*)requiredNibName;


@end
