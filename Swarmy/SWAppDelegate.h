//
//  AppDelegate.h
//  Apidictor
//
//  Created by James Moore on 7/3/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, BITHockeyManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
