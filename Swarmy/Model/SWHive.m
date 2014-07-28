#import "SWHive.h"

@interface SWHive ()

@end

@implementation SWHive

- (BOOL)isActive
{
	return self.active.boolValue;
}

- (void)setActive:(BOOL)active
{
	
	NSNumber *activeNumber = [NSNumber numberWithBool:active];
	
  [self willChangeValueForKey:@"active"];
	
	if (active && !self.isActive) {
		// Find the the currently active Hive and deactivate it
		SWHive *activeHive = [SWHive MR_findFirstByAttribute:@"active" withValue:[NSNumber numberWithBool:YES]];
		activeHive.active = NO;
	}
	
	[self setPrimitiveValue:activeNumber forKey:@"active"];
  [self didChangeValueForKey:@"active"];
	
}

// Custom logic goes here.
- (NSString *)description
{
	return [[NSString alloc] initWithFormat:@"Name: %@", self.name];
}

@end
