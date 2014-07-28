//
//  SWAudioFilter.m
//  Swarmy
//
//  Created by James Moore on 2/23/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "FTAudioFilter.h"
#import <EZAudio/EZAudio.h>
#import "SWFasterMovingAverage.h"

@interface FTAudioFilter() {
	TPCircularBuffer _circularBuffer;
	AEFloatConverter *floatConverter;
	AudioStreamBasicDescription asbd;
}

@end

@implementation FTAudioFilter

- (id)init
{
	if (self = [super init]) {

		for (int i = 0; i < 5; i++) {
			coefficients[i] = 0.0f;
		}

		for (int i = 0; i < MAX_CHANNEL_COUNT; i++) {
			gInputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
			gOutputKeepBuffer[i] = (float *)calloc(2, sizeof(float));
		}

		zero = 0.0f;
		one = 1.0f;

		_centerFrequency = 250.0f;
		_Q = 0.8f;

		_dBLevel = 0.0f;

		_isFFTSetup = NO;

		_movingAverage = [[SWFasterMovingAverage alloc] initWithPeriod:200];

		_micOn = NO;

//		[EZAudio circularBuffer:&_circularBuffer withSize:1024];

		[EZMicrophone sharedMicrophone].microphoneDelegate = self;
//		[EZOutput sharedOutput].outputDataSource = self;

//		[[EZOutput sharedOutput] startPlayback];

		[self addObserver:self forKeyPath:@"micOn" options:NSKeyValueObservingOptionNew context:NULL];

	}

	return self;
}

//- (AudioBufferList *)audioBufferListWithNumberOfFrames:(UInt32)frames
//                                     numberOfChannels:(UInt32)channels
//                                          interleaved:(BOOL)interleaved
//{
//
//	AudioBufferList *audioBufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList) + ((channels - 1) * sizeof(AudioBuffer)));
//
//	audioBufferList->mNumberBuffers = channels;
//	for ( int i = 0; i < audioBufferList->mNumberBuffers; i++ ) {
//    audioBufferList->mBuffers[i].mNumberChannels = 1;
//    audioBufferList->mBuffers[i].mDataByteSize = 0;
//    audioBufferList->mBuffers[i].mData = NULL;
//	}
//
//  return audioBufferList;
//}
//
//- (void)freeBufferList:(AudioBufferList *)bufferList
//{
//  if ( bufferList ) {
//
//    if ( bufferList->mNumberBuffers ) {
//
//      for ( int i = 0; i < bufferList->mNumberBuffers; i++ ) {
//
//        if ( bufferList->mBuffers[i].mData ) {
//          free(bufferList->mBuffers[i].mData);
//        }
//      }
//    }
//    free(bufferList);
//  }
//  bufferList = NULL;
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

	if ([keyPath isEqualToString:@"micOn"]) {

		BOOL newValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];

		if (newValue) {
			[[EZMicrophone sharedMicrophone] startFetchingAudio];
			NSLog(@"Mic on");
		} else {
			[[EZMicrophone sharedMicrophone] stopFetchingAudio];
			NSLog(@"Mic Off");
		}

	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

	}
}

#pragma mark - setters

- (void)setQ:(float)Q
{
	_Q = Q;
	[self calculateCoefficients];
}

- (void)setG:(float)G
{
	_G = G;
	[self calculateCoefficients];
}

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

		[self setCoefficients];
	}
}

- (void)setCoefficients
{
	// // { b0/a0, b1/a0, b2/a0, a1/a0, a2/a0 }
	coefficients[0] = b0;
	coefficients[1] = b1;
	coefficients[2] = b2;
	coefficients[3] = a1;
	coefficients[4] = a2;

	[self stabilityWarning];
	[self logCoefficients];
}

- (void)logCoefficients
{
	NSLog(@"------------\n");
	NSLog(@"Coefficients:\n");

	NSLog(@"a0: %f\n", a0);
	NSLog(@"a1: %f\n", a1);
	NSLog(@"a2: %f\n", a2);
	NSLog(@"b0: %f\n", b0);
	NSLog(@"b1: %f\n", b1);
	NSLog(@"b2: %f\n", b2);

	NSLog(@"\n");

	NSLog(@"|a1| < 1 + a2 ");

	if (abs(a1) < (1 + a2)) {
		NSLog(@"a1 is stable\n");
	} else {
		NSLog(@"a1 is unstable\n");
	}

	NSLog(@"|a2| < 1");

	if (abs(a2) < 1) {
		NSLog(@"a2 is stable\n");
	} else {
		NSLog(@"a2 is unstable\n");
	}

	NSLog(@"------------\n");
}

- (void)stabilityWarning
{
	if (abs(a1) < (1 + a2)) {
	} else {
		NSLog(@"|a1| < 1 + a2 ");
		NSLog(@"Warning: a1 is unstable\n");
	}

	if (abs(a2) < 1) {
	} else {
		NSLog(@"|a2| < 1");
		NSLog(@"Warning: a2 is unstable\n");
	}
}

#pragma mark - EZMicrophoneDelegate

- (void)microphone:(EZMicrophone *)microphone
	hasAudioReceived:(float **)buffer
		withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels
{
  // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.

	[self filterContiguousData:*buffer numFrames:bufferSize channel:0];
	[self getdBLevel:*buffer numFrames:bufferSize numChannels:1];

//	AudioBufferList *bufferList = [self audioBufferListWithNumberOfFrames:bufferSize
//																													numberOfChannels:numberOfChannels
//																															 interleaved:NO];
//
//	if (AEFloatConverterFromFloat(floatConverter, buffer, bufferList, bufferSize)) {
//		[EZAudio appendDataToCircularBuffer:&_circularBuffer fromAudioBufferList:bufferList];
//	}

  dispatch_async(dispatch_get_main_queue(), ^{

		[self.delegate updateAudioPlotsWithBuffer:buffer[0] withBufferSize:bufferSize];
		[self.delegate updateSoundLevel:self.levelAverage];

		// Setup the FFT if it's not already setup
		if (!_isFFTSetup) {
			[self createFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
		}

    // Get the FFT data
    [self updateFFTWithBufferSize:bufferSize withAudioData:buffer[0]];
	});

//	[self freeBufferList:bufferList];

}

- (void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription
{
  [EZAudio printASBD:audioStreamBasicDescription];
	asbd = audioStreamBasicDescription;

	samplingRate = audioStreamBasicDescription.mSampleRate;
	[self calculateCoefficients];

//	floatConverter = [[AEFloatConverter alloc] initWithSourceFormat:audioStreamBasicDescription];

}

#pragma mark - EZOutputDataSource

//- (TPCircularBuffer *)outputShouldUseCircularBuffer:(EZOutput *)output
//{
//  return [EZMicrophone sharedMicrophone].microphoneOn ? &_circularBuffer : nil;
//}

//- (void)microphone:(EZMicrophone *)microphone
//		 hasBufferList:(AudioBufferList *)bufferList
//		withBufferSize:(UInt32)bufferSize
//withNumberOfChannels:(UInt32)numberOfChannels
//{
//  /**
//   Append the audio data to a circular buffer
//   */
//  [EZAudio appendDataToCircularBuffer:&_circularBuffer
//									fromAudioBufferList:bufferList];
//}
#pragma mark - Cleanup

- (void)dealloc
{
  TPCircularBufferClear(&_circularBuffer);
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

- (double)levelAverage
{
	return [self.movingAverage average];
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

#pragma mark - FFT

- (void)createFFTWithBufferSize:(float)bufferSize withAudioData:(float *)data
{

  // Setup the length
  _log2n = log2f(bufferSize);

  // Calculate the weights array. This is a one-off operation.
  _FFTSetup = vDSP_create_fftsetup(_log2n, FFT_RADIX2);

  // For an FFT, numSamples must be a power of 2, i.e. is always even
  int nOver2 = bufferSize / 2;

  // Populate *window with the values for a hamming window function
  float *window = (float *)malloc(sizeof(float) * bufferSize);
  vDSP_hamm_window(window, bufferSize, 0);
  // Window the samples
  vDSP_vmul(data, 1, window, 1, data, 1, bufferSize);
  free(window);

  // Define complex buffer
  _A.realp = (float *) malloc(nOver2 * sizeof(float));
  _A.imagp = (float *) malloc(nOver2 * sizeof(float));

	_isFFTSetup = YES;
}

- (void)updateFFTWithBufferSize:(float)bufferSize withAudioData:(float *)data
{

  // For an FFT, numSamples must be a power of 2, i.e. is always even
  int nOver2 = bufferSize / 2;

  // Pack samples:
  // C(re) -> A[n], C(im) -> A[n+1]
  vDSP_ctoz((COMPLEX *)data, 2, &_A, 1, nOver2);

  // Perform a forward FFT using fftSetup and A
  // Results are returned in A
  vDSP_fft_zrip(_FFTSetup, &_A, 1, _log2n, FFT_FORWARD);

  // Convert COMPLEX_SPLIT A result to magnitudes
  float amp[nOver2];
  float maxMag = 0;

  for (int i = 0; i < nOver2; i++) {
    // Calculate the magnitude
    float mag = _A.realp[i] * _A.realp[i] + _A.imagp[i] * _A.imagp[i];
    maxMag = mag > maxMag ? mag : maxMag;
  }
  for (int i = 0; i < nOver2; i++) {
    // Calculate the magnitude
    float mag = _A.realp[i] * _A.realp[i] + _A.imagp[i] * _A.imagp[i];
    // Bind the value to be less than 1.0 to fit in the graph
    amp[i] = [EZAudio MAP:mag leftMin:0.0 leftMax:maxMag rightMin:0.0 rightMax:1.0];
  }

  // Update the frequency domain plot
	[self.delegate updateFFTWithBuffer:amp withBufferSize:nOver2];

}

@end
