//
//  RegisterBO.h
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegisterBO : NSObject<NSCoding> {
	NSString *str_Fname;
	NSString *str_Lname;
	NSString *str_gender;
	NSString *str_dob;
	NSString *str_country;
	NSString *str_phone;
	NSString *str_email;
	NSString *str_password;
	NSData *picData;
	NSString *str_ImageURL;
}
@property(nonatomic,retain) NSString *str_ImageURL;
@property(nonatomic,retain) NSString *str_Fname;
@property(nonatomic,retain) NSString *str_Lname;
@property(nonatomic,retain) NSString *str_gender;
@property(nonatomic,retain) NSString *str_dob;
@property(nonatomic,retain) NSString *str_country;
@property(nonatomic,retain) NSString *str_phone;
@property(nonatomic,retain) NSString *str_email;
@property(nonatomic,retain) NSString *str_password;
@property(nonatomic,retain) NSData *picData;


@end
