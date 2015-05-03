//
//  WaitingView.h
//  KatieAlert
//
//  Created by My Mac on 12/23/11.
//  Copyright 2011 PCC. All rights reserved.
//

//#import <UIKit/UIKit.h>


@interface WaitingView : UIView {
	IBOutlet UIActivityIndicatorView *spinner;

}

-(void)startAnimation;
-(void)stopAnimation;

-(void)removeOverlayView;

+(UIView*) loadInstanceFromNib;
@end
