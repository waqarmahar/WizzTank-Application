//
//  DAL.m
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//
#import "MapKit/MapKit.h"
#import "DAL.h"
#import "SBJsonParser.h"
#import "NetworkController.h"
#import "Base64.h"
#import "CloseByBO.h"
#import "SearchPlacesBO.h"
#import "CategoryListBO.h"
#import "LocationsBO.h"
#import "RouteBO.h"
#import "NSObject+SBJSON.h"
//////////////
#define GetRecommendatedAPI @"getrecommendations"
#define GetFavouritesAPI @"getfavourites"
#define AuthenticateAPI @"authenticate"
#define PplFollowingMeAPI @"followedby"
#define PplIamFollowingAPI @"following"
#define FollowUnFollowAPI @"follow"
#define SearchPeopleAPI @"searchnetwork"
#define LogOutAPI @"logout"
#define LoginApi @"login"
#define RegistrationAPI @"register"
#define ForgotPasswordAPI @"forgotpass"
#define searchPlacesAPI @"search"
#define CloseByAPI @"closeby"
#define CloseByAPIResponse	@"CloseByResult"
#define CategoryListAPI @"categories"
#define BASE_URL @"http://www.wiztank.com/wiztankwebservice/api.svc/"
#define ForgotPasswordAPIJSON @"ForgotPasswordResult"
#define LogOutAPIResponseJSOn @"LogoutResult"
#define FavoritesResponseJSOn @"GetFavouritesResult"
#define RecommendationsResponse @"GetRecommendationsResult"
#define SearchPeopleAPIResponse @"SearchNetworkResult"
#define FollowUnFollowResponse @"FollowResult"
#define SearchResultAPIResponse @"SearchResult"
#define FollowingResultResponse @"FollowingResult"
#define FollowingMeResponse @"FollowedByResult"
#define loginResponseResult @"LoginResult"
#define CategoryListAPIResponse @"CategoriesResult"

#define RegisterResponse @"RegisterResult"
#define updateprofile @"updateprofile"
#define updateprofileResponse @"UpdateProfileResult"
#define addToFavouriteAPI @"addtofavourite"
#define addToFavouriteResponse @"AddToFavouriteResult"
#define recommendLocationAPI @"recommend"
#define recommendLocationAPIResponse @"RecommendResult"
#define ReportAnIssueAPI @"reportissue"
#define ReportAnIssueAPIResponse @"ReportAnIssueResult"

@implementation DAL

- (void)initialize {
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy =kCLLocationAccuracyBest; // 100 m	
	[locationManager startUpdatingLocation];	
}

#pragma mark Login
+(NSDictionary *) LoginRequest:(NSString *)userName password:(NSString *)Password{
	
	NSError *errorObj=nil;
	
	//NSString *requestJSON=[NSString stringWithFormat:@"authUser=%@&authPass=%@&locale=%@&user=%@&pass=%@",
						  // authUserNameKey,authPasswordKey,USLocaleKey,userName,Password];
	
	NSString *responseStr=@"";
    NSString *user=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pass=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([userName isEqualToString:user] && [Password isEqualToString:pass]) {
        
    }
    else{
        errorObj=[NSError errorWithDomain:@"Username or password is incorrect" code:0 userInfo:nil];
    }
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		NSDictionary *dict = [NSDictionary dictionaryWithObject:responseStr forKey:SuccessKey];
		
		return dict;
	}
	
}
+(NSDictionary *)ParseLoginResponse:(NSString *)responseStr
{
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:loginResponseResult];
		
		[[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:authTokenKey] forKey:authTokenKey];
		dict=[dict objectForKey:@"userInfo"];
		RegisterBO *regBO=[[RegisterBO alloc] init];
		regBO.str_country=[dict objectForKey:countryKey];
		regBO.str_dob=[dict objectForKey:dobKey];
		regBO.str_email=[dict objectForKey:emailKey];
		regBO.str_Fname=[dict objectForKey:fNamekey];
		regBO.str_gender=[dict objectForKey:genderKey];
		regBO.str_ImageURL=[dict objectForKey:imageURLKey];
		regBO.str_Lname=[dict objectForKey:lNameKey];
		regBO.str_phone=[dict objectForKey:phoneKey];
		[[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:UserIDKey] forKey:UserIDKey];
		
		NSDictionary *resultDic=[NSDictionary dictionaryWithObject:regBO forKey:SuccessKey];
		
		return resultDic;
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	
	return nil;
}
+(NSString *) LoginrequestJSON:(NSString *)userName password:(NSString *)Password{
	NSMutableDictionary *JSONDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [JSONDictionary setObject:userName forKey:emailKey];
    [JSONDictionary setObject:Password forKey:passwordKey];

	return [JSONDictionary JSONRepresentation];
}

#pragma mark Registration
+(NSDictionary *) RegisterRequest:(RegisterBO *)regObj{
	//NSString *requestJSON=[DAL RegisterJSon:regObj];
	NSError *errorObj=nil;
	NSString *requestJSON=[NSString stringWithFormat:@"authUser=%@&authPass=%@&locale=%@&user=%@&pass=%@&fn=%@&ln=%@&em=%@&gnd=%@&dob=%@&cnt=%@&ph=%@&b64image=%@",
							                                        authUserNameKey,authPasswordKey,USLocaleKey,regObj.str_email,regObj.str_password,regObj.str_Fname,
																							regObj.str_Lname,regObj.str_email,regObj.str_gender,regObj.str_dob,
																							regObj.str_country,regObj.str_phone,[Base64 encode:regObj.picData]];
	
	
	 
	//NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:RegistrationAPI];
    NSString *responseStr=@"";
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:responseStr forKey:SuccessKey];
        
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_email forKey:@"username"];
		[[NSUserDefaults standardUserDefaults] setObject:regObj.str_password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_Fname forKey:@"fname"];
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_Lname forKey:@"lname"];
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_country forKey:@"country"];
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_gender forKey:@"gener"];
        [[NSUserDefaults standardUserDefaults] setObject:regObj.str_dob forKey:@"dob"];
        
		return dict;
	}
}
+(NSString *)RegisterJSon:(RegisterBO *)regObj{
	NSMutableDictionary *JSONDictionary=[NSMutableDictionary dictionary];
	[JSONDictionary setObject:regObj.str_Fname forKey:fNamekey];
	[JSONDictionary setObject:regObj.str_Lname forKey:lNameKey];
	[JSONDictionary setObject:regObj.str_gender forKey:genderKey];
	[JSONDictionary setObject:regObj.str_dob forKey:dobKey];
	[JSONDictionary setObject:regObj.str_country forKey:countryKey];
	[JSONDictionary setObject:regObj.str_phone forKey:phoneKey];
	[JSONDictionary setObject:regObj.str_email forKey:usernameKey];
	[JSONDictionary setObject:regObj.str_password forKey:passwordKey];
	[JSONDictionary setObject:[Base64 encode:regObj.picData] forKey:imageKey];
	
	return [JSONDictionary JSONRepresentation];
}
#pragma mark UpDateRequest
+(NSDictionary *) updateRequest:(RegisterBO *)regObj;{
	NSError *errorObj=nil;
	NSString *authenticationKey = [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey];
	NSString *userID =	[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey];
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&fn=%@&ln=%@&em=%@&gnd=%@&dob=%@&cnt=%@&ph=%@&b64image=%@",
						   authenticationKey,USLocaleKey,userID,regObj.str_Fname,
						   regObj.str_Lname,regObj.str_email,regObj.str_gender,regObj.str_dob,
						   regObj.str_country,regObj.str_phone,[Base64 encode:regObj.picData]];
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:updateprofile];
//	NSLog(@"responseStr%@",responseStr);
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		dict=[dict objectForKey:updateprofileResponse];
		[parser release];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return dict;
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		return dict;
	}
}
#pragma mark LogOut
+(NSDictionary *)LogoutUser{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:LogOutAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:LogOutAPIResponseJSOn];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				////Removing items from NSUserDefaults
				[[NSUserDefaults standardUserDefaults] removeObjectForKey:authTokenKey];
				[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIDKey];
				return [NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:SuccessKey];
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
}
#pragma mark ForgotPassword
+(NSDictionary *)ForgotPasswordRequest:(NSString *)email
{
	//////////////////////////////////////////
	NSString *requestJSON=[NSString stringWithFormat:@"authUser=%@&authPass=%@",authUserNameKey,authPasswordKey];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:AuthenticateAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:@"AuthenticateResult"];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				///////////////////////////////////////////////////////////////
				NSString *authTokenValue=[dict objectForKey:@"authKey"];
				requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&em=%@",authTokenValue,USLocaleKey,email];
				errorObj=nil;
				responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:ForgotPasswordAPI];
				if (errorObj) {
					return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
				}
				else {
					parser = [[SBJsonParser alloc] init];
					dict = [parser objectWithString:responseStr];
					[parser release];
					dict=[dict objectForKey:ForgotPasswordAPIJSON];
					if ([dict objectForKey:@"status"]) {
						if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
							return [NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:SuccessKey];
						}
						else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
							NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
							return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
						}	
					}
					return dict;
				}
				////////////////////////////////////////////////////////////////
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
	}
	//////////////////////////////////////////
	return nil;
}
#pragma mark FindPlaces
+(NSDictionary *)CloseByCall{
	@try {
		NSString *requestJSON=nil;
		requestJSON =[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&userCurrentLatitude=%@&userCurrentLongitude=%@&radius=500",
					  [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey],[[NSUserDefaults standardUserDefaults] objectForKey:LatitudeKey] 
																											   ,[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]];

//		requestJSON =[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&userCurrentLatitude=29.334672&userCurrentLongitude=48.08311&radius=2000",
//					  [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]/*,[[NSUserDefaults standardUserDefaults] objectForKey:LatitudeKey] 
//					  ,[[NSUserDefaults standardUserDefaults] objectForKey:LongitudeKey]*/];
		
		NSError *errorObj=nil;
		NSLog(@"request Json%@",requestJSON);
		NSString *responseStr=@"a";//[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:CloseByAPI];
		if (errorObj) {
			return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
		}
		else {
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			NSDictionary *dict = [parser objectWithString:responseStr];
			//dict=[dict objectForKey:CloseByAPIResponse];
			//if ([dict objectForKey:@"status"]) {
				//if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
					NSMutableArray *array=[DAL ParseSearchPlacesResponse:responseStr:YES];				
					return [NSDictionary dictionaryWithObject:array forKey:SuccessKey];	
				//}
				if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
					NSDictionary *dictNoResult = [parser objectWithString:responseStr];
					[parser release];
					dictNoResult=[dictNoResult objectForKey:CloseByAPIResponse];
					NSMutableArray *placesArray = [dictNoResult objectForKey:@"businesses"];
					if ([placesArray count]<1) {
						NSError *error=[NSError errorWithDomain:@"no results found" code:201 userInfo:nil];
						return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
					}
					else {
						NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
						return [NSDictionary dictionaryWithObject:error forKey:FailureKey];	
					}
				}				
			//}
			return dict;
		}		
	}
	@catch (NSException * e) {
		NSLog(@"exception Occured");
	}
	@finally {
		
	}
	return nil;
}
+(NSMutableArray *) ParseCloseByResponse:(NSString *)responseStr{
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *dict = [parser objectWithString:responseStr];
	[parser release];
	NSMutableArray *returnArray=[NSMutableArray array];
	NSArray *locationsInfoArray = [dict objectForKey:@"results"];
	for (int i=0;i<[locationsInfoArray count];i++) {
		CloseByBO *obj=[[CloseByBO alloc] init];
		dict = [locationsInfoArray objectAtIndex:i];
		obj.str_name = [dict objectForKey:@"name"];
		obj.str_vicinity = [dict objectForKey:@"vicinity"];
		dict=[[dict objectForKey:@"geometry"] objectForKey:@"location"];
		CLLocationCoordinate2D loc;
		loc.latitude=[[dict objectForKey:@"lat"] floatValue];
		loc.longitude=[[dict objectForKey:@"lng"] floatValue];
		LocationsBO *locationInfo = [[LocationsBO alloc]init];
		locationInfo.latitude = loc.latitude;
		locationInfo.longitude = loc.longitude;
		obj.f_distance = [self calculateDistace:locationInfo];
		obj.placeLocation=loc;
		[returnArray addObject:obj];
		[locationInfo release];
		[obj release];

	}
	return returnArray;
}
+(NSDictionary *)searchPlaces:(NSString *)searchQuerry:(int)catID{
	
	NSString *requestJSON=nil;
	/*if (catID == -1) {
		//// ssimnple Search
		requestJSON =[NSString stringWithFormat:@"auth=%@&locale=%@&search=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,searchQuerry];
	
	}
	else if([searchQuerry isEqualToString:@"refine"]) {
		//// Refined search based on category Only
		requestJSON =[NSString stringWithFormat:@"auth=%@&locale=%@&categories=%i",[[NSUserDefaults standardUserDefaults] 
																					objectForKey:authTokenKey],USLocaleKey,catID];
	}
	else {
		//// Refined search based on category and searchQuery	
		requestJSON =[NSString stringWithFormat:@"auth=%@&locale=%@&search=%@%,%i",[[NSUserDefaults standardUserDefaults] 
																					objectForKey:authTokenKey],USLocaleKey,searchQuerry,catID];
	}
     */
	//NSLog(@"response requestJSON %@",requestJSON);
	NSError *errorObj=nil;
	//NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:searchPlacesAPI];
	//NSLog(@"response responseStr %@",responseStr);
	NSString *responseStr=@"a";
    if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		//dict=[dict objectForKey:SearchResultAPIResponse];
		//if ([dict objectForKey:@"status"]) {
			//if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				NSMutableArray *array=[DAL ParseSearchPlacesResponse:responseStr:NO];				
				return [NSDictionary dictionaryWithObject:array forKey:SuccessKey];	
			//}
			if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				SBJsonParser *parser = [[SBJsonParser alloc] init];
				NSDictionary *dictNoResult = [parser objectWithString:responseStr];
				[parser release];
				dictNoResult=[dictNoResult objectForKey:SearchResultAPIResponse];
				NSMutableArray *placesArray = [dictNoResult objectForKey:@"businesses"];
				if ([placesArray count]<1) {
					NSError *error=[NSError errorWithDomain:@"no results found" code:201 userInfo:nil];
					//NSLog(@"result is %@",[error localizedDescription]);
					return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
				}
				else {
					NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
					return [NSDictionary dictionaryWithObject:error forKey:FailureKey];	
				}
			}				
		//}
		return dict;
	}
}
+(NSMutableArray *) ParseSearchPlacesResponse:(NSString *)responseStr:(BOOL)isCloseBY{
@try {
	
//	SBJsonParser *parser = [[SBJsonParser alloc] init];
//	NSDictionary *dict = [parser objectWithString:responseStr];
//	if (isCloseBY) {
//		dict=[dict objectForKey:CloseByAPIResponse];
//	}
//	else{		  
//		dict=[dict objectForKey:SearchResultAPIResponse];
//	}
//	[parser release];
	NSMutableArray *returnArray=[[NSMutableArray alloc] init];
	//NSMutableArray *placesArray = [dict objectForKey:@"businesses"];
	//NSLog(@"Count %d",[placesArray count]);
	for (int i=0; i<4;i++) {
		SearchPlacesBO *obj=[[SearchPlacesBO alloc] init];
		
        obj.businessID =12;
		//NSLog(@"obj.businessID%i",obj.businessID);
		NSMutableArray *CategoriesTemp = [[NSMutableArray alloc]init];
		//NSArray *categoriesArray = [dict objectForKey:@"categories"];
		for (int j=0; j<3; j++) {
			CategoryListBO *category = [[CategoryListBO alloc]init];
			
            category.categoryID =1;
			category.str_name = @"Burger";
			[CategoriesTemp addObject:category];
			obj.categories = CategoriesTemp;
			[category release];
			//[CategoriesTemp release];
		}
		//NSLog(@"Cat count%i",[obj.categories count]);
		obj.description = @"Burger";
		obj.email =@"testing@ab.com";
		obj.fax = @"11-1323";
		obj.email = @"testing@abc.com";
		obj.officialName = @"Burger HUb";
		obj.phone = @"778979";
        obj.thumbnail = nil;
		obj.website = @"www.burgerhub.com";
		NSArray *locationsArray = [NSMutableArray array];
		
		for (int k = 0; k<10; k++) {
			LocationsBO *locationsBO = [[LocationsBO alloc]init];
			NSMutableDictionary *dictionary = [locationsArray objectAtIndex:k];
			locationsBO.avenue = [dictionary objectForKey:@"avenue"];
			locationsBO.block  = [dictionary objectForKey:@"block"];
			locationsBO.email  = [dictionary objectForKey:@"email"];
			locationsBO.fax    = [dictionary objectForKey:@"fax"];
			locationsBO.latitude = [[dictionary objectForKey:@"latitude"] floatValue];
			locationsBO.locationId = [[dictionary objectForKey:@"locationId"] intValue];
			locationsBO.longitude  = [[dictionary objectForKey:@"longitude"] floatValue];
			locationsBO.distance = [self calculateDistace:locationsBO];
			locationsBO.phone  = [dictionary objectForKey:@"phone"];
			locationsBO.plot = [dictionary objectForKey:@"plot"];
			locationsBO.recommendedBy = [dictionary objectForKey:@"recommendedBy"];
			locationsBO.officialName = obj.officialName; 
			locationsBO.street =[dictionary objectForKey:@"street"];
			locationsBO.area = [dictionary objectForKey:@"area"];
			locationsBO.businessObject = obj;
			//[detailedLocation addObject:locationsBO];
			//obj.locations = detailedLocation;
			[returnArray addObject:locationsBO];
			[locationsBO release];
		}
         
		//NSLog(@"Cat count%i",[obj.categories count]);
        [returnArray addObject:obj];
		[obj release];
	}
	return returnArray;
	
	}	
@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Unable to parse the Response" code:1 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}		
}
+(float)calculateDistace:(LocationsBO *)locationBO
{
	CLLocation *pointALocation = [[[CLLocation alloc] initWithLatitude:locationBO.latitude longitude:locationBO.longitude] autorelease];  	
	//NSLog(@"locationBO lat %f and  long are %f ",locationBO.latitude,locationBO.longitude);
	float lat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"] floatValue];
	float longt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"] floatValue];
	//NSLog(@"Current lat %f and  long are %f ",lat,longt);
	CLLocation *pointBLocation = [[[CLLocation alloc] initWithLatitude:lat longitude:longt] autorelease];  
    float distanceMeters = [pointBLocation distanceFromLocation:pointALocation];	
    distanceMeters = lroundf(distanceMeters / 1000);
	//NSLog(@"Distance%f",distanceMeters);
	return distanceMeters;
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	float lat = newLocation.coordinate.latitude;
	[prefs setFloat:lat forKey:@"Latitude"];
	[prefs synchronize];
	
	float longt = newLocation.coordinate.longitude;
	[prefs setFloat:longt forKey:@"Longitude"];
	[prefs synchronize];	
}
#pragma mark getRoutes
+(NSDictionary*)getRoutes:(NSString*)startLocation:(NSString*)endLocation{
		NSString *urlString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&alternatives=true&sensor=false",startLocation,endLocation];
		NSError *errorObj=nil;
		NSString *responseStr=[[NetworkController SharedNetworkInstance] RoutesFromGoogle:urlString :&errorObj];
		if (errorObj) {
			return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
		}
		else {
			SBJsonParser *parser = [[SBJsonParser alloc] init];
			NSDictionary *dict = [parser objectWithString:responseStr];
			[parser release];
			if ([dict objectForKey:@"status"]) {
				if ([[dict objectForKey:@"status"] isEqualToString:OkKey]) {
				////Parse the result here////
					NSMutableArray *array=[DAL handleResponseForRoute:responseStr];
					return [NSDictionary dictionaryWithObject:array forKey:SuccessKey];
				}
				else if([[dict objectForKey:@"status"] isEqualToString:ZeroResultsKey]) {
					NSError *error=[NSError errorWithDomain:@"Zero Results Found" code:201 userInfo:nil];
					return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
				}
			else if([[dict objectForKey:@"status"] isEqualToString:UnknownErrorKey]){
					NSError *error=[NSError errorWithDomain:@"Unknown error occured" code:202 userInfo:nil];
					return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
				}
		}
		return dict;
	}
}
+(NSMutableArray*)handleResponseForRoute:(NSString*)responseString
{
    NSMutableArray *retArray = [[[NSMutableArray alloc]init] autorelease];
	SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];	
    NSDictionary *jsonDictionary = [parser objectWithString:responseString];    
	if ([[jsonDictionary objectForKey:@"status"] isEqualToString:@"OK"]) 
    {
        NSArray *routes = [jsonDictionary objectForKey:@"routes"];
		
		for (int i=0; i<[routes count]; i++) {
			RouteBO *routeObj = [[RouteBO alloc]init];
			NSDictionary *routeDetailDic = [routes objectAtIndex:i];
			routeObj.routeName = [routeDetailDic objectForKey:@"summary"];
			NSArray *legs = [routeDetailDic objectForKey:@"legs"];
			NSDictionary *legsDic = [legs objectAtIndex:0];
			routeObj.distance = [[legsDic objectForKey:@"distance"] objectForKey:@"text"];
			//NSLog(@"routeObj.distance%@",routeObj.distance);
			routeObj.duration = [[legsDic objectForKey:@"duration"] objectForKey:@"text"];
			NSMutableArray *stepsArray = [legsDic objectForKey:@"steps"];
			NSMutableArray *temparray = [[NSMutableArray alloc]init];
			//NSLog(@"Steps Count%i",[stepsArray count]);
			for (int j=0; j<[stepsArray count]; j++) {
				NSDictionary *stepsDic = [stepsArray objectAtIndex:j];
				RouteBO *routeDirObj = [[RouteBO alloc]init];
				routeDirObj.direction = [[stepsDic objectForKey:@"html_instructions"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				//NSLog(@"Str%@",routeDirObj.direction);
				routeDirObj.direction = [self flattenHTML:routeDirObj.direction];
				//NSLog(@"Str After %@",routeDirObj.direction);
				[temparray addObject:routeDirObj];
				[routeDirObj release];
			}
			routeObj.steps =temparray;
			[retArray addObject:routeObj];
			[routeObj release];			
		}
}
	return retArray;
}

+(NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    return html;
}
#pragma mark CategoriesList
+(NSDictionary *)getCategoriesList{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:CategoryListAPI];
	//NSLog(@"ResponseStr%@",responseStr);

//						   CategoriesList:requestJSON error:&errorObj callName:CategoryListAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:CategoryListAPIResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				////Parse the result here////
				NSMutableArray *array=[DAL ParseCategoryList:responseStr];
				//NSLog(@"array count %i,description %@",[array count],[array description]);
				return [NSDictionary dictionaryWithObject:array forKey:SuccessKey];	
			}
		}
		return dict;
	}
}
+(NSMutableArray *)ParseCategoryList:(NSString *)responseStr{
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *dict = [parser objectWithString:responseStr];
	dict=[dict objectForKey:CategoryListAPIResponse];
	[parser release];
	NSMutableArray *returnArray=[[[NSMutableArray alloc] init] autorelease];
	NSMutableArray *categoriesArray = [dict objectForKey:@"categories"];
	//NSLog(@"Count %d",[categoriesArray count]);
	for (int i=0; i<[categoriesArray count]; i++) {
		CategoryListBO *categoryObj = [[CategoryListBO alloc]init];
		NSMutableDictionary	*dict = [categoriesArray objectAtIndex:i];
		categoryObj.categoryID = [[dict objectForKey:@"id"] intValue];
		categoryObj.str_name   =  [dict objectForKey:@"name"];
		
		NSMutableDictionary *subCatDictionary = [NSDictionary dictionaryWithObject:[dict objectForKey:@"subCategories"] forKey:@"subCategories"];		
		
		NSMutableArray*subcatArray = [self parseRecursiveCategories:subCatDictionary];
		categoryObj.subCategoriesList = subcatArray;
		[returnArray addObject:categoryObj];
		[categoryObj release];
	}	
	return returnArray;
}
+(NSMutableArray *)parseRecursiveCategories:(NSMutableDictionary*)subCatDictionary{
	NSMutableArray *retArray = [[[NSMutableArray alloc]init] autorelease];
	NSArray *subcatArray = [subCatDictionary objectForKey:@"subCategories"];
	if ([subcatArray count]==0) {
		return nil;
	}
	else {
		for (int i=0; i<[subcatArray count]; i++) {
			NSMutableDictionary *subcatDic = [subcatArray objectAtIndex:i];
			CategoryListBO *category = [[CategoryListBO alloc]init];
			category.categoryID = [[subcatDic objectForKey:@"id"] intValue];
			category.str_name   = [subcatDic objectForKey:@"name"];
			
			NSMutableDictionary *subCatDictionary = [NSDictionary dictionaryWithObject:[subcatDic objectForKey:@"subCategories"] forKey:@"subCategories"];		
			
			category.subCategoriesList = [self parseRecursiveCategories:subCatDictionary];
			[retArray addObject:category];
			[category release];
		}
		return retArray;
		[retArray release];
	}
}
#pragma mark Groups
+(NSDictionary *)SearchPeopleInBubble:(NSString *)searchText
{
	NSString *requestString=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&search=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey],searchText];
	
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestString error:&errorObj callName:SearchPeopleAPI];
	//responseStr=@"{\"SearchNetworkResult\":{ \"message\": \"\",\"status\": \"Success\",\"contacts\": [{\"country\": \"Kuwait\",\"fName\": \"Junaid\", \"gender\": \"True\",\"imgPath\": \"\",\"lName\": \"\",\"userId\": \"6932a644-e769-427f-8ee1-17ca31a9a914\"},{\"country\": \"Kuwait\",\"fName\": \"Junaid\", \"gender\": \"True\",\"imgPath\": \"\",\"lName\": \"\",\"userId\": \"6932a644-e769-427f-8ee1-17ca31a9a914\"}]}}";
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:SearchPeopleAPIResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				/////Parse the Document//////
				
				return [DAL ParseSearchPeopleDocument:dict];
				
				/////////////////////////////
				
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
}
	
+(NSDictionary *)ParseSearchPeopleDocument:(id)results{
	NSDictionary *responseDic=(NSDictionary *)results;
	
	@try {
		NSArray *arr_SearchPeopleResult=[responseDic objectForKey:SearchPeopleJSONKey];
		NSMutableArray *resultArray=[NSMutableArray array];
		for (int i=0;i<[arr_SearchPeopleResult count];i++ ) {
			NSDictionary *dic=[arr_SearchPeopleResult objectAtIndex:i];
			GroupPeopleBO *obj=[[GroupPeopleBO alloc] init];
			obj.str_countryName=[dic objectForKey:countryKey];
			obj.str_fName=[dic objectForKey:fNamekey];
			obj.str_gender=[dic objectForKey:genderKey];
			obj.str_imgPath=[dic objectForKey:imageURLKey];
			obj.str_lName=[dic objectForKey:lNameKey];
			obj.str_userID=[dic objectForKey:UserIDKey];
			obj.isFollowing=[[dic objectForKey:isFollowingKey] boolValue];
			
			[resultArray addObject:obj];
			[obj release];
		}

		return [NSDictionary dictionaryWithObject:resultArray forKey:SuccessKey];
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Unable to parse the Response" code:1 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	
}
+(NSDictionary *)UnfollowPerson:(NSString *)uID isFollow:(int)value
{
	NSString *requestString=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&fuid=%@&follow=%d",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey],uID,value];
	
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestString error:&errorObj callName:FollowUnFollowAPI];	
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:FollowUnFollowResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				/////Parse the Document//////
				
				return [NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:SuccessKey];
				
				/////////////////////////////
				
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
	
}
+(NSDictionary *)PplIamFollowing{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:PplIamFollowingAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:FollowingResultResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				
				return [DAL ParsePeopleIamFollowing:dict];
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
}
+(NSDictionary *)ParsePeopleIamFollowing:(id)results{
	
	NSDictionary *responseDic=(NSDictionary *)results;
	
	@try {
		NSArray *arr_SearchPeopleResult=[responseDic objectForKey:SearchPeopleJSONKey];
		NSMutableArray *resultArray=[NSMutableArray array];
		for (int i=0;i<[arr_SearchPeopleResult count];i++ ) {
			NSDictionary *dic=[arr_SearchPeopleResult objectAtIndex:i];
			GroupPeopleBO *obj=[[GroupPeopleBO alloc] init];
			obj.str_countryName=[dic objectForKey:countryKey];
			obj.str_fName=[dic objectForKey:fNamekey];
			obj.str_gender=[dic objectForKey:genderKey];
			obj.str_imgPath=[dic objectForKey:imageURLKey];
			obj.str_lName=[dic objectForKey:lNameKey];
			obj.str_userID=[dic objectForKey:UserIDKey];
			obj.isFollowing=[[dic objectForKey:isFollowingKey] boolValue];
			[resultArray addObject:obj];
			[obj release];
		}
		
		return [NSDictionary dictionaryWithObject:resultArray forKey:SuccessKey];
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Unable to parse the Response" code:1 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	
}
+(NSDictionary *)PplFollowingMe{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:PplFollowingMeAPI];
	//responseStr=@"{\"FollowedByResult\":{ \"message\": \"\",\"status\": \"Success\",\"contacts\": [{\"country\": \"Kuwait\",\"fName\": \"Junaid\", \"gender\": \"True\",\"imgPath\": \"\",\"lName\": \"\",\"userId\": \"6932a644-e769-427f-8ee1-17ca31a9a914\"},{\"country\": \"Kuwait\",\"fName\": \"Junaid\", \"gender\": \"True\",\"imgPath\": \"\",\"lName\": \"\",\"userId\": \"6932a644-e769-427f-8ee1-17ca31a9a914\"}]}}";
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:FollowingMeResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				
				return [DAL ParsePeopleIamFollowing:dict];
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		return dict;
	}
}
#pragma mark addToFavorites
+(NSDictionary*)addToFavorites:(int)locationID{

	NSError *errorObj=nil;
	NSString *authenticationKey = [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey];
	NSString *userID =	[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey];
	//NSLog(@"authenticationKey%@",authenticationKey);
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&locId=%d",
						   authenticationKey,USLocaleKey,userID,locationID];
	//NSLog(@"requestJson%@",requestJSON);
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:addToFavouriteAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:FailureKey,errorObj,nil] forKeys:[NSArray arrayWithObjects:@"status",@"error",nil]];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		dict=[dict objectForKey:addToFavouriteResponse];
		[parser release];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return dict;
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		return dict;
	}
}
#pragma mark RecommendedLocation
+(NSDictionary*)recommendLocation:(int)locationID{

	NSError *errorObj=nil;
	NSString *authenticationKey = [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey];
	NSString *userID =	[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey];
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&locId=%d",
						   authenticationKey,USLocaleKey,userID,locationID];
	NSLog(@"requestJSON%@",requestJSON);
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:recommendLocationAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:FailureKey,errorObj,nil] forKeys:[NSArray arrayWithObjects:@"status",@"error",nil]];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		dict=[dict objectForKey:recommendLocationAPIResponse];
		[parser release];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return dict;
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		return dict;
	}
}
#pragma mark ReportAnIssue
+(NSDictionary*)reportAnIssue:(int)locationID:(NSString*)issue{

	NSError *errorObj=nil;
	NSString *authenticationKey = [[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey];
	NSString *userID =	[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey];
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@&locId=%d&issue=%@",
						   authenticationKey,USLocaleKey,userID,locationID,issue];
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:ReportAnIssueAPI];
	if (errorObj) {		
		return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:FailureKey,errorObj,nil] forKeys:[NSArray arrayWithObjects:@"status",@"error",nil]];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		dict=[dict objectForKey:ReportAnIssueAPIResponse];
		[parser release];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return dict;
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		return dict;
	}
}
#pragma mark Favorites
+(NSDictionary *)MyFavorites{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:GetFavouritesAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:FavoritesResponseJSOn];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return [DAL HandleFavoriteListRespose:responseStr];
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
}
+(NSDictionary *)HandleFavoriteListRespose:(NSString *)requestJSON{
	
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:requestJSON];
		[parser release];
		dict=[dict objectForKey:FavoritesResponseJSOn];
		NSArray *array=[dict objectForKey:@"favourites"];
		NSMutableArray *resultArray=[NSMutableArray array];
		for (int i=0;i<[array count]; i++) {
			dict=[array objectAtIndex:i];
			FavoriteBO *obj=[[FavoriteBO alloc] init];
			obj.str_areaName=[dict objectForKey:@"areaName"];
			obj.str_bussinessId=[dict objectForKey:@"businessId"];
			obj.str_bussinessName=[dict objectForKey:@"businessName"];
			obj.str_locationId=[dict objectForKey:@"locationId"];
			[resultArray addObject:obj];
			[obj release];
		}
		return [NSDictionary dictionaryWithObject:resultArray forKey:SuccessKey];
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Unable to handle the result" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	
	
}
#pragma mark recommendations
+(NSDictionary *)MyRecommendations{
	NSString *requestJSON=[NSString stringWithFormat:@"auth=%@&locale=%@&uid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:authTokenKey],USLocaleKey,[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]];
	NSError *errorObj=nil;
	NSString *responseStr=[[NetworkController SharedNetworkInstance] NetworkCall:requestJSON error:&errorObj callName:GetRecommendatedAPI];
	if (errorObj) {
		return [NSDictionary dictionaryWithObject:errorObj forKey:FailureKey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseStr];
		[parser release];
		dict=[dict objectForKey:RecommendationsResponse];
		if ([dict objectForKey:@"status"]) {
			if ([[dict objectForKey:@"status"] isEqualToString:SuccessKey]) {
				return [DAL HandleRecommendationsListRespose:responseStr];
			}
			else if([[dict objectForKey:@"status"] isEqualToString:FailureKey]) {
				NSError *error=[NSError errorWithDomain:[dict objectForKey:@"message"] code:[[dict objectForKey:@"code"] intValue] userInfo:nil];
				return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
			}	
		}
		
		
		return dict;
	}
	
}
+(NSDictionary *)HandleRecommendationsListRespose:(NSString *)requestJSON{
	
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:requestJSON];
		[parser release];
		dict=[dict objectForKey:RecommendationsResponse];
		NSArray *array=[dict objectForKey:@"recommendations"];
		NSMutableArray *resultArray=[NSMutableArray array];
		for (int i=0;i<[array count]; i++) {
			dict=[array objectAtIndex:i];
			FavoriteBO *obj=[[FavoriteBO alloc] init];
			obj.str_areaName=[dict objectForKey:@"areaName"];
			obj.str_bussinessId=[dict objectForKey:@"businessId"];
			obj.str_bussinessName=[dict objectForKey:@"businessName"];
			obj.str_locationId=[dict objectForKey:@"locationId"];
			[resultArray addObject:obj];
			[obj release];
		}
		return [NSDictionary dictionaryWithObject:resultArray forKey:SuccessKey];
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Unable to handle the result" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
}
//  Modified By Hassan on March 2k, 2012

#pragma mark - Google Directions API call
+(NSDictionary*)RequestToGetDirectionsForGivenDestinations:(NSString*)startLocation:(NSString*)endLocation{
    
    NSLog(@"startLocation%@",startLocation);
	NSLog(@"endLocation%@",endLocation);
	NSError *error = nil;
    NSString *responseStr=[[NetworkController SharedNetworkInstance] getGoogleDirectionsFrom:startLocation to:endLocation withError:&error];
   // NSString *responseStr = [NSString stringWithString:[[NetworkController SharedNetworkInstance] getGoogleDirectionsFrom:startLocation to:endLocation withError:&error]];
    NSLog(@"responseStr%@",responseStr);
    if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
	else {
        return [DAL handleResponseForPoints:responseStr];
	}
}
+(NSDictionary*)handleResponseForPoints:(NSString*)responseString
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary *dict = [parser objectWithString:responseString];
    
    if ([dict objectForKey:@"status"]) 
    {
        if ([[dict objectForKey:@"status"] isEqualToString:OkKey]) 
        {
            [returnDictionary setObject:@"success" forKey:SuccessKey];
            NSArray *routes = [dict objectForKey:@"routes"];
            NSDictionary *firstRoute = (NSDictionary*)[routes objectAtIndex:0];
            NSDictionary *StringSmpDic = [firstRoute objectForKey:@"overview_polyline"];
            NSString *str = [StringSmpDic objectForKey:@"points"];
			
            NSMutableArray *pointsArray = [DAL decodePolyLine:str];
            [returnDictionary setObject:pointsArray forKey:PointsArayForRouteKey];
        }
        else if([[dict objectForKey:@"status"] isEqualToString:ZeroResultsKey]) 
        {
            NSError *error=[NSError errorWithDomain:@"Zero Results Found" code:201 userInfo:nil];
            [returnDictionary setObject:error forKey:FailureKey];
        }
        else if([[dict objectForKey:@"status"] isEqualToString:NOT_FOUND])
        {
            NSError *error=[NSError errorWithDomain:@"No Result Found" code:202 userInfo:nil];
            [returnDictionary setObject:error forKey:FailureKey];
        }
		else if([[dict objectForKey:@"status"] isEqualToString:UnknownErrorKey])
        {
            NSError *error=[NSError errorWithDomain:@"Unknown error occured" code:203 userInfo:nil];
            [returnDictionary setObject:error forKey:FailureKey];
        }
		
    }
	[parser release];
    return returnDictionary;
}
+(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {  
	NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];  
	[encoded appendString:encodedStr];  
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"  
								options:NSLiteralSearch  
								  range:NSMakeRange(0, [encoded length])];  
	NSInteger len = [encoded length];  
	NSInteger index = 0;  
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];  
	NSInteger lat=0;  
	NSInteger lng=0;  
	while (index < len) {  
		NSInteger b;  
		NSInteger shift = 0;  
		NSInteger result = 0;  
		do {  
			b = [encoded characterAtIndex:index++] - 63;  
			result |= (b & 0x1f) << shift;  
			shift += 5;  
		} while (b >= 0x20);  
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));  
		lat += dlat;  
		shift = 0;  
		result = 0;  
		do {  
			b = [encoded characterAtIndex:index++] - 63;  
			result |= (b & 0x1f) << shift;  
			shift += 5;  
		} while (b >= 0x20);  
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));  
		lng += dlng;  
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];  
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];  
		//          printf("[%f,", [latitude doubleValue]);  
		//          printf("%f]", [longitude doubleValue]);  
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];  
		[array addObject:loc];  
	}  
	[encoded release];  
	return array;
}

@end
