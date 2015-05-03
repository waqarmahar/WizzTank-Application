//
//  FindPlacesBL.h
//  WizTank
//
//  Created by Shafqat on 1/6/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FindPlacesBL : NSObject {

}

+(NSDictionary *)CloseByCall;
+(NSDictionary *)searchPlaces:(NSString*)searchQuerry:(int)catID;
@end
