//
//  ReportAnIssue.m
//  WizTank
//
//  Created by Shafqat on 1/17/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import "ReportAnIssue.h"


@implementation ReportAnIssue

@synthesize delegate;


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
//	[view_textView release];
//	[view_TransparentView release];
//	[txtV_issue release];
//	[delegate release];
    [super dealloc];
}
#pragma mark Loading Methods
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
-(void)addToTransparentView{
	self.frame=CGRectMake(0, 0,320,480);
	[self addSubview:view_TransparentView];
	view_textView.frame=CGRectMake(15,75,290,165);
	[self addSubview:view_textView];
	UIButton *btn_Close=[UIButton buttonWithType:UIButtonTypeCustom];
	btn_Close.frame=CGRectMake(290,55,30,30);	
	[btn_Close setBackgroundImage:[UIImage imageNamed:@"btn_closeImage.png"] forState:UIControlStateNormal];
	[btn_Close addTarget:self action:@selector(btn_Action_Close) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:btn_Close];
	[txtV_issue becomeFirstResponder];
}
#pragma mark IBActions
-(IBAction)btn_Action_Done
{
	if ([txtV_issue.text isEqualToString:@""] || txtV_issue.text == nil) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
														message:@"Please enter the issue first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}	
	else{
		[self removeFromSuperview];
		[delegate IssueText:txtV_issue.text];
	}
}
-(IBAction)btn_Action_Close
{
	[self removeFromSuperview];
}
@end
