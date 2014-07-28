	//
	//  AppDelegate.m
	//  Apidictor
	//
	//  Created by James Moore on 7/3/12.
	//  Copyright (c) 2012 Panic. All rights reserved.
	//

#import "SWAppDelegate.h"
#import "SWHiveStore.h"
#import "EAIntroView.h"
#import <HockeySDK/HockeySDK.h>
#import <Appirater/Appirater.h>

@implementation SWAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	[[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:@"32530f048cb25458bd912b3febb2bab2"
																											 liveIdentifier:@"aa6580c16c54c1c1e8394c503aff36bd"
																														 delegate:self];


#ifdef CONFIGURATION_Release
	[Appirater setAppId:@"594212637"];
	[Appirater setDaysUntilPrompt:7];
	[Appirater setUsesUntilPrompt:5];
	[Appirater setSignificantEventsUntilPrompt:-1];
	[Appirater setTimeBeforeReminding:2];
	[Appirater setDebug:NO];
#endif

#ifdef CONFIGURATION_Beta

	NSString *compileDate = [NSString stringWithUTF8String:__DATE__];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d yyyy"];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[dateFormatter setLocale:locale];
	NSDate *buildDate = [dateFormatter dateFromString:compileDate];
	NSDate *expirationDate = [buildDate dateByAddingTimeInterval:(60.0 * 60.0 * 24.0 * 30.0)];

	[[BITHockeyManager sharedHockeyManager].updateManager setExpiryDate:expirationDate];

	[[BITHockeyManager sharedHockeyManager].authenticator setAuthenticationSecret:@"21c59f2dad466bd8ec91aa6d59598f89"];
	[[BITHockeyManager sharedHockeyManager].authenticator setIdentificationType:BITAuthenticatorIdentificationTypeHockeyAppEmail];
	[[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
#endif

#if (TARGET_IPHONE_SIMULATOR||CONFIGURATION_Debug)
	[BITHockeyManager sharedHockeyManager].disableUpdateManager = YES;
	[BITHockeyManager sharedHockeyManager].disableCrashManager = YES;
	[BITHockeyManager sharedHockeyManager].debugLogEnabled = YES;
#endif

	[BITHockeyManager sharedHockeyManager].crashManager.showAlwaysButton = YES;
	[BITHockeyManager sharedHockeyManager].disableFeedbackManager = YES;

	[[BITHockeyManager sharedHockeyManager] startManager];

	[self versionCheck];

	[MagicalRecord setupAutoMigratingCoreDataStack];

	[[SWHiveStore defaultStore] createDefaultDataIfNeccessary];

	[Appirater appLaunched:YES];

	return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  // Get topmost/visible view controller
  UIViewController *currentViewController = [self topViewController];

  // Check whether it implements a dummy methods called canRotate
	SEL selector = NSSelectorFromString(@"canRotate");

  if ([currentViewController respondsToSelector:selector]) {
		// Unlock landscape view orientations for this view controller
		return UIInterfaceOrientationMaskAllButUpsideDown;
  }

  // Only allow portrait (standard behaviour)
  return UIInterfaceOrientationMaskPortrait;
}

- (UIViewController *)topViewController
{
  return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController

{
  if ([rootViewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabBarController = (UITabBarController *)rootViewController;

    return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];

  } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)rootViewController;

		return [self topViewControllerWithRootViewController:navigationController.visibleViewController];

	} else if (rootViewController.presentedViewController) {
    UIViewController *presentedViewController = rootViewController.presentedViewController;

		return [self topViewControllerWithRootViewController:presentedViewController];

	} else {

		return rootViewController;
  }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

- (void)versionCheck
{
	int lastVersionRun = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"LastVersionRun"];

	if (lastVersionRun >= 10 && lastVersionRun <= 99) {
		lastVersionRun *= 10;
	}

	NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSString *intVersionString = [versionString	stringByReplacingOccurrencesOfString:@"." withString:@""];
	int newVersion = [intVersionString intValue];

	if (newVersion >= 10 && newVersion <= 99) {
		newVersion *= 10;
	}

	if (newVersion != lastVersionRun) {
		DLog(@"Last Version: %i, New Version: %i", lastVersionRun, newVersion);
		[[SWHiveStore defaultStore] migrateDataFromVersion:lastVersionRun];
		[[NSUserDefaults standardUserDefaults] setInteger:newVersion forKey:@"LastVersionRun"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}

}

@end
