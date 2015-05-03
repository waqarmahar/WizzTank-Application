//
//  FeedsBarItem.h
//  WizTank
//
//  Created by Shafqat on 1/18/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedsBarItem : UIViewController<UITableViewDelegate> {
	IBOutlet UITableView *tbl_feeds;
	IBOutlet UITableViewCell *tbl_cell;
}

@property(nonatomic,retain) UITableViewCell *tbl_cell;

@end
