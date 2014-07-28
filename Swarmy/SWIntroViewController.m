//
//  SWIntroViewController.m
//  Swarmy
//
//  Created by James Moore on 1/29/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "SWIntroViewController.h"
#import "EAIntroView.h"

@interface SWIntroViewController ()

@end

@implementation SWIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self) {
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	NSArray *pages = @[[EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page], [EAIntroPage page]];

	NSArray *titles = @[@"Welcome",
											@"",
											@"Microphone",
											@"Menu",
											@"Data Logger",
											@"Observe",
											@"Reports",
											@"Hives",
											@"Questions?"
											];
	NSArray *images;

	if (([[UIScreen mainScreen] bounds].size.height == 568)) {
		images = @[
							 [UIImage imageNamed:@"introsmiley"],
							 [UIImage imageNamed:@"introwarning"],
							 [UIImage imageNamed:@"intromic"],
							 [UIImage imageNamed:@"intromenu"],
							 [UIImage imageNamed:@"introchart"],
							 [UIImage imageNamed:@"introclipboard"],
							 [UIImage imageNamed:@"introreport"],
							 [UIImage imageNamed:@"introhive"],
							 [UIImage imageNamed:@"introhelp"]
							 ];
	} else {
		images = @[
							 [UIImage imageNamed:@"introsmileylow"],
							 [UIImage imageNamed:@"introwarninglow"],
							 [UIImage imageNamed:@"intromiclow"],
							 [UIImage imageNamed:@"intromenulow"],
							 [UIImage imageNamed:@"introchartlow"],
							 [UIImage imageNamed:@"introclipboardlow"],
							 [UIImage imageNamed:@"introreportlow"],
							 [UIImage imageNamed:@"introhivelow"],
							 [UIImage imageNamed:@"introhelplow"]
							 ];
		
	}

	NSArray *descriptions = @[@"Thank you for trying Swarmy.\n\nSwipe to the left to continue.",
														@"Swarmy measures the sound levels in your beehive. Keep in mind that Swarmy is an experimental tool. It cannot predict swarms in your beehives. That job is left up to you!",
														@"To use Swarmy effectively you should connect an external microphone to your device. Try to be consistent about placing your microphone whenever you record the sound levels.",
														@"Use the menu button in the upper-left to access all of Swarmy’s features",
														@"The data logger screen will record sound levels at 7 different frequencies. As these sound levels change over time you may be able to predict when your hive will swarm.",
														@"The observe screen is good for simply listening to the sound in your hive. You can also use this screen to record a note about what you hear or see.",
														@"On the reports screen you can export data from Swarmy to view it on your computer. If you use Swarmy to take notes on several hives a day then you can export these notes as a batch.",
														@"The hives screen is where you add and remove Hives to store your data.",
														@"If you have any questions please get in touch with me via the help screen.\nGood luck!"
														];

	for (NSUInteger i = 0; i < pages.count; i++) {

		EAIntroPage *currentPage = (EAIntroPage *)pages[i];
		currentPage.titlePositionY = 300;
		currentPage.title = titles[i];
		currentPage.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];

		currentPage.descPositionY = 250;
		currentPage.desc = descriptions[i];
		currentPage.descFont = [UIFont fontWithName:@"Helvetica Neue" size:20];
		currentPage.descriptionLabelSidePadding = 20.0f;

		currentPage.titleIconView =  [[UIImageView alloc] initWithImage:images[i]];

//		DLog(@"%@", currentPage.descriptionLabelMaximumWidth);
	}

	self.introView = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pages];
	self.introView.delegate = self;
	self.introView.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue

	[self.introView showInView:self.view animateDuration:0.8f];

}

- (void)introDidFinish:(EAIntroView *)introView
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
