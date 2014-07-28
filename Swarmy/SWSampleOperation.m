//
//  SWSampleOperation.m
//  Swarmy
//
//  Created by James Moore on 1/1/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "SWSampleOperation.h"
#import "SWLoggerFilter.h"

@interface SWSampleOperation ()

@property NSNumber *frequency;
@property NSNumber *counter;

@end

@implementation SWSampleOperation

const float samplePeriod = 5.0f;

- (id)initWithCenterFrequency:(NSNumber *)frequency forSample:(NSNumber *)counter
{
	if ((self = [super init]) != nil) {
		self.frequency = frequency;
		self.counter = counter;

		return self;
	} else {

		return nil;
	}
}

- (void)main
{
	DLog(@"Sampling at %@", self.frequency);

	SWLoggerFilter *loggerFilter = [SWLoggerFilter sharedInstance];
	loggerFilter.centerFrequency = self.frequency.floatValue;
	[loggerFilter resetAverage];
	[loggerFilter play];

	[NSThread sleepForTimeInterval:samplePeriod];
	
	NSDictionary *results = @{@"label": [NSString stringWithFormat:@"s%@", self.counter],
													 @"level": [NSNumber numberWithDouble:[loggerFilter averageLevel]],
													 @"frequency": self.frequency
														};

	[loggerFilter pause];
	[self.delegate performSelectorOnMainThread:@selector(receiveSample:) withObject:results waitUntilDone:NO];

}

@end
