//
//  AutoCompleteView.h
//  WizTank
//
//  Created by Nawaz Mac on 3/16/12.
//  Copyright 2012 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationsBO.h"

@protocol BusinessObjectsAutoCompleteProtocol<NSObject>

-(void)psuhtoDeTailsVC:(LocationsBO*)object;
@end
@interface AutoCompleteView : UIView<UITableViewDelegate> {
	
	NSMutableArray *placesArray;
	NSMutableArray *cacheArray;
	NSMutableArray *businessObjects;
	IBOutlet UITableView *tbl_businesses;
	id <BusinessObjectsAutoCompleteProtocol> delegate;
}
@property (nonatomic,retain)NSMutableArray *placesArray;
//@property (nonatomic,copy)NSMutableArray *cacheArray;
@property (nonatomic,retain)NSMutableArray *businessObjects;
@property (nonatomic,retain) id <BusinessObjectsAutoCompleteProtocol> delegate;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
+(UIView*) loadInstanceFromNib;
-(void)setArrays:(NSMutableArray*)placesArray;
@end
