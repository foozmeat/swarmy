//
//  AFMeter.m
//  Novocaine
//
//  Created by James Moore on 7/4/12.
//

#import "SWAFMeter.h"

@implementation SWAFMeter

@synthesize pauseCount, maxNumBars, barHeight, maxBarNumber, updateCount;
@synthesize volume = _volume;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		[self awakeFromNib];

	}

	return self;
}

- (void)awakeFromNib
{
	self.pauseCount = pauseLength;
	self.maxBarNumber = 0;
	self.updateCount = updateInterval;
	self.backgroundColor = [UIColor clearColor];

}

- (float)volume
{
	return _volume;
}

- (void)setVolume:(float)volume
{
	if (volume != _volume) {
		_volume = volume;
		[self setNeedsDisplay];
	}
}
//- (void)drawBarAtPosition:(int)position
//{
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGContextRef context = UIGraphicsGetCurrentContext();
//
//	float xPos = ((float)position * (barWidth + barSpacing)) + padding;
//	
//	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(xPos, padding, barWidth, barHeight / 2) cornerRadius: 3];
//	
//	CGContextSaveGState(context);
//	[roundedRectanglePath addClip];
//	
//	CGContextRestoreGState(context);
//	[[UIColor blackColor] setStroke];
//	[[UIColor clearColor] setFill];
//	
//	roundedRectanglePath.lineWidth = 1;
//	[roundedRectanglePath stroke];
//
//	CGColorSpaceRelease(colorSpace);
//}

- (void)drawLineAtPosition:(int)position
{
	UIColor *color = [UIColor blackColor];

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	float xPos = ((float)position * (barWidth + barSpacing)) + padding;
	
	UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(xPos, padding, 2.0, barHeight)];
	
	CGContextSaveGState(context);
	[roundedRectanglePath addClip];
	
	CGContextRestoreGState(context);
	[color setFill];
	
	[roundedRectanglePath fill];
	
	CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect
{

	self.maxNumBars = (rect.size.width - (padding * 2)) / (barSpacing + barWidth);
	self.barHeight = rect.size.height - (padding * 2);

	if (_volume == 0.0) {
		return;
	}
	
	int numBarsToDraw = (int)(_volume * (float)maxNumBars);
		
	[self drawLineAtPosition:numBarsToDraw];

//	if (numBarsToDraw > maxBarNumber) {
//		maxBarNumber = numBarsToDraw;
//		pauseCount = pauseLength;
//	} else {
//		pauseCount--;
//	}
//
//	if (pauseCount < 0) {
//		
//			maxBarNumber = maxBarNumber - 3;
//		
//	}
//
//	if (maxBarNumber > 0) {
//		[self drawLineAtPosition:maxBarNumber];
//	}

	

}

@end
