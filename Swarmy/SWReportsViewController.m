//
//  SWReportsViewController.m
//  Swarmy
//
//  Created by James Moore on 1/30/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "SWReportsViewController.h"
#import "SWHive.h"
#import "SWHiveStore.h"
#import "SWLogEntry.h"
#import "SWSampleSet.h"
#import "SWSample.h"

#import "CHCSVParser.h"

@import MessageUI;

@interface SWReportsViewController ()
@property (nonatomic, strong) SWHive *activeHive;

@property (strong, nonatomic) IBOutlet UITableViewCell *hiveSelectorButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *exportAllNotesButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *exportAllSamplesButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *exportTodaysNotes;

@end

@implementation SWReportsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

	if (self) {
        // Custom initialization
    }

  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.activeHive = [[SWHiveStore defaultStore] activeHive];

	self.hiveSelectorButton.detailTextLabel.text = self.activeHive.name;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tappedCell = [tableView cellForRowAtIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSPredicate *hivePredicate = [NSPredicate predicateWithFormat:@"hive == %@", self.activeHive];

	NSString *tempPath = NSTemporaryDirectory();

	NSDateFormatter *df = [NSDateFormatter new];
	df.dateStyle = NSDateFormatterShortStyle;
	df.timeStyle = NSDateFormatterShortStyle;

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"frequency" ascending:YES];

	NSString *tempFile;

	if (tappedCell == _exportAllNotesButton) {

		DLog(@"Export All notes");
		NSArray *notes = [SWLogEntry MR_findAllSortedBy:@"date" ascending:YES withPredicate:hivePredicate];

		tempFile = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Notes for %@.csv", self.activeHive.name]];
		CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:tempFile];
		[writer writeLineOfFields:@[@"Date", @"Note"]];

		for (SWLogEntry *logEntry in notes) {
			[writer writeLineOfFields:@[[df stringFromDate:logEntry.date], logEntry.note]];
		}

		[writer closeStream];


	} else if (tappedCell == _exportAllSamplesButton) {
		DLog(@"Export All samples");

		NSArray *sampleSets = [SWSampleSet MR_findAllSortedBy:@"date" ascending:YES withPredicate:hivePredicate];
		
		DLog(@"Found %i sets", (int)sampleSets.count);

		tempFile = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Samples for %@.csv", self.activeHive.name]];
		CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:tempFile];
		[writer writeField:@"Date"];

		NSArray *sortedSample = [[[sampleSets.firstObject samples] allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];

		for (SWSample *s in sortedSample) {
			[writer writeField:s.frequency.stringValue];
		}

		[writer finishLine];

		for (SWSampleSet *set in sampleSets) {
			[writer writeField:[df stringFromDate:set.date]];

			NSArray *sortedSamples = [[set.samples allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];

			for (SWSample *s in sortedSamples) {
				[writer writeField:s.level.stringValue];
			}

			[writer finishLine];
		}

		[writer closeStream];

	} else if (tappedCell == _exportTodaysNotes) {
		DLog(@"Export today's notes");

		df.dateStyle = NSDateFormatterMediumStyle;
		df.timeStyle = NSDateFormatterNoStyle;

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;

    NSDate *lastMidnight = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *nextMidnight = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:lastMidnight options:NSWrapCalendarComponents];

    NSPredicate *today = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", lastMidnight, nextMidnight];

		DLog(@"%@", today);

		NSString *tempFilename = [NSString stringWithFormat:@"Notes for %@.csv", [df stringFromDate:[NSDate date]]];
		DLog(@"%@", tempFilename);

		df.dateStyle = NSDateFormatterShortStyle;
		df.timeStyle = NSDateFormatterShortStyle;

		tempFile = [tempPath stringByAppendingPathComponent:tempFilename];

		NSArray *notes = [SWLogEntry MR_findAllSortedBy:@"hive.name" ascending:YES withPredicate:today];

		CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:tempFile];
		[writer writeLineOfFields:@[@"Date", @"Hive", @"Note"]];

		for (SWLogEntry *logEntry in notes) {
			[writer writeLineOfFields:@[[df stringFromDate:logEntry.date], logEntry.hive.name, logEntry.note]];
		}

		[writer closeStream];

	}

	NSData *exportedData = [NSData dataWithContentsOfFile:tempFile];
	MFMailComposeViewController *picker = [MFMailComposeViewController new];
	picker.mailComposeDelegate = self;

	if (tempFile != nil) {
		if ([MFMailComposeViewController canSendMail]) {
			[picker setSubject:[tempFile lastPathComponent]];
			[picker addAttachmentData:exportedData mimeType:@"text/csv" fileName:[tempFile lastPathComponent]];
			[picker setToRecipients:[NSArray array]];
			[picker setMessageBody:@"" isHTML:NO];
			[picker setMailComposeDelegate:self];
			[self presentViewController:picker animated:YES completion:nil];

		} else {
			[self launchMailAppOnDevice];
		}
	}

}

#pragma mark - mail

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device.
- (void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?subject=Please set up your email!";
	NSString *body = @"&body=Please set up your email!";

	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
