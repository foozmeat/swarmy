//
//  SWFasterMovingAverage.m
//  Swarmy
//
//  Created by James Moore on 3/11/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import "SWFasterMovingAverage.h"

@interface SWFasterMovingAverage()
{
	NSUInteger size;
	NSUInteger count;
	NSUInteger index;
	double sum;
	double *array;
}

@end

@implementation SWFasterMovingAverage

- (id)initWithPeriod:(unsigned int)thePeriod
{
	self = [super init];

	if (self) {
		size = thePeriod;
		array = (double *) malloc(size * sizeof(double));
	}

	return self;
}

- (void)clear
{
	count = 0;
	index = 0;
	sum = 0.0;
	for (NSUInteger i = 0; i < size; i++) {
		array[i] = 0.0;
	}
}

- (void)addValue:(double)f
{
	sum -= array[index];
	array[index] = f;
	sum += array[index];
	index++;

	if (index == size) {
		index = 0;
	}

	if (count < size) {
		count++;
	}

}

- (double)average
{
	if (count == 0) {
		return 0.0f;
	}

	return sum / count;
}

- (void)dealloc
{
	free(array);
}

@end
