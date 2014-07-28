#import "SWLogEntry.h"

@interface SWLogEntry ()

@end

@implementation SWLogEntry

- (NSString *)formattedType
{
	switch ([self.logentrytype integerValue]) {
		case 0:
			return @"Direct";
		case 1:
			return @"Warble";
		case 2:
			return @"Knock";
		default:
			return @"Error";
	}
	
}

@end
