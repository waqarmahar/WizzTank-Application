//
//  RouteBO.h
//  WizTank
//
//  Created by Nawaz Mac on 2/28/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RouteBO : NSObject {

	NSString *routeName;
	NSString *distance;
	NSString *duration;
	NSMutableArray *steps;
	NSString *direction;
}
@property(nonatomic,retain)	NSString *routeName;
@property(nonatomic,retain) NSString *distance;
@property(nonatomic,retain) NSString *duration;;
@property(nonatomic,retain)	NSMutableArray *steps;
@property(nonatomic,retain)	NSString *direction;

@end
