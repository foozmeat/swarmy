//
//  SWAudioFilter.h
//  Swarmy
//
//  Created by James Moore on 2/23/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <EZAudio/EZAudio.h>

@class EZAudio;
@class EZMicrophone;
@class SWFasterMovingAverage;

#pragma mark - SWAudioFilterDelegate
@protocol SWAudioFilterDelegate <NSObject>
@optional

- (void)updateAudioPlotsWithBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize;
- (void)updateFFTWithBuffer:(float *)buffer withBufferSize:(UInt32)bufferSize;

@required
- (void)updateSoundLevel:(float)level;

@end


#define MAX_CHANNEL_COUNT 1

@interface FTAudioFilter : NSObject <EZMicrophoneDelegate, EZOutputDataSource> {
	float zero, one;
	float coefficients[5];
	float samplingRate;

	float *gInputKeepBuffer[MAX_CHANNEL_COUNT];
	float *gOutputKeepBuffer[MAX_CHANNEL_COUNT];

	float a0, a1, a2, b0, b1, b2;
	float omega, omegaS, omegaC, alpha;

	COMPLEX_SPLIT _A;
  FFTSetup      _FFTSetup;
  BOOL          _isFFTSetup;
  vDSP_Length   _log2n;

}


- (void)calculateCoefficients;
- (void)filterContiguousData:(float *)data numFrames:(UInt32)numFrames channel:(UInt32)channel;
- (void)getdBLevel:(float *)data numFrames:(UInt32)numFrames numChannels:(UInt32)numChannels;

- (void)createFFTWithBufferSize:(float)bufferSize withAudioData:(float *)data;
- (double)levelAverage;

@property (nonatomic) SWFasterMovingAverage *movingAverage;
@property (nonatomic) float centerFrequency;
@property (nonatomic) float Q;
@property (nonatomic) float G;
@property (nonatomic) float dBLevel;
@property (nonatomic) BOOL micOn;

@property (nonatomic, strong) id<SWAudioFilterDelegate> delegate;

@end
