// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWHiveRecord.m instead.

#import "_SWHiveRecord.h"

const struct SWHiveRecordAttributes SWHiveRecordAttributes = {
	.date = @"date",
};

const struct SWHiveRecordRelationships SWHiveRecordRelationships = {
	.hive = @"hive",
};

const struct SWHiveRecordFetchedProperties SWHiveRecordFetchedProperties = {
};

@implementation SWHiveRecordID
@end

@implementation _SWHiveRecord

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SWHiveRecord" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SWHiveRecord";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SWHiveRecord" inManagedObjectContext:moc_];
}

- (SWHiveRecordID*)objectID {
	return (SWHiveRecordID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic date;






@dynamic hive;

	






@end
