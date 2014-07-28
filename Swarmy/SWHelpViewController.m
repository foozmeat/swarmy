//
//  HelpViewController.m
//  Swarmy
//
//  Created by James Moore on 4/24/13.
//  Copyright (c) 2013 Panic. All rights reserved.
//

@import UIKit;
@import MessageUI;
@import Social;

#import "SWHelpViewController.h"

@interface SWHelpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIButton *introButton;

@property (weak, nonatomic) IBOutlet UILabel *versionString;

@end

@implementation SWHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	if (self) {
        // Custom initialization
    }

	return self;
}

- (IBAction)leaveRating:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id594212637"]];
}

- (void)viewDidLoad
{

	NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

	self.versionString.text = [NSString stringWithFormat:@"Version %@ (%@)", version, build];

	[super viewDidLoad];

}

- (IBAction)openMail:(id)sender
{
  if ([MFMailComposeViewController canSendMail])  {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;

    NSArray *toRecipients = [NSArray arrayWithObjects:@"swarmyapp@jmoore.me", nil];
    [mailer setToRecipients:toRecipients];

		[self presentViewController:mailer animated:YES completion:nil];

  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
																										message:@"You need to add a mail account in Settings"
																									 delegate:nil
																					cancelButtonTitle:@"OK"
																					otherButtonTitles:nil];
    [alert show];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  switch (result) {
    case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");

			break;
    case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the drafts folder.");

			break;
    case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");

			break;
    case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");

			break;
//    default:
//			NSLog(@"Mail not sent.");
//			break;
  }
		// Remove the mail view
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tweetButtonPressed:(id)sender
{
		//Create the tweet sheet
	SLComposeViewController *socialSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

	[socialSheet setInitialText:@"@swarmyapp "];

		//Show the tweet sheet!
	[self presentViewController:socialSheet animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[self setEmailButton:nil];
	[self setTweetButton:nil];
	[self setVersionString:nil];
}

@end
