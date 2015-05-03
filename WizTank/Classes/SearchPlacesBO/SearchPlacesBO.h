//
//  SearchPlacesBO.h
//  WizTank
//
//  Created by Nawaz Mac on 2/13/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SearchPlacesBO : NSObject {

	NSInteger businessID;
	NSMutableArray *categories;
	NSString *description;
	NSString *email;
	NSString *fax;
	NSMutableArray *locations;
	NSString *officialName;
	NSString *phone;
	NSString *thumbnail;
	NSString *website;
	NSMutableArray *recommended_By;
}
@property (nonatomic,readwrite)NSInteger businessID;
@property (nonatomic,retain)NSMutableArray *categories;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSString *email;
@property (nonatomic,retain)NSString *fax;
@property (nonatomic,retain)NSMutableArray *locations;
@property (nonatomic,retain)NSString *officialName;
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,retain)NSString *thumbnail;
@property (nonatomic,retain)NSString *website;
@property (nonatomic,retain)NSMutableArray *recommended_By;
@end
