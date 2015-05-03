//
//  LocationDetailVC.h
//  WizTank
//
//  Created by Shafqat on 1/17/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportAnIssue.h"
#import "LocationsBO.h"
#import "WaitingView.h"
#import "SearchResultsVC.h"

@interface LocationDetailVC : UIViewController <ReportIssueProtocol,UITextFieldDelegate,UITableViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UITextField *txt_searchField;
	IBOutlet UILabel *lbl_ProductName;
	IBOutlet UILabel *lbl_recommendedCount;
	IBOutlet UILabel *lbl_recommendedBy;
	IBOutlet UILabel *lbl_categoryType;
	IBOutlet UILabel *lbl_webAddress;
	IBOutlet UITableView *tbl_branches;
	IBOutlet UITableViewCell *tbl_cell;
	IBOutlet UIButton *btn_contact;
	IBOutlet UILabel *lbl_contact;
	IBOutlet UILabel *lbl_locationName;
	IBOutlet UILabel *lbl_distance;
	LocationsBO *placesObjet;
	WaitingView *_waitingView;
	int FavoriteORrecommend;
	NSString  *destinationLocation;
	NSCharacterSet *blockedCharacters;
	SearchResultsVC *delegate;
	
}

@property(nonatomic,retain) UITableViewCell *tbl_cell; 
@property(nonatomic,retain)LocationsBO *placesObjet;
@property (nonatomic,retain) NSString  *destinationLocation;
@property (nonatomic,retain) SearchResultsVC *delegate;
-(IBAction)btn_Action_Search;
-(IBAction)btn_Action_addToFavorites;
-(IBAction)btn_Action_reportAnIusse;
-(IBAction)btn_Action_recommend;
-(IBAction)btn_Action_share;
-(IBAction)btn_Action_callNumber;
-(IBAction)btn_Action_SortOnLocation;
-(IBAction)btn_Action_SortOnDistance;
-(IBAction)btn_Action_back;
-(IBAction)btn_Action_GetDirection:(id)sender;
-(IBAction)btn_Action_SeeOnMap:(id)sender;

#pragma mark methods
-(void)IssueText:(NSString *)txt;
#pragma mark getRoutes
-(void)getRoutes:(NSDictionary*)sender;
-(void)RemoveSpinner4RoutesCall:(id)Sender;
-(void)RemoveSpinner4SearchPlacesCall:(id)Sender;

-(void)UnLoadWaitingView;
-(void)LoadWaitingView;

@end
