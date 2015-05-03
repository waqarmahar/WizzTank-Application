//
//  SearchResultsVC.h
//  WizTank
//
//  Created by Shafqat on 1/6/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryListView.h"
#import "LocationsBO.h"
#import "SearchPlacesBO.h"
#import "WaitingView.h"

@interface SearchResultsVC : UIViewController<UITableViewDelegate,CategoryProtocol,UITextFieldDelegate> {
	IBOutlet UILabel *lbl_upperBarText;
	IBOutlet UIButton *btn_refineSearch;
	IBOutlet UIButton *btn_seeOnMap;
	IBOutlet UILabel *lbl_totalCount;
	IBOutlet UIButton *btn_Name;
	IBOutlet UIButton *btn_Location;
	IBOutlet UIButton *btn_Distance;
	IBOutlet UITableView *tbl_results;
	IBOutlet UITableViewCell *tblCell;
	IBOutlet UITextField *txt_upperSearchBar;
	IBOutlet UIImageView *imgV_uppertextfield;
	IBOutlet UIButton *btn_Search;
	BOOL isCloseByResults;
	NSString *searchquery;
	NSMutableArray *placesArray;
	IBOutlet UILabel *lbl_Name;
	IBOutlet UILabel *lbl_Location;
	IBOutlet UILabel *lbl_Distance;
	WaitingView *_waitingView;	
	NSString *searchQuery;
	NSCharacterSet *blockedCharacters;
	
}
@property BOOL isCloseByResults;
@property(nonatomic,retain) UITableViewCell *tblCell;
@property (nonatomic,retain)NSString *searchquery;
@property (nonatomic,retain)NSMutableArray *placesArray;
@property(nonatomic,retain) NSString *searchQuery;
-(IBAction) btn_Action_Search;
-(IBAction) btn_Action_back;
-(IBAction) btn_Action_refineSearch;
-(IBAction) btn_Action_seeOnMap;
-(IBAction) btn_Action_Name;
-(IBAction) btn_Action_Location;
-(IBAction) btn_Action_Distance;
-(void)AccesoryViewButtonPressed:(SearchPlacesBO*)places;
-(void)CategoryName:(int)categoryID;

-(void)UnLoadWaitingView;
-(void)LoadWaitingView;
-(void)reloadPlaces:(NSMutableArray*)placesArrayResult;
@end
