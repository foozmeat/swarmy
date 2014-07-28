//
//  EmptyTableView.m
//  Swarmy
//
//  Created by James Moore on 1/22/13.
//  Copyright (c) 2013 Panic. All rights reserved.
//

#import "SWEmptyTableView.h"
#import "SWEmptyView.h"

@interface SWEmptyTableView ()
@property (strong, nonatomic)  SWEmptyView *emptyView;

@end

@implementation SWEmptyTableView

- (id)init
{
	self = [super init];

	if (self) {
		if (self.emptyView == nil) {
			self.emptyView = [SWEmptyView new];
		}

	}

	return self;
}

- (bool)hasRows
{
	return [self numberOfRowsInSection:0] != 0;
}

- (void)showEmptyViewIfNeeded
{

	BOOL emptyViewShown = self.emptyView.superview != nil;

	if (!self.hasRows && emptyViewShown) return;

	if (self.emptyView == nil) {
		self.emptyView = [SWEmptyView new];
	}

	if (!self.hasRows) {
		[self addSubview:self.emptyView];

	} else {
		[self.emptyView removeFromSuperview];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.emptyView.label.text = _labelText;
	[self showEmptyViewIfNeeded];
}

@end
