//
//  GroupsBarItem.h
//  WizTank
//
//  Created by Shafqat on 1/18/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupsBL.h"
#import "WaitingView.h"
#import "GroupDataBO.h"
#import "FavoriteBO.h"
#import "LocationsBO.h"

@interface GroupsBarItem : UIViewController<UITextFieldDelegate,UITableViewDelegate> {
	IBOutlet UITextField *txt_searchField;
	IBOutlet UIButton * btn_meFollowing;
	IBOutlet UIButton *btn_FollowingMe;
	IBOutlet UIButton *btn_favorites;
	IBOutlet UIButton *btn_recommendations;
	IBOutlet UILabel *lbl_heading;
	IBOutlet UILabel *lbl_tblHeaderLine;
	IBOutlet UITableView *tbl_details;
	IBOutlet UITableViewCell *tbl_cellFollowers;
	IBOutlet UITableViewCell *tbl_cellFavorites;
	IBOutlet UIImageView *imgV_txtBackground;
	IBOutlet UIButton *btn_back;
	IBOutlet UILabel *lbl_SearchResults;
	IBOutlet UILabel *lbl_tableHeaderLine;
	BOOL isSearchResultScreen;
	int btnSelected;
	////////////////////////
	NSString *str_SearchPeopleText;
	WaitingView *_waitingView;
	NSMutableArray *SearchPeopleResults;
	////////////////////////
	int numberOfRows4Table; /// this for removing the waiting view from the UI//
	int PressedButtonIndex;
	///////////////////////
	GroupDataBO *obj_SharedGroupData;
	BOOL isLoadingFirstTime;
}
#pragma mark Properties
@property (nonatomic,retain) GroupDataBO *obj_SharedGroupData;
@property  int PressedButtonIndex;
@property (nonatomic,retain) NSMutableArray *SearchPeopleResults;
@property(nonatomic,copy) NSString *str_SearchPeopleText;
@property(nonatomic,retain) UITableViewCell *tbl_cellFollowers;
@property(nonatomic,retain) UITableViewCell *tbl_cellFavorites;

#pragma mark IBActions
-(IBAction)btn_Action_SearchPeople;
-(IBAction)btn_Action_meFollowing;
-(IBAction)btn_Action_FollowingMe;
-(IBAction)btn_Action_favorites;
-(IBAction)btn_Action_recommendations;
-(IBAction)btn_Action_followPerson:(id)Sender;
-(IBAction)btn_Action_unFollowPerson:(id)Sender;
-(IBAction)btn_Action_back;
#pragma mark methods
-(UITableViewCell *) GetCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *) getCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *) GetCellForCase0and4:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)changeButtonState:(id)Sender;
-(void)HideOrShowButtons:(BOOL) isHide;
-(void)SetTablePosition:(int)IncrementedValue;
-(void)SearchPeopleNetworkCall;
-(void)HandleSearchPeolpleResponse:(id)results;
-(void)LoadWaitingView;
-(void)UnLoadWaitingView;
-(void)UnfollowPersonCall:(id)Sender;
-(void)HandleUnfollowPersonResponse:(id)Sender;
-(void)followPersonCall:(id)Sender;
-(void)HandlefollowPersonResponse:(id)Sender;
-(void)LoadDataForPplIamFollowing;
-(void)HandlePplIamFollowingResponse:(id) results;
-(void)LoadDataForPplFollowingMe;
-(void)LoadDataForFavorites;
-(void)HandleFavoritesResponse:(id)results;
-(void)LoadDataForRecommendation;
-(void)HandleRecommendationResponse:(id)results;
-(void)HandleFavoriteOrRecommended:(NSNotification *)note;
-(void) CallviewDidUnload;
@end
