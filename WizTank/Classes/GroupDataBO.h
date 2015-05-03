//
//  GroupDataBO.h
//  WizTank
//
//  Created by Shafqat on 2/13/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupDataBO : NSObject {
	NSMutableArray *arr_PplFollowingMe;
	NSMutableArray *arr_PplMeFollowing;
	NSMutableArray *arr_Recommendations;
	NSMutableArray *arr_Favorites;
}

@property(nonatomic,retain) NSMutableArray *arr_PplFollowingMe;
@property(nonatomic,retain) NSMutableArray *arr_PplMeFollowing;
@property(nonatomic,retain) NSMutableArray *arr_Recommendations;
@property(nonatomic,retain) NSMutableArray *arr_Favorites;


@end
