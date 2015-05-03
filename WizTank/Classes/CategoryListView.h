//
//  RefineOnCloseByView.h
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CategoryProtocol<NSObject>

-(void)CategoryName:(int)name;

@end
@interface CategoryListView : UIView <UITableViewDelegate> {
	IBOutlet UITableView *tbl_categories;
	IBOutlet UIView *view_innerView;
	NSString *str_selectedCategory;
	IBOutlet UIView *view_TransparentView;
	id <CategoryProtocol> delegate;
	NSMutableArray *categoriesArray;
	int selectedCategoryID;
	IBOutlet UIActivityIndicatorView *indicator;
}
@property (nonatomic,retain) id <CategoryProtocol> delegate;
@property (nonatomic,retain) NSString *str_selectedCategory;
@property (nonatomic,retain)NSMutableArray *categoriesArray;
-(void)AccesoryViewButtonPressed:(id)Sender;
+(UIView*) loadInstanceFromNib;
-(IBAction) btn_Action_Done;
-(IBAction) btn_Action_cross;
-(void)addToTransparentView;
-(void)getCategories;
-(void)reloadTable;
-(void)addActivityIndicator;
@end
