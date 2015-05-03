//
//  GroupPeopleBO.h
//  WizTank
//
//  Created by Shafqat on 2/10/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupPeopleBO : NSObject {
	NSString *str_countryName;
	NSString *str_fName;
	NSString *str_gender;
	NSString *str_imgPath;
	NSString *str_lName;
	NSString *str_userID;
	BOOL isFollowing;
}

@property(nonatomic,retain) NSString *str_countryName;
@property(nonatomic,retain) NSString *str_fName;
@property(nonatomic,retain) NSString *str_gender;
@property(nonatomic,retain) NSString *str_imgPath;
@property(nonatomic,retain) NSString *str_lName;
@property(nonatomic,retain) NSString *str_userID;
@property BOOL isFollowing;
@end
