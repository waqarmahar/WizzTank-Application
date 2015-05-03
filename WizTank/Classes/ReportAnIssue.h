//
//  ReportAnIssue.h
//  WizTank
//
//  Created by Shafqat on 1/17/12.
//  Copyright 2012 GenITeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReportIssueProtocol

-(void)IssueText:(NSString *)txt;

@end

@interface ReportAnIssue : UIView {
	IBOutlet UIView *view_TransparentView;
	IBOutlet UIView *view_textView;
	IBOutlet UITextView *txtV_issue;
	
	id <ReportIssueProtocol> delegate;
}

@property(nonatomic,retain) id <ReportIssueProtocol> delegate;

+(UIView*) loadInstanceFromNib;
-(void)addToTransparentView;

-(IBAction)btn_Action_Done;
-(IBAction)btn_Action_Close;
@end
