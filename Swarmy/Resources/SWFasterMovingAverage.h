//
//  SWFasterMovingAverage.h
//  Swarmy
//
//  Created by James Moore on 3/11/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWFasterMovingAverage : NSObject

- (id)initWithPeriod:(unsigned int)thePeriod;
- (void)clear;
- (void)addValue:(double)f;
- (double)average;

@end
