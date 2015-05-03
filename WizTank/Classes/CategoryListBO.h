//
//  CategoryListBO.h
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryListBO : NSObject {
	int categoryID;
	NSString *str_name;
	NSMutableArray *subCategoriesList;
}

@property int categoryID;
@property(nonatomic,retain) NSString *str_name;
@property(nonatomic,retain) NSMutableArray *subCategoriesList;
@end
