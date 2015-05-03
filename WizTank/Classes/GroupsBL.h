//
//  GroupsBL.h
//  WizTank
//
//  Created by Shafqat on 2/10/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAL.h"

@interface GroupsBL : NSObject {

}
+(NSDictionary *)SearchPeopleInBubble:(NSString *)searchText;
+(NSDictionary *)UnfollowPerson:(NSString *)uID isFollow:(int)value;
+(NSDictionary *)PplIamFollowing;
+(NSDictionary *)PplFollowingMe;
+(NSDictionary *)MyFavorites;
+(NSDictionary *)MyRecommendations;
@end
