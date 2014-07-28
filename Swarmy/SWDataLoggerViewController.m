//
//  SWDataLoggerViewController.m
//  Swarmy
//
//  Created by James Moore on 12/29/13.
//  Copyright (c) 2013 James Moore. All rights reserved.
//

#import "SWDataLoggerViewController.h"
#import "SWHive.h"
#import "SWHivePickerController.h"
#import "SWSampleSet.h"
#import "SWSample.h"
#import "SWSampleOperation.h"
#import "SWHiveStore.h"
#import "SWIntroViewController.h"

@interface SWDataLoggerViewController () 
@property (strong, nonatomic) IBOutlet UILabel *lastSampleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastSampleDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *sampleDataCell;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) IBOutlet UITableViewCell *sampleOnceButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *sampleEveryFiveButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *hiveSelectorButton;

@property (strong, nonatomic) UILabel *s1;
@property (strong, nonatomic) UILabel *s2;
@property (strong, nonatomic) UILabel *s3;
@property (strong, nonatomic) UILabel *s4;
@property (strong, nonatomic) UILabel *s5;
@property (strong, nonatomic) UILabel *s6;
@property (strong, nonatomic) UILabel *s7;
@property (strong, nonatomic) UILabel *s8;
@property (strong, nonatomic) UILabel *s9;

@property (strong, nonatomic) NSDictionary *sampleDataLabels;

@property (nonatomic, strong) SWHive *activeHive;
@property (nonatomic, strong) SWSampleSet *activeSampleSet;

@property (nonatomic, strong) NSDate *lastSampleDate;

@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) NSTimer *countdownTimer;
@property BOOL timerRunning;
@property NSTimeInterval countdownInterval;
@property NSDate *startDate;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSArray *frequencies;

@end

static int timerInterval = 300;

@implementation SWDataLoggerViewController

#pragma mark - SWLoggerFilterDelegate

- (void)receiveSample:(NSDictionary *)data
{

	DLog(@"Receiving data: %@", data);

	UILabel *sampleLabel = self.sampleDataLabels[data[@"label"]];
	sampleLabel.text = [NSString stringWithFormat:@"%0.1f", [[data objectForKey:@"level"] floatValue]];
	sampleLabel.enabled = YES;

	SWSample *sample = [SWSample MR_createEntity];
	sample.set = self.activeSampleSet;
	sample.frequency = data[@"frequency"];
	sample.level = data[@"level"];

}

- (void)samplingCompleted
{

	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		[self.alertView dismissWithClickedButtonIndex:0 animated:YES];
	}];

	self.activeSampleSet = nil;

	if (self.timerRunning) {
		[self performSelectorOnMainThread:@selector(resetTimer) withObject:nil waitUntilDone:NO];
	}


}

- (void)resetTimer
{
	self.startDate = [NSDate date];
	self.countdownInterval = timerInterval;
	self.countdownTimer = nil;

	self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];

}

#pragma mark - button actions

- (void)sampleOnce
{
	DLog(@"Sampling...");
	
	for (NSString *k in _sampleDataLabels) {
		UILabel *l = [_sampleDataLabels objectForKey:k];
    l.text = @"--";
	}

	SWSampleSet *sampleSet = [SWSampleSet MR_createEntity];
	self.activeSampleSet = sampleSet;

	sampleSet.hive = self.activeHive;

	self.lastSampleDate = [NSDate date];

	sampleSet.date = self.lastSampleDate;

	self.lastSampleLabel.enabled = YES;

	[self.alertView show];

	int counter = 1;

	for (NSNumber *freq in _frequencies) {

		SWSampleOperation *sampler = [[SWSampleOperation alloc] initWithCenterFrequency:freq forSample:[NSNumber numberWithInt:counter]];
		sampler.delegate = self;

		[self.queue addOperation:sampler];

		counter++;
	}

	self.lastSampleDateLabel.enabled = YES;

}

- (void)sampleEveryFive
{
	if (self.countdownTimer.isValid) {
		[self.countdownTimer invalidate];

		self.countdownInterval = 0;

		self.timerLabel.text = @"5:00";
		self.timerLabel.enabled = NO;

		self.sampleOnceButton.textLabel.enabled = YES;

		self.sampleEveryFiveButton.textLabel.text = @"Sample Every 5 Minutes";
		self.sampleEveryFiveButton.textLabel.textColor = [UIColor blackColor];
		self.sampleEveryFiveButton.backgroundColor = [UIColor whiteColor];

		self.timerRunning = NO;
		[UIApplication sharedApplication].idleTimerDisabled = NO;

	} else {
		[self resetTimer];
        
		self.sampleOnceButton.textLabel.enabled = NO;

		self.timerLabel.enabled = YES;

		self.sampleEveryFiveButton.textLabel.text = @"Stop Timer";
		self.sampleEveryFiveButton.textLabel.textColor = [UIColor whiteColor];
		self.sampleEveryFiveButton.backgroundColor = [UIColor redColor];

		self.timerRunning = YES;
		[UIApplication sharedApplication].idleTimerDisabled = YES;
	}
}

- (void)timerFired
{

	NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
	NSTimeInterval remainingTime = self.countdownInterval - elapsedTime;

	if (remainingTime <= 0) {
		[self.countdownTimer invalidate];
		[self sampleOnce];
	} else {
		self.timerLabel.text = [self formattedStringForDuration:remainingTime];
	}

}

- (NSString *)formattedStringForDuration:(NSTimeInterval)duration
{
	double minutes = floor(duration / 60);
	double seconds = trunc(duration - minutes * 60);

	return [NSString stringWithFormat:@"%0.0f:%0.0f", minutes, seconds];
}

- (void)configureSampleDataCell
{

	_lastSampleDateLabel.enabled = NO;
	_lastSampleDateLabel.text = @"None";

	_lastSampleLabel.enabled = NO;

	_s1 = [UILabel new];
	_s2 = [UILabel new];
	_s3 = [UILabel new];
	_s4 = [UILabel new];
	_s5 = [UILabel new];
	_s6 = [UILabel new];
	_s7 = [UILabel new];
//	_s8 = [UILabel new];
//	_s9 = [UILabel new];

//	_sampleDataLabels = @{@"s1": _s1, @"s2": _s2, @"s3": _s3, @"s4": _s4, @"s5": _s5, @"s6": _s6, @"s7": _s7, @"s8": _s8, @"s9": _s9};
	_sampleDataLabels = @{@"s1": _s1, @"s2": _s2, @"s3": _s3, @"s4": _s4, @"s5": _s5, @"s6": _s6, @"s7": _s7};

	for (NSString *k in _sampleDataLabels) {

		UILabel *l = [_sampleDataLabels objectForKey:k];

    l.text = @"--";
		l.enabled = NO;
		l.translatesAutoresizingMaskIntoConstraints = NO;
		l.textAlignment = NSTextAlignmentCenter;
		l.font = [l.font fontWithSize:12];

		[_sampleDataCell.contentView addSubview:l];
	}

	[_sampleDataCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_s1
																																					attribute:NSLayoutAttributeBottom
																																					relatedBy:NSLayoutRelationEqual
																																						 toItem:_sampleDataCell.contentView
																																					attribute:NSLayoutAttributeBottom
																																				 multiplier:1
																																					 constant:0]];

//	[_sampleDataCell.contentView addConstraints:[NSLayoutConstraint
//																							 constraintsWithVisualFormat:@"H:|[s1][s2(==s1)][s3(==s1)][s4(==s1)][s5(==s1)][s6(==s1)][s7(==s1)][s8(==s1)][s9(==s1)]|"
//																																											options:NSLayoutFormatAlignAllBottom
//																																											metrics:nil
//																																												views:_sampleDataLabels]];

	[_sampleDataCell.contentView addConstraints:[NSLayoutConstraint
																							 constraintsWithVisualFormat:@"H:|[s1][s2(==s1)][s3(==s1)][s4(==s1)][s5(==s1)][s6(==s1)][s7(==s1)]|"
																																											options:NSLayoutFormatAlignAllBottom
																																											metrics:nil
																																												views:_sampleDataLabels]];


}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

  if ([keyPath isEqual:@"activeHive"]) {
		self.activeHive = [change objectForKey:NSKeyValueChangeNewKey];
  } else if ([keyPath isEqual:@"alive"]) {
		[object removeObserver:self forKeyPath:@"alive" context:NULL];
		[object removeObserver:self forKeyPath:@"activeHive" context:NULL];
  } else if ([keyPath isEqual:@"lastSampleDate"])	{
		NSDateFormatter *f = [NSDateFormatter new];
		f.timeStyle = NSDateFormatterMediumStyle;
		f.dateStyle = NSDateFormatterMediumStyle;

		self.lastSampleDateLabel.text = [f stringFromDate:[change objectForKey:NSKeyValueChangeNewKey]];

	} else if (object == self.queue && [keyPath isEqualToString:@"operations"]) {
    if (self.queue.operationCount == 0) {
      // Do something here when your queue has completed
			[self samplingCompleted];
    }

	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tappedCell = [tableView cellForRowAtIndexPath:indexPath];

	if (tappedCell == _sampleOnceButton) {
		
		if (self.timerRunning) {
			return;
		}
		
		[self sampleOnce];
	} else if (tappedCell == _sampleEveryFiveButton) {
		[self sampleEveryFive];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];

	if (self) {
	}

	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.activeHive = [[SWHiveStore defaultStore] activeHive];
	
	self.hiveSelectorButton.detailTextLabel.text = self.activeHive.name;

	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification
																						 object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self configureSampleDataCell];

	self.queue = [[NSOperationQueue alloc] init];
	self.queue.maxConcurrentOperationCount = 1;
	[self.queue addObserver:self forKeyPath:@"operations" options:0 context:NULL];

//	self.frequencies = @[@225, @232.5, @240, @247.5, @255, @262.5, @270, @277.5, @285];
	self.frequencies = @[@225, @235, @245, @255, @265, @275, @285];

	self.alertView = [[UIAlertView alloc] initWithTitle:@"Measuring Sound Levels\nPlease Wait…"
																							message:nil
																						 delegate:nil
																		cancelButtonTitle:nil
																		otherButtonTitles:nil];
	

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if (![defaults boolForKey:@"ShownIntroduction"]) {
		SWIntroViewController *intro = [SWIntroViewController new];
		[self presentViewController:intro animated:YES completion:^(){
			[defaults setBool:YES forKey:@"ShownIntroduction"];
			[defaults synchronize];
		}];

	}

	[self addObserver:self forKeyPath:@"lastSampleDate" options:NSKeyValueObservingOptionNew context:NULL];


}

- (void)orientationChanged:(NSNotification *)notification
{

	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//		[self performSegueWithIdentifier:@"rotationSegue" sender:self];
		DLog(@"Rotating to landscape");
	} else {
		
	}

}
//- (void)canRotate
//{ }

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"lastSampleDate"];

}
/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
