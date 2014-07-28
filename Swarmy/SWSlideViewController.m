//
//  SWSlideViewController.m
//  Swarmy
//
//  Created by James Moore on 12/29/13.
//  Copyright (c) 2013 Panic. All rights reserved.
//

#import "SWSlideViewController.h"
#import "SASlideMenuDataSource.h"

@interface SWSlideViewController () <SASlideMenuDataSource, SASlideMenuDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *loggerImage;
@property (weak, nonatomic) IBOutlet UIImageView *listenImage;
@property (weak, nonatomic) IBOutlet UIImageView *reportsImage;
@property (weak, nonatomic) IBOutlet UIImageView *hivesImage;
@property (weak, nonatomic) IBOutlet UIImageView *helpImage;

@end

@implementation SWSlideViewController

- (void)viewWillAppear:(BOOL)animated
{

//	UIImage *paperairplane = [UIImage imageNamed:@"245-paperairplane"];
//	paperairplane = [paperairplane imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
//	self.reportsImage.image = paperairplane;
//	self.reportsImage.tintColor = [UIColor brownColor];

	[super viewWillAppear:animated];
}

#pragma mark - SASlideMenuDataSource
// The SASlideMenuDataSource is used to provide the initial segueid that represents the initial visibile view controller and to provide eventual additional configuration to the menu button

- (NSIndexPath *)selectedIndexPath
{
	return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (Boolean)shouldRespondToGesture:(UIGestureRecognizer *)gesture forIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

- (NSString *)segueIdForIndexPath:(NSIndexPath *)indexPath
{

	if (indexPath.section == 0) {

		if (indexPath.row == 0) {
			return @"datalogger";
		} else if (indexPath.row == 1){
			return @"listen";
		} else if (indexPath.row == 2){
			return @"reports";
		} else if (indexPath.row == 3){
			return @"hives";
		}

	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return @"help";
		} else if (indexPath.row == 1) {
			return @"credits";
		}
	}

	return @"error";
}

- (Boolean)disablePanGestureForIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row ==0) {
		return YES;
	}

	return NO;
}

- (CGFloat)leftMenuVisibleWidth
{
	return 280;
}

// This is used to configure the menu button. The beahviour of the button should not be modified
- (void)configureMenuButton:(UIButton *)menuButton
{
	menuButton.frame = CGRectMake(0, 0, 40, 29);

	[menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
}

#pragma mark - View Lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
