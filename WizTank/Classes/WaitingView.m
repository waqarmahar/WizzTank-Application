//
//  WaitingView.m
//  KatieAlert
//
//  Created by My Mac on 12/23/11.
//  Copyright 2011 PCC. All rights reserved.
//

#import "WaitingView.h"


@implementation WaitingView


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
-(void)removeOverlayView
{
	[self removeFromSuperview];
}
-(void)startAnimation
{
	[spinner startAnimating];
}
-(void)stopAnimation
{
	[spinner stopAnimating];
}


- (void)dealloc {
    [super dealloc];
}


@end
