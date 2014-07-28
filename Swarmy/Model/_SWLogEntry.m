// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWLogEntry.m instead.

#import "_SWLogEntry.h"

const struct SWLogEntryAttributes SWLogEntryAttributes = {
	.level = @"level",
	.logentrytype = @"logentrytype",
	.note = @"note",
};

const struct SWLogEntryRelationships SWLogEntryRelationships = {
};

const struct SWLogEntryFetchedProperties SWLogEntryFetchedProperties = {
};

@implementation SWLogEntryID
@end

@implementation _SWLogEntry

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SWLogEntry" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SWLogEntry";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SWLogEntry" inManagedObjectContext:moc_];
}

- (SWLogEntryID*)objectID {
	return (SWLogEntryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"levelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"level"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"logentrytypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"logentrytype"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic level;



- (int16_t)levelValue {
	NSNumber *result = [self level];
	return [result shortValue];
}

- (void)setLevelValue:(int16_t)value_ {
	[self setLevel:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLevelValue {
	NSNumber *result = [self primitiveLevel];
	return [result shortValue];
}

- (void)setPrimitiveLevelValue:(int16_t)value_ {
	[self setPrimitiveLevel:[NSNumber numberWithShort:value_]];
}





@dynamic logentrytype;



- (int16_t)logentrytypeValue {
	NSNumber *result = [self logentrytype];
	return [result shortValue];
}

- (void)setLogentrytypeValue:(int16_t)value_ {
	[self setLogentrytype:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLogentrytypeValue {
	NSNumber *result = [self primitiveLogentrytype];
	return [result shortValue];
}

- (void)setPrimitiveLogentrytypeValue:(int16_t)value_ {
	[self setPrimitiveLogentrytype:[NSNumber numberWithShort:value_]];
}





@dynamic note;











@end
