//
//  DAL.h
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterBO.h"
#import "GroupPeopleBO.h"
#import "LocationsBO.h"
#import <CoreLocation/CoreLocation.h>
#import "FavoriteBO.h"
@interface DAL : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}
#pragma mark Login
+(NSDictionary *) LoginRequest:(NSString *)userName password:(NSString *)Password;
+(NSString *) LoginrequestJSON:(NSString *)userName password:(NSString *)Password;
+(NSDictionary *)ParseLoginResponse:(NSString *)responseStr;
#pragma mark Registration
+(NSDictionary *) RegisterRequest:(RegisterBO *)regObj;
+(NSString *)RegisterJSon:(RegisterBO *)regObj;

#pragma mark ForgotPassword
+(NSDictionary *)ForgotPasswordRequest:(NSString *)email;

#pragma mark logout
+(NSDictionary *)LogoutUser;
#pragma mark FindPlaces
+(NSDictionary *)CloseByCall;
+(NSMutableArray *) ParseCloseByResponse:(NSString *)responseStr;
+(NSDictionary *)searchPlaces:(NSString *)searchQuerry:(int)catID;
+(NSMutableArray *) ParseSearchPlacesResponse:(NSString *)responseStr:(BOOL)isCloseBY;
#pragma mark CategoriesList
+(NSDictionary *)getCategoriesList;
+(NSMutableArray *)ParseCategoryList:(NSString *)responseStr;
+(NSMutableArray *)parseRecursiveCategories:(NSMutableDictionary*)subCatDictionary;
#pragma mark updateRequest
+(NSDictionary *) updateRequest:(RegisterBO *)regObj;
#pragma mark Groups
+(NSDictionary *)SearchPeopleInBubble:(NSString *)searchText;
+(NSDictionary *)ParseSearchPeopleDocument:(id)results;
+(NSDictionary *)UnfollowPerson:(NSString *)uID isFollow:(int)value;
+(NSDictionary *)PplIamFollowing;
+(NSDictionary *)ParsePeopleIamFollowing:(id)results;
+(NSDictionary *)PplFollowingMe;
+(NSDictionary *)MyFavorites;
+(NSDictionary *)HandleFavoriteListRespose:(NSString *)requestJSON;
+(NSDictionary *)MyRecommendations;
+(NSDictionary *)HandleRecommendationsListRespose:(NSString *)requestJSON;
#pragma mark CalculateDistance
+(float)calculateDistace:(LocationsBO*)locationBO;
#pragma mark addToFavorites
+(NSDictionary*)addToFavorites:(int)locationID;
#pragma mark RecommendLocation
+(NSDictionary*)recommendLocation:(int)locationID;
#pragma mark ReportAnIssue
+(NSDictionary*)reportAnIssue:(int)locationID:(NSString*)issue;
#pragma mark getRoutes
+(NSDictionary*)getRoutes:(NSString*)startLocation:(NSString*)endLocation;
+(NSMutableArray*)handleResponseForRoute:(NSString*)responseString;
+(NSString *)flattenHTML:(NSString *)html;

#pragma mark Get Route Points for drawing path on map

+(NSDictionary*)RequestToGetDirectionsForGivenDestinations:(NSString*)startLocation:(NSString*)endLocation;
+(NSDictionary*)handleResponseForPoints:(NSString*)responseString;
+(NSMutableArray *)decodePolyLine:(NSString *)encodedStr;

@end