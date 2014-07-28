//
//  EmptyView.m
//  Swarmy
//
//  Created by James Moore on 1/22/13.
//  Copyright (c) 2013 Panic. All rights reserved.
//

#import "SWEmptyView.h"

@interface SWEmptyView ()

@end

@implementation SWEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

	if (self) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SWEmptyView" owner:self options:nil];
			self = [nib objectAtIndex:0];
			[self setup];
    }

	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];

	[self setup];
}

- (void)setup
{
	self.label.text = @"ZZZZZ";
}

@end
