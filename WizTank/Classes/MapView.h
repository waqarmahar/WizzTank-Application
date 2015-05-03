//
//  MapView.h
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "AddressAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface MapView : UIView<MKAnnotation,MKMapViewDelegate> {
	IBOutlet UIView *view_innerView;
	IBOutlet UIView *view_TransparentView;
	IBOutlet MKMapView *mapView;
	
	//  For Route
	MKPolyline* routeLine;
	// the view we create for the line on the map
	MKPolylineView* routeLineView;
	// the rect that bounds the loaded points
	MKMapRect routeRect;
}
@property (nonatomic,retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

-(void)addToTransparentView;
+(UIView*) loadInstanceFromNib;
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(AddressAnnotation *)annotation;
-(void)addAnnotationView:(AddressAnnotation*)addressObj;
-(IBAction)btn_Action_Close;
-(void)setMapRegion;
////
-(void)AddDirectionRoute:(NSMutableArray*)pointsArray;

@end
