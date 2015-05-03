//
//  RegisterBO.m
//  WizTank
//
//  Created by Shafqat on 1/4/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "RegisterBO.h"


@implementation RegisterBO

@synthesize str_Fname;
@synthesize str_Lname;
@synthesize str_gender;
@synthesize str_dob;
@synthesize str_country;
@synthesize str_phone;
@synthesize str_email;
@synthesize str_password;
@synthesize picData;
@synthesize str_ImageURL;


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.str_Fname forKey:@"firstName"];
    [encoder encodeObject:self.str_Lname forKey:@"lastName"];
	[encoder encodeObject:str_gender forKey:@"gender"];
	[encoder encodeObject:self.str_dob forKey:@"dob"];
	[encoder encodeObject:self.str_country forKey:@"country"];
	[encoder encodeObject:self.str_phone forKey:@"phone"];
	[encoder encodeObject:self.str_email forKey:@"email"];
	[encoder encodeObject:str_password forKey:@"password"];
	[encoder encodeObject:self.picData forKey:@"picdata"];
	[encoder encodeObject:self.str_ImageURL forKey:@"imageURL"];
	
	
	
	
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.str_Fname = [decoder decodeObjectForKey:@"firstName"];
        self.str_Lname = [decoder decodeObjectForKey:@"lastName"];
        self.str_gender = [decoder decodeObjectForKey:@"gender"];
		self.str_dob = [decoder decodeObjectForKey:@"dob"];
		self.str_country = [decoder decodeObjectForKey:@"country"];
		self.str_phone = [decoder decodeObjectForKey:@"phone"];
		self.str_email = [decoder decodeObjectForKey:@"email"];
		self.str_password = [decoder decodeObjectForKey:@"password"];
		self.picData = [decoder decodeObjectForKey:@"picdata"];
		self.str_ImageURL = [decoder decodeObjectForKey:@"imageURL"];
		
		
		
		
    }
    return self;
}
-(void)dealloc
{
	[str_Fname release];
	[str_Lname release];
	[str_gender release];
	[str_dob release];
	[str_country release];
	[str_phone release];
	[str_email release];
	[str_password release];
	[picData release];
	[str_ImageURL release];
	[super dealloc];
}

@end
