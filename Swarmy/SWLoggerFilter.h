//
//  SWLoggerFilter.h
//  Swarmy
//
//  Created by James Moore on 12/30/13.
//  Copyright (c) 2013 James Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

#import <EZAudio/EZAudio.h>
@class SWFasterMovingAverage;

#define MAX_CHANNEL_COUNT 1

@interface SWLoggerFilter : NSObject <EZMicrophoneDelegate> {
	float zero, one;
	float coefficients[5];
	double samplingRate;
	double a0, a1, a2, b0, b1, b2;
	double omega, omegaS, omegaC, alpha;
	float *gInputKeepBuffer[MAX_CHANNEL_COUNT];
	float *gOutputKeepBuffer[MAX_CHANNEL_COUNT];

}

+ (SWLoggerFilter *)sharedInstance;
- (double)averageLevel;
- (void)resetAverage;

- (void)play;
- (void)pause;

@property (nonatomic) float centerFrequency;
@property (nonatomic) SWFasterMovingAverage *movingAverage;
@property (nonatomic) double dBLevel;

@end
