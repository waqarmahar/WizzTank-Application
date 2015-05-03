//
//  MapView.m
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "MapView.h"
#import "AddressAnnotation.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"

@implementation MapView
@synthesize routeLine,routeLineView;
//@synthesize endLocation,startLocation;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
- (void)dealloc {
	mapView.delegate =nil;
	[routeLine release];
	[routeLineView release];
	[super dealloc];
}
#pragma mark setRegion
-(void)setMapRegion{
	NSLog(@"setMapRegion called...");
	MKCoordinateSpan span;
	span.latitudeDelta = 5;
	span.longitudeDelta = 5;
	
	CLLocationCoordinate2D center;
	center.latitude = 29.300000;//41.879786;
	center.longitude = 48.020000;//-87.629013;
	MKCoordinateRegion region;
	region.center=center;
	region.span=span;
	[mapView setRegion:region animated:YES];	
}
#pragma mark ViewMethods
-(void)addToTransparentView
{
	self.frame=CGRectMake(0, 0,320,480);
	[self addSubview:view_TransparentView];
	view_innerView.frame=CGRectMake(6,38,300,397);
	[self addSubview:view_innerView];
	UIButton *btn_Close=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_Close.frame=CGRectMake(285,20,35,35);	
	[btn_Close setBackgroundImage:[UIImage imageNamed:@"btn_closeImage.png"] forState:UIControlStateNormal];
	[btn_Close addTarget:self action:@selector(btn_Action_Close) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:btn_Close];
}
+(UIView*) loadInstanceFromNib {
    UIView *result = nil;
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    return result;
}
#pragma mark  Map delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(AddressAnnotation *)annotation
{
		MKPinAnnotationView *annView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"updatedLoc"] autorelease];
		annView.pinColor = MKPinAnnotationColorRed;
		annView.animatesDrop=TRUE;
		annView.canShowCallout = YES;	
    return annView;
}
#pragma mark IBActions
-(IBAction)btn_Action_Close{
	[self removeFromSuperview];	
}
#pragma mark addAnnotation

-(void)addAnnotationView:(AddressAnnotation*)addressObj{
	AddressAnnotation *annotation = [[AddressAnnotation alloc] init];
	annotation.title = addressObj.title;
	annotation.coordinate = addressObj.coordinate;
	annotation.subtitle = addressObj.subtitle;
	[mapView addAnnotation:annotation];
	[annotation release];	
}
#pragma mark AddRoute

-(void)AddDirectionRoute:(NSMutableArray*)pointsArray{
	MKMapPoint northEastPoint;
    MKMapPoint southWestPoint; 
	if ([pointsArray count]>0) 
    {
		//////////////////////////////////////////////////
		MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointsArray.count);
		for (int index=0;index<[pointsArray count];index++) {
			CLLocation *loc = (CLLocation*)[pointsArray objectAtIndex:index];
			CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(loc.coordinate.latitude,loc.coordinate.longitude);
			MKMapPoint point = MKMapPointForCoordinate(coordinates);
			if (index == 0) {
				northEastPoint = point;
				southWestPoint = point;
			}
			else {
				if (point.x > northEastPoint.x)
					northEastPoint.x = point.x;
				if(point.y > northEastPoint.y)
					northEastPoint.y = point.y;
				if (point.x < southWestPoint.x)
					southWestPoint.x = point.x;
				if (point.y < southWestPoint.y)
					southWestPoint.y = point.y;				
			}
			pointArr[index] = point;
		}
        self.routeLine = [MKPolyline polylineWithPoints:pointArr count:[pointsArray count]];
			free(pointArr);
	}
    routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    [mapView addOverlay:self.routeLine];
    [mapView setVisibleMapRect:routeRect];
}
#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
			self.routeLineView.fillColor = [UIColor redColor];
			self.routeLineView.strokeColor = [UIColor redColor];
			self.routeLineView.lineWidth = 3;
		}
		overlayView = self.routeLineView;
	}
	return overlayView;
}
@end
