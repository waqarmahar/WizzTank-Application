//
//  NetworkController.m
//  InstaEngine
//
//  Created by Numan on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkController.h"
#import	"ASIHTTPRequest.h"
#import "Reachability.h"

//api.fqs.c42.in
#define BASE_URL @"http://www.wiztank.com/wiztankwebservice/api.svc/"



@implementation NetworkController
NetworkController *SharedNetworkInstance;
//----------------------------------------------------------------------------------------------------------------
+(NetworkController*)SharedNetworkInstance{
	if (!SharedNetworkInstance) {
		SharedNetworkInstance = [[NetworkController alloc] init];
	}
	//SharedNetworkInstance.responseStr = nil;
	
	if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		NSLog(@"Could not connect to server. Throw an exception from here");
		///Network Availability here///
	}
	
	return SharedNetworkInstance;
}


#pragma mark LoginUser

-(NSString *) NetworkCall:(NSString *) requestJSON error:(NSError **)errorObject callName:(NSString *)Apiname{
	NSString *responseStr;
    @try{
		NSString *url = [BASE_URL stringByAppendingString:Apiname];
		NSLog(@"url is%@",url);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        request.timeOutSeconds=20;
		[request setRequestMethod:@"POST"];
		
        NSMutableData *postData = (NSMutableData*)[requestJSON dataUsingEncoding:NSASCIIStringEncoding];
		[request setPostBody:postData];
		
        [request startSynchronous];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        NSError *error = [request error];
		int statusCode=request.responseStatusCode;
		
		if (statusCode==200) {
			responseStr = [[request responseString] retain];
			return [responseStr autorelease];		
		}
		else if(statusCode==404){
			error=[NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		
			
		}
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		}
		else {
			*errorObject=error;
			return nil;
		}

	}@catch(NSException *e){
		//errorObject=error;
		NSError *error=[NSError errorWithDomain:@"Exception Encountered" code:0 userInfo:nil];
		*errorObject=error;
		return nil;
	}
	return nil;
}
#pragma mark CategoryList
-(NSString *) CategoriesList:(NSString *) requestJSON error:(NSError **)errorObject callName:(NSString *)Apiname
{
	NSString *responseStr;
    @try{
        NSString *url = [BASE_URL stringByAppendingString:Apiname];
		
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        request.timeOutSeconds=20;
		[request setRequestMethod:@"GET"];
		
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"*/*"];
        NSData *postData = [requestJSON dataUsingEncoding:NSASCIIStringEncoding];
        
        [request appendPostData:postData];
        [request startSynchronous];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
        NSError *error = [request error];
		int statusCode=request.responseStatusCode;
		
		if (statusCode==200) {
			responseStr = [[request responseString] retain];
			return [responseStr autorelease];		
		}
		else if(statusCode==404){
			error=[NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
			
			
		}
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		}
		else {
			*errorObject=error;
			return nil;
		}
		
	}@catch(NSException *e){
		//errorObject=error;
		NSError *error=[NSError errorWithDomain:@"Exception Encountered" code:0 userInfo:nil];
		*errorObject=error;
		return nil;
	}
	return nil;
}
#pragma mark Close By
-(NSString *) CloseByGooglePlaces:(NSError **)errorObject callName:(NSString *)Apiname{
	NSString *responseStr;
    @try{
        NSString *url = Apiname;
		
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        request.timeOutSeconds=20;
		[request setRequestMethod:@"GET"];
		
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"*/*"];
        [request startSynchronous];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
        NSError *error = [request error];
		int statusCode=request.responseStatusCode;
		
		if (statusCode==200) {
			responseStr = [[request responseString] retain];
			return [responseStr autorelease];		
		}
		else if(statusCode==404){
			error=[NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
			
			
		}
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		}
		else {
			*errorObject=error;
			return nil;
		}
		
	}@catch(NSException *e){
		//errorObject=error;
		NSError *error=[NSError errorWithDomain:@"Exception Encountered" code:0 userInfo:nil];
		*errorObject=error;
		return nil;
	}
	return nil;
}
#pragma mark getRoutesFromGoogle
-(NSString *) RoutesFromGoogle:(NSString *) requestJSON:(NSError **)errorObject {
	NSString *responseStr;
    @try{
		
		NSString* escapedUrlString =
		[requestJSON stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		NSURL *url =[NSURL URLWithString:escapedUrlString];
		
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.timeOutSeconds=20;
		[request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"*/*"];
        [request startSynchronous];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSError *error = [request error];
		int statusCode=request.responseStatusCode;
		if (statusCode==200) {
			responseStr = [[request responseString] retain];
			return [responseStr autorelease];		
		}
		else if(statusCode==404){
			error=[NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		}
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*errorObject=error;
			return nil;
		}
		else {
			*errorObject=error;
			return nil;
		}
		
	}@catch(NSException *e){
		//errorObject=error;
		NSError *error=[NSError errorWithDomain:@"Exception Encountered" code:0 userInfo:nil];
		*errorObject=error;
		return nil;
	}
	return nil;
}

//  Added by Hassan on March 2, 2012

-(NSString*)getGoogleDirectionsFrom:(NSString*)startLocation to:(NSString*)endLocation withError:(NSError**)theError
{
    NSString *responseStr = nil;
    
    @try{
		
        NSString *urlString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",startLocation,endLocation];
        NSString* escapedUrlString =
        [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSURL *url =[NSURL URLWithString:escapedUrlString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.timeOutSeconds=20;
		[request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Accept" value:@"*/*"];
        [request startSynchronous];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSError *error = [request error];

		int statusCode = request.responseStatusCode;
		
		if (statusCode==200) {
			responseStr = [request responseString];
// 			return [responseStr autorelease];		
		}
		else if(statusCode==404){
			error = [NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*theError = error;
//			return nil;
		}
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*theError = error;
//			return nil;
		}
		else {
			*theError = error;
//			return nil;
		}
		
	}@catch(NSException *e){
		//errorObject=error;
//		NSError *error=[NSError errorWithDomain:@"Exception Encountered" code:0 userInfo:nil];
//		*errorObject=error;
//		return nil;
	}
    
    return responseStr;
}

@end
