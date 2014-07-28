//
//  main.m
//  averageTimer
//
//  Created by James Moore on 3/11/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMovingAverage.h"
#import "SWFasterMovingAverage.h"

int main(int argc, const char * argv[])
{

	static const int period = 1000000;
	@autoreleasepool {

		NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
		SWMovingAverage *ma = [[SWMovingAverage alloc] initWithPeriod:period];
		for (int i = 1; i <= period; i++) {

			[ma add:(((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * 80) - 50];
		}
		NSLog(@"Average is %f", [ma avg]);
    NSTimeInterval duration = [NSDate timeIntervalSinceReferenceDate] - start;
		NSLog(@"Finished in %f seconds", duration);

		// -------------------
		start = [NSDate timeIntervalSinceReferenceDate];

		SWFasterMovingAverage *fma1 = [[SWFasterMovingAverage alloc] initWithPeriod:period];
		for (int i = 1; i <= period; i++) {
			[fma1 addValue:(((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * 80) - 50];
		}
		NSLog(@"Average is %f", [fma1 average]);
		duration = [NSDate timeIntervalSinceReferenceDate] - start;
		NSLog(@"Finished in %f seconds", duration);

	}
    return 0;
}