//
//  LocationsBO.m
//  WizTank
//
//  Created by Nawaz Mac on 2/13/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import "LocationsBO.h"

@implementation LocationsBO

@synthesize avenue,block,email,fax,latitude,locationId,longitude,phone,plot,street,distance,area,recommendedBy,businessObject,officialName;

-(void)dealloc{
	
	 [avenue release];
	 [block release];
	 [email release];
	 [fax release];
	 [phone release];
	 [plot release];
	 [street release];
	 [area release];
	 [recommendedBy release];
	 [businessObject release];
	 [super dealloc];
}
-(void)CopyObject:(LocationsBO *)Obj{
	self.avenue=Obj.avenue;
	self.officialName =Obj.officialName ;
		self.block=Obj.block;
		self.email=Obj.email;
		self.fax=Obj.fax;
		self.latitude=Obj.latitude;
	 	self.locationId=Obj.locationId;
	 	self.longitude=Obj.longitude;
	 	self.phone=Obj.phone;
		self.plot=Obj.plot;
		self.street=Obj.street;
	 	self.distance=Obj.distance;
		self.area=Obj.area;
		self.recommendedBy=Obj.recommendedBy;
	///////////////////////////
	SearchPlacesBO *temp=[[SearchPlacesBO alloc] init];
	
	
	temp.businessID=Obj.businessObject.businessID;
	temp.categories=Obj.businessObject.categories;
	temp.description=Obj.businessObject.description;
	temp.email=Obj.businessObject.email;
	temp.fax=Obj.businessObject.fax;
	temp.locations=Obj.businessObject.locations;
	temp.officialName=Obj.businessObject.officialName;
	temp.phone=Obj.businessObject.phone;
	temp.thumbnail=Obj.businessObject.thumbnail;
	temp.website=Obj.businessObject.website;
	temp.recommended_By=Obj.businessObject.recommended_By;	
	
	self.businessObject=temp;
	[temp release];
}
@end
