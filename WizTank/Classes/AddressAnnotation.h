/*
  AddressAnnotation.h
  iCarpool
  Created by Aasim Naseem Siddiqui on 12/6/10.
  Copyright 2010 GenITeam. All rights reserved.
 
  This class use for drop pins on map for matches Map view;
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface AddressAnnotation : NSObject <MKAnnotation>{
	
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;

@end
