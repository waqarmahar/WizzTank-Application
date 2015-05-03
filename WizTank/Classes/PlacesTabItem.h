//
//  PlacesTabItem.h
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GetDirectionsVC.h"
#import "CategoryListView.h"
#import "AutoCompleteView.h"

@interface PlacesTabItem : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate,CategoryProtocol,BusinessObjectsAutoCompleteProtocol> {
	IBOutlet UILabel *lbl_upperBarText;
	IBOutlet UITextField *txt_SearchBar;
	IBOutlet UIButton *btn_find;
	IBOutlet UIButton *btn_advancedSearched;
	IBOutlet UIButton *btn_browse;
	IBOutlet UILabel *lbl_findWhats;
	IBOutlet UIButton *btn_closeBy;
	IBOutlet UILabel *lbl_get;
	IBOutlet UIButton *btn_directions;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	CLLocationManager *locationFinder;
	NSCharacterSet *blockedCharacters;
	//BOOL isCloseBy;
	AutoCompleteView *autoComplete;
}
-(IBAction) btn_Action_findPlace;
-(IBAction) btn_Action_advancedSearch;
-(IBAction) btn_Action_browse;
-(IBAction) btn_Action_closeBy;
-(IBAction) btn_Action_directions;

-(void)CategoryName:(int)catID;
-(void)RemoveSpinner4CloseByCall:(id)Sender;
-(void)findNearestPlaces;
-(void)searchPlaces;
-(void)RemoveSpinner4SearchPlacesCall:(id)Sender;

////// AutoComplete

-(void)searchAutoCompleteBusiness;
-(void)addPlacesTable:(id)Sender;
-(void)psuhtoDeTailsVC:(LocationsBO*)businessObject;
@end
