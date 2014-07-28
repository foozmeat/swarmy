//
//  SWLoggerFilter.m
//  Swarmy
//
//  Created by James Moore on 12/30/13.
//  Copyright (c) 2013 James Moore. All rights reserved.
//

#import "SWLoggerFilter.h"
#import "SWFasterMovingAverage.h"
#import <Accelerate/Accelerate.h>

#import <EZAudio/EZAudio.h>

@interface SWLoggerFilter ()
@property (nonatomic) float Q;
@property (nonatomic) float G;

@end

@implementation SWLoggerFilter

+ (SWLoggerFilter *)sharedInstance
{
	static dispatch_once_t onceToken;
	static SWLoggerFilter *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[super alloc] initUniqueInstance];
	});

	return sharedInstance;
}

- (SWLoggerFilter *)initUniqueInstance
{
	self = [super init];

	if (self) {

		for (int i = 0; i < 5; i++) {
			coefficients[i] = 0.0f;
		}

		for (int i = 0; i < MAX_CHANNEL_COUNT; i++) {
			gInputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
			gOutputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
		}

		zero = 0.0f;
		one = 1.0f;

		samplingRate = 44100;
		_centerFrequency = 225.0f;
		_Q = 50.0f;
		_G = 15.0f;
		_dBLevel = 0;

		_movingAverage = [[SWFasterMovingAverage alloc] initWithPeriod:50];

		[[EZMicrophone sharedMicrophone] setMicrophoneDelegate:self];

	}

	return self;

}

#pragma mark - setters

- (void)setCenterFrequency:(float)centerFrequency
{
	_centerFrequency = centerFrequency;
	[self calculateCoefficients];
}

#pragma mark - filter configuration

- (void)intermediateVariables:(float)Fc Q:(float)Q
{
	omega = 2 * M_PI * Fc / samplingRate;
	omegaS = sin(omega);
	omegaC = cos(omega);
	alpha = omegaS / (2 * Q);
}

- (void)calculateCoefficients
{
	if ((_centerFrequency != 0.0f) && (_Q != 0.0f)) {

		[self intermediateVariables:_centerFrequency Q:_Q];

		a0 = 1 + alpha;
		b0 = alpha                  / a0;
		b1 = 0                      / a0;
		b2 = (-1 * alpha)           / a0;
		a1 = (-2 * omegaC)          / a0;
		a2 = (1 - alpha)            / a0;

		coefficients[0] = (float) b0;
		coefficients[1] = (float) b1;
		coefficients[2] = (float) b2;
		coefficients[3] = (float) a1;
		coefficients[4] = (float) a2;

	}
}

#pragma mark - EZMicrophoneDelegate

- (void)microphone:(EZMicrophone *)microphone
	hasAudioReceived:(float **)buffer
		withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
	[self filterContiguousData:*buffer numFrames:bufferSize channel:0];
	[self getdBLevel:*buffer numFrames:bufferSize numChannels:1];
}

- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription
{
  [EZAudio printASBD:audioStreamBasicDescription];
	samplingRate = audioStreamBasicDescription.mSampleRate;
	[self calculateCoefficients];
}

#pragma mark - internals

- (void)getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels
{
	float copyData[(numFrames *numChannels)];

	vDSP_vsq(data, 1, copyData, 1, numFrames*numChannels);
	float meanVal = 0.0;
	vDSP_meanv(copyData, 1, &meanVal, numFrames*numChannels);

	vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
	one = 1.0f;

	_dBLevel = _dBLevel + 0.2 * (meanVal - _dBLevel);

	if (_dBLevel != _dBLevel) {
		// nan
		_dBLevel = -50.0f;
	}

	[self.movingAverage addValue:_dBLevel];
}

- (void)filterContiguousData:(float *)data numFrames:(UInt32)numFrames channel:(UInt32)channel
{

	float gain = self.G;
	vDSP_vsmul(data, 1, &gain, data, 1, numFrames);

	// Provide buffer for processing
	float *tInputBuffer = (float *) malloc((numFrames + 2) * sizeof(float));
	float *tOutputBuffer = (float *) malloc((numFrames + 2) * sizeof(float));

	// Copy the data
	memcpy(tInputBuffer, gInputKeepBuffer[channel], 2 * sizeof(float));
	memcpy(tOutputBuffer, gOutputKeepBuffer[channel], 2 * sizeof(float));
	memcpy(&(tInputBuffer[2]), data, numFrames * sizeof(float));

	// Do the processing
	vDSP_deq22(tInputBuffer, 1, coefficients, tOutputBuffer, 1, numFrames);

	// Copy the data
	memcpy(data, tOutputBuffer, numFrames * sizeof(float));
	memcpy(gInputKeepBuffer[channel], &(tInputBuffer[numFrames]), 2 * sizeof(float));
	memcpy(gOutputKeepBuffer[channel], &(tOutputBuffer[numFrames]), 2 * sizeof(float));

	free(tInputBuffer);
	free(tOutputBuffer);
	
}

#pragma mark - Level Average

- (void)resetAverage
{
	[self.movingAverage clear];
}

- (double)averageLevel
{
	return [self.movingAverage average];
}

- (void)play
{
	[[EZMicrophone sharedMicrophone] startFetchingAudio];
}

- (void)pause
{
//	[EZMicrophone sharedMicrophone].microphoneDelegate = nil;
	[[EZMicrophone sharedMicrophone] stopFetchingAudio];
}

@end
