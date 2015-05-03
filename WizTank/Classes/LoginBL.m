//
//  LoginBL.m
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "LoginBL.h"


@implementation LoginBL

#pragma mark Login
+(NSError *) VerfiyUserInput:(NSString *)userName password:(NSString *)Password
{
	if (userName==nil || [userName isEqualToString:@""] ) {
		return	[NSError errorWithDomain:@"Email Field Cannot Be Empty" code:1 userInfo:nil];
	}
	else if(Password==nil || [Password isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Password Field Cannot Be Empty" code:1 userInfo:nil];
	}
	else if(![LoginBL validateEmail:userName])
	 {
		 return	[NSError errorWithDomain:@"Invalid Email Entered" code:1 userInfo:nil];
	 }
	else {
		return	[NSError errorWithDomain:@"" code:0 userInfo:nil];
	}
	
}
+(NSDictionary *) LoginRequest:(NSString *)userName password:(NSString *)Password{
	
	return [DAL LoginRequest:userName password:Password];
}
#pragma mark Registraion
+(NSError *)VerfiyRegistrationInput:(RegisterBO *)regObj{
	if (regObj.str_Fname==nil || [regObj.str_Fname isEqualToString:@""]) {
		return	[NSError errorWithDomain:@"F Name field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_Lname==nil || [regObj.str_Lname isEqualToString:@""]){
		return	[NSError errorWithDomain:@"L Name field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_gender==nil || [regObj.str_gender isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Gender field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_dob==nil || [regObj.str_dob isEqualToString:@""]){
		return	[NSError errorWithDomain:@"DOB field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_country==nil || [regObj.str_country isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Country field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_email==nil || [regObj.str_email isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Email field cannot be empty" code:1 userInfo:nil];
	}
	else if(![LoginBL validateEmail:regObj.str_email])
	{
		return	[NSError errorWithDomain:@"Invalid Email Entered" code:1 userInfo:nil];
	}
	else if(regObj.str_password==nil || [regObj.str_password isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Password field cannot be empty" code:1 userInfo:nil];
	}
//	else if(regObj.picData==nil){
//		return	[NSError errorWithDomain:@"Please add a photo" code:1 userInfo:nil];	
//	}
	else {
		return	[NSError errorWithDomain:@"" code:0 userInfo:nil];
	}

}
+(NSDictionary *) RegisterRequest:(RegisterBO *)regObj{
	
	return [DAL RegisterRequest:regObj];
}


#pragma mark ForgotPassword
+(NSError *)VerfiyUserInput4ForgotPassword:(NSString *)email{
	if (email==nil || [email isEqualToString:@""] ) {
		return	[NSError errorWithDomain:@"Email Field Cannot Be Empty" code:1 userInfo:nil];
	}
	else if(![LoginBL validateEmail:email])
	{
		return	[NSError errorWithDomain:@"Invalid Email Entered" code:1 userInfo:nil];
	}
	else {
		return	[NSError errorWithDomain:@"" code:0 userInfo:nil];
	}
	
}
+(NSDictionary *)ForgotPasswordRequest:(NSString *)email{
	return [DAL ForgotPasswordRequest:email];
}
#pragma mark Logout
+(NSDictionary *)LogoutUser{
	return	[DAL LogoutUser];
}
#pragma mark UpdateUser
+(NSDictionary *) updateUser:(RegisterBO *)regObj{
	return	[DAL updateRequest:regObj];
}
#pragma mark Registraion
+(NSError *)VerfiyUpdateInput:(RegisterBO *)regObj:(BOOL)isNewImage{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *myEncodedObject = [defaults objectForKey:registrationObjkey];
	RegisterBO *userProfileInfo = (RegisterBO *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if (!isNewImage) {
		if ([regObj.str_Fname isEqualToString:userProfileInfo.str_Fname] && [regObj.str_Lname isEqualToString:userProfileInfo.str_Lname]
			&& [regObj.str_gender isEqualToString:userProfileInfo.str_gender] && [regObj.str_dob isEqualToString:userProfileInfo.str_dob]
			&& [regObj.str_country isEqualToString:userProfileInfo.str_country] && [regObj.str_phone isEqualToString:userProfileInfo.str_phone]) {
			return	[NSError errorWithDomain:@"No changes Found" code:1 userInfo:nil];
		}	
		else {
				return	[NSError errorWithDomain:@"" code:0 userInfo:nil];
		}
	}	
	else {
		return	[NSError errorWithDomain:@"" code:0 userInfo:nil];
	}
	
	/*
	else if(regObj.str_Lname==nil || [regObj.str_Lname isEqualToString:@""]){
		return	[NSError errorWithDomain:@"L Name field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_gender==nil || [regObj.str_gender isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Gender field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_dob==nil || [regObj.str_dob isEqualToString:@""]){
		return	[NSError errorWithDomain:@"DOB field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_country==nil || [regObj.str_country isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Country field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.str_email==nil || [regObj.str_email isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Email field cannot be empty" code:1 userInfo:nil];
	}
	else if(![LoginBL validateEmail:regObj.str_email])
	{
		return	[NSError errorWithDomain:@"Invalid Email Entered" code:1 userInfo:nil];
	}
	else if(regObj.str_password==nil || [regObj.str_password isEqualToString:@""]){
		return	[NSError errorWithDomain:@"Password field cannot be empty" code:1 userInfo:nil];
	}
	else if(regObj.picData==nil){
		return	[NSError errorWithDomain:@"Please add a photo" code:1 userInfo:nil];	
	}*/

}

#pragma mark combined
+(BOOL) validateEmail: (NSString *) candidate
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}


@end
