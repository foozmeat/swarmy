//
//  SWIntroViewController.h
//  Swarmy
//
//  Created by James Moore on 1/29/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface SWIntroViewController : UIViewController <EAIntroDelegate>

@property (nonatomic, strong) EAIntroView *introView;

@end
