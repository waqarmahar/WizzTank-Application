//
//  NetworkController.h
//  InstaEngine
//
//  Created by Numan on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkController : NSObject {
    
}

+(NetworkController*)SharedNetworkInstance;

-(NSString *) NetworkCall:(NSString *) requestJSON error:(NSError **)errorObject callName:(NSString *)Apiname;
-(NSString *) CloseByGooglePlaces:(NSError **)errorObject callName:(NSString *)Apiname;

-(NSString *) CategoriesList:(NSString *) requestJSON error:(NSError **)errorObject callName:(NSString *)Apiname;

-(NSString *) RoutesFromGoogle:(NSString *) requestJSON:(NSError **)errorObject;

-(NSString*)getGoogleDirectionsFrom:(NSString*)startLocation to:(NSString*)endLocation withError:(NSError**)theError;

@end
