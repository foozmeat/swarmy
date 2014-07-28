	//
	//  ListenTableViewController.m
	//  Swarmy
	//
	//  Created by James Moore on 7/19/12.
	//  Copyright (c) 2012 Panic. All rights reserved.
	//

#import "ListenTableViewController.h"
#import "SWHivePickerController.h"
#import "SWEmptyView.h"
#import "SWHive.h"
#import "SWLogEntry.h"
#import "SWHiveStore.h"
#import <EZAudio/EZAudio.h>

@interface ListenTableViewController () {
	TPCircularBuffer _circularBuffer;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *micSwitchCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *filterPickerCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *hiveSelectorCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *recordEntryCell;

@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;

@property (weak, nonatomic) IBOutlet UITextView *noteView;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet EZAudioPlotGL *micPlotView;
@property (nonatomic,strong) EZMicrophone *microphone;


@end

@implementation ListenTableViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffMic:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];

	[self configureCells];

	[EZMicrophone sharedMicrophone].microphoneDelegate = self;
  [EZOutput sharedOutput].outputDataSource = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
	[self micOff];

	[EZMicrophone sharedMicrophone].microphoneDelegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
  [super viewWillDisappear:animated];
	
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [EZAudio circularBuffer:&_circularBuffer withSize:2048];
  self.micPlotView.plotType = EZPlotTypeBuffer;
	self.micPlotView.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]; //iOS7 dark blue
  self.micPlotView.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
  self.micPlotView.shouldMirror = NO;
  self.micPlotView.shouldFill = NO;

}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
	[self validateRecordButton];
}

#pragma mark - Tableview

- (void)configureCells
{

  self.hiveSelectorCell.detailTextLabel.text = [[[SWHiveStore defaultStore] activeHive] name];

  [self validateRecordButton];
}

- (IBAction)recordButtonTapped:(id)sender
{

	[self.noteView resignFirstResponder];

	SWLogEntry *newLogEntry = [SWLogEntry MR_createEntity];
	newLogEntry.hive = [[SWHiveStore defaultStore] activeHive];
	newLogEntry.date = [NSDate date];
	newLogEntry.note = self.noteView.text;

	[[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:nil];

	self.noteView.text = @"";

	[self validateRecordButton];
}

- (void)micOff
{
	DLog(@"Turning off mic");
  self.micSwitch.on = NO;
	[[EZMicrophone sharedMicrophone] stopFetchingAudio];
	[[EZOutput sharedOutput] stopPlayback];
}

#pragma mark - UI delegates

-(void)validateRecordButton
{
	self.recordButton.enabled = ([[SWHiveStore defaultStore] activeHive] && ![self.noteView.text isEqualToString:@""]);
}

-(void)turnOffMic:(NSNotification *)ns
{
	[self micOff];
}

- (IBAction)micSwitchChanged:(UISwitch *)sender
{
  if (sender.on) {
		[[EZMicrophone sharedMicrophone] startFetchingAudio];
		[[EZOutput sharedOutput] startPlayback];

  } else {
		[self micOff];
  }

}

#pragma mark - EZMicrophoneDelegate
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.micPlotView updateBuffer:buffer[0] withBufferSize:bufferSize];
  });
}

// Append the AudioBufferList from the microphone callback to a global circular buffer
-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  /**
   Append the audio data to a circular buffer
   */
  [EZAudio appendDataToCircularBuffer:&_circularBuffer fromAudioBufferList:bufferList];
}


- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription
{
  [EZAudio printASBD:audioStreamBasicDescription];
}

#pragma mark - EZOutputDataSource
-(TPCircularBuffer *)outputShouldUseCircularBuffer:(EZOutput *)output {
  return [EZMicrophone sharedMicrophone].microphoneOn ? &_circularBuffer : nil;
}

#pragma mark - Cleanup
-(void)dealloc {
  [EZAudio freeCircularBuffer:&_circularBuffer];
}

@end
