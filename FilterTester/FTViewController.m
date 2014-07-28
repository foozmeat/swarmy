//
//  FTViewController.m
//  FilterTester
//
//  Created by James Moore on 2/23/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "FTViewController.h"
#import <EZAudio/EZAudio.h>
#import "FTAudioFilter.h"
@import Accelerate;

@interface FTViewController () {
}

@property (weak, nonatomic) IBOutlet UISlider *freqSlider;
@property (weak, nonatomic) IBOutlet UILabel *freqLabel;
@property (weak, nonatomic) IBOutlet UILabel *qLabel;
@property (weak, nonatomic) IBOutlet UISlider *qSlider;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (nonatomic,strong) FTAudioFilter *audioFilter;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;

@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlotFreq;
@property (weak, nonatomic) IBOutlet EZAudioPlotGL *audioPlot;

@end

static const int freqStepValue = 10;

@implementation FTViewController

- (IBAction)updateSliderValue:(id)sender {

	if (sender == self.freqSlider) {
//		int currentValue = roundf((self.freqSlider.value - 225.0f) / freqStepValue);
//
//		self.freqSlider.value = 225 + (currentValue * freqStepValue);

		self.freqLabel.text = [NSString stringWithFormat:@"%i Hz", (int) self.freqSlider.value];
		self.audioFilter.centerFrequency = self.freqSlider.value;

	} else if (sender == self.qSlider) {
		self.qLabel.text = [NSString stringWithFormat:@"%f", self.qSlider.value];
		self.audioFilter.Q = self.qSlider.value;

	} else if (sender == self.gSlider) {
		self.gLabel.text = [NSString stringWithFormat:@"%f", self.gSlider.value];
		self.audioFilter.G = self.gSlider.value;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.freqLabel.text = [NSString stringWithFormat:@"%i Hz", (int) self.freqSlider.value];
	self.qLabel.text = [NSString stringWithFormat:@"%f", self.qSlider.value];
	self.gLabel.text = [NSString stringWithFormat:@"%f", self.gSlider.value];

}

- (void)viewDidLoad
{
	[super viewDidLoad];

  // Background color
  self.audioPlot.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
  // Waveform color
  self.audioPlot.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  // Plot type
  self.audioPlot.plotType        = EZPlotTypeRolling;
  self.audioPlot.shouldFill = NO;
  self.audioPlot.shouldMirror = NO;

	self.audioPlotFreq.backgroundColor = [UIColor colorWithRed: 0.984 green: 0.471 blue: 0.525 alpha: 1];
  self.audioPlotFreq.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  self.audioPlotFreq.shouldFill      = NO;
  self.audioPlotFreq.plotType        = EZPlotTypeBuffer;

	self.audioFilter = [[FTAudioFilter alloc] init];
	self.audioFilter.delegate = self;
	self.audioFilter.centerFrequency = self.freqSlider.value;
	self.audioFilter.Q = self.qSlider.value;
	self.audioFilter.G = self.gSlider.value;
}

- (IBAction)micSwitchChanged:(UISwitch *)sender {
	self.audioFilter.micOn = sender.isOn;
}

- (void)updateAudioPlotsWithBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize
{
	[self.audioPlot updateBuffer:buffer withBufferSize:bufferSize];
}

- (void)updateFFTWithBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize
{
	[self.audioPlotFreq updateBuffer:buffer withBufferSize:bufferSize];
}

- (void)updateSoundLevel:(float)level
{
	self.levelLabel.text = [NSString stringWithFormat:@"%0.0f", level];
}

@end
