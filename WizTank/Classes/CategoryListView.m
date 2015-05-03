//
//  RefineOnCloseByView.m
//  WizTank
//
//  Created by Shafqat on 1/11/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "CategoryListView.h"
#import "SharedSessions.h"
#import "CategoryListBO.h"


@implementation CategoryListView

@synthesize str_selectedCategory;
@synthesize delegate,categoriesArray;

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
	[str_selectedCategory release];
	[categoriesArray release];
    [super dealloc];
}
#pragma mark ViewMethods
-(void)addToTransparentView
{
	self.frame=CGRectMake(0, 0,320,480);
	[self addSubview:view_TransparentView];
	view_innerView.frame=CGRectMake(6,38,300,397);
	[self addSubview:view_innerView];
	UIButton *btn_Close=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_Close.frame=CGRectMake(290,22,30,30);	
	[btn_Close setBackgroundImage:[UIImage imageNamed:@"btn_closeImage.png"] forState:UIControlStateNormal];
	[btn_Close addTarget:self action:@selector(btn_Action_cross) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark UITableView Delegates
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	return[self.categoriesArray count];	
	
}// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    CategoryListBO *categoryOBJ = (CategoryListBO*)[self.categoriesArray objectAtIndex:indexPath.row];
	UIButton *btn_Photo=[UIButton buttonWithType:UIButtonTypeCustom];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
      
	}
	btn_Photo.frame=CGRectMake(0,0,25,26);
	btn_Photo.tag=indexPath.row;
	[btn_Photo setBackgroundImage:[UIImage imageNamed:@"CloseByAccesoryView.png"] forState:UIControlStateNormal];
	[btn_Photo setBackgroundImage:[UIImage imageNamed:@"CloseByAccesoryView.png"] forState:UIControlStateSelected];
	[btn_Photo setBackgroundImage:[UIImage imageNamed:@"CloseByAccesoryView.png"] forState:UIControlStateHighlighted];
	[btn_Photo addTarget:self action:@selector(AccesoryViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];	
	if ([categoryOBJ.subCategoriesList count]>0) {
		cell.accessoryView=btn_Photo;
	}
	else {
		cell.accessoryView.hidden=YES;
	}

	cell.textLabel.font=[UIFont systemFontOfSize:20];
	cell.textLabel.text=categoryOBJ.str_name;
	/////////////
	return cell;
}
-(void)AccesoryViewButtonPressed:(id)Sender{
	UIButton *btn=(UIButton *)Sender;
	NSLog(@"button tag is %d",btn.tag);
	CategoryListBO *categoryOBJ = (CategoryListBO*)[self.categoriesArray objectAtIndex:btn.tag];
	self.categoriesArray = categoryOBJ.subCategoriesList;
	[tbl_categories reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

	CategoryListBO *categoryOBJ = (CategoryListBO*)[self.categoriesArray objectAtIndex:indexPath.row];
	selectedCategoryID = categoryOBJ.categoryID;	
	
//	if (delegate && [delegate respondsToSelector:@selector(CategoryName:)]) {
//		[delegate CategoryName:categoryOBJ.str_name];
//	}
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{");
}
#pragma mark IBActions
-(IBAction) btn_Action_Done{
		if (delegate && [delegate respondsToSelector:@selector(CategoryName:)]) {
			[delegate CategoryName:selectedCategoryID];
		}
	[self removeFromSuperview];
}
-(IBAction) btn_Action_cross
{
	[self removeFromSuperview];	
}
#pragma mark getCategories
-(void)getCategories{
	[self performSelectorOnMainThread:@selector(addActivityIndicator) withObject:nil waitUntilDone:NO];
	self.categoriesArray = [[SharedSessions  GetInstance] GetCategoriesList];
	NSLog(@"coutn is %i",[self.categoriesArray count]);
	[self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
}
-(void)addActivityIndicator{
	indicator.hidden =NO;
	[indicator startAnimating];
}
-(void)reloadTable{
	indicator.hidden =YES;
	[indicator stopAnimating];	
	[tbl_categories reloadData];
}

@end
