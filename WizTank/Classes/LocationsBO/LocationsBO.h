//
//  LocationsBO.h
//  WizTank
//
//  Created by Nawaz Mac on 2/13/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchPlacesBO.h"

@interface LocationsBO : NSObject {

	NSString *avenue;
	NSString *officialName;
	NSString *block;
	NSString *email;
	NSString *fax;
	float	latitude;
	NSInteger locationId;
	float longitude;
	NSString *phone;
	NSString *plot;
	NSString *street;
	float distance;
	NSString *area;
	NSString *recommendedBy;
	SearchPlacesBO*businessObject;
}
@property (nonatomic,retain)NSString *avenue;
@property (nonatomic,retain)NSString *block;
@property (nonatomic,retain)NSString *email;
@property (nonatomic,retain)NSString *fax;
@property (nonatomic,readwrite)float	latitude;
@property (nonatomic,readwrite)NSInteger locationId;
@property (nonatomic,readwrite)float longitude;
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,retain)NSString *plot;
@property (nonatomic,retain)NSString *street;
@property (nonatomic,readwrite)float distance;
@property (nonatomic,retain)NSString *area;
@property (nonatomic,retain)NSString *recommendedBy;
@property (nonatomic,retain)SearchPlacesBO*businessObject;
@property (nonatomic,retain)NSString *officialName;

-(void)CopyObject:(LocationsBO *)Obj;
@end
