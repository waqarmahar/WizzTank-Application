//
//  CloseByBO.h
//  WizTank
//
//  Created by Shafqat on 1/6/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface CloseByBO : NSObject {
	NSString *str_name;
	NSString *str_vicinity;
	CLLocationCoordinate2D placeLocation;
	float f_distance;
}
@property(nonatomic,retain) NSString *str_name;
@property(nonatomic,retain) NSString *str_vicinity;
@property  CLLocationCoordinate2D placeLocation;
@property float f_distance;

- (NSComparisonResult) compareByName:(CloseByBO*) record;
- (NSComparisonResult) compareByLocation:(CloseByBO*) record;
@end
