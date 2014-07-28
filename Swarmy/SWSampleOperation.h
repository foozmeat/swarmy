//
//  SWSampleOperation.h
//  Swarmy
//
//  Created by James Moore on 1/1/14.
//  Copyright (c) 2014 James Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWSampleOperationDelegate <NSObject>
- (void)receiveSample:(NSDictionary *)data;

@end

@interface SWSampleOperation : NSOperation

@property (nonatomic, assign) NSObject <SWSampleOperationDelegate> *delegate;

- (id)initWithCenterFrequency:(NSNumber *)frequency forSample:(NSNumber *)counter;

@end
