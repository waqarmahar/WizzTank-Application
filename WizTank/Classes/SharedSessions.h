//
//  SharedSessions.h
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSessions : NSObject {
	NSMutableArray *categoryList;
}
@property(nonatomic,retain) NSMutableArray *categoryList;
+(SharedSessions *) GetInstance;
-(NSMutableArray *)GetCategoriesList;
-(void)UpdateCategoryList;
@end
