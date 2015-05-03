//
//  LoginBL.h
//  WizTank
//
//  Created by Shafqat on 1/5/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAL.h"
#import "RegisterBO.h"

@interface LoginBL : NSObject {

}

#pragma mark Login
+(NSError *) VerfiyUserInput:(NSString *)userName password:(NSString *)Password;

+(NSDictionary *) LoginRequest:(NSString *)userName password:(NSString *)Password;

#pragma mark REGISTRATIONS
+(NSError *)VerfiyRegistrationInput:(RegisterBO *)regObj;
+(NSDictionary *) RegisterRequest:(RegisterBO *)regObj;

#pragma mark ForgotPassword
+(NSError *)VerfiyUserInput4ForgotPassword:(NSString *)email;
+(NSDictionary *)ForgotPasswordRequest:(NSString *)email;
#pragma mark LogOut
+(NSDictionary *)LogoutUser;
#pragma mark Combined
+(BOOL) validateEmail: (NSString *) candidate;
#pragma mark updateUser
+(NSDictionary *) updateUser:(RegisterBO *)regObj;
+(NSError *)VerfiyUpdateInput:(RegisterBO *)regObj:(BOOL)isNewImage;
@end
