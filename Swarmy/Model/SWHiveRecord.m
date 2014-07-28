#import "SWHiveRecord.h"

@interface SWHiveRecord ()

@end

@implementation SWHiveRecord

// Custom logic goes here.
- (NSString *)formattedDate
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	
	return [dateFormatter stringFromDate:self.date];
}

@end
