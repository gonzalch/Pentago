//
//  PentagoSubboardViewController.h
//  Pentago
//
//  Created by Ali Kooshesh on 2/5/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PentagoBrain.h"

@interface PentagoSubboardViewController : UIViewController

-(id) initWithSubsquare: (int) position;
-(PentagoBrain *)getPBrain;

@end
