//
//  FavoriteBO.h
//  WizTank
//
//  Created by Shafqat on 2/27/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FavoriteBO : NSObject {
	NSString *str_areaName;
	NSString *str_bussinessId;
	NSString *str_bussinessName;
	NSString *str_locationId;
}


@property(nonatomic,retain) NSString *str_areaName;
@property(nonatomic,retain) NSString *str_bussinessId;
@property(nonatomic,retain) NSString *str_bussinessName;
@property(nonatomic,retain) NSString *str_locationId;
@end
