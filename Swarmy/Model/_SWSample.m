// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWSample.m instead.

#import "_SWSample.h"

const struct SWSampleAttributes SWSampleAttributes = {
	.frequency = @"frequency",
	.level = @"level",
};

const struct SWSampleRelationships SWSampleRelationships = {
	.set = @"set",
};

const struct SWSampleFetchedProperties SWSampleFetchedProperties = {
};

@implementation SWSampleID
@end

@implementation _SWSample

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SWSample" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SWSample";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SWSample" inManagedObjectContext:moc_];
}

- (SWSampleID*)objectID {
	return (SWSampleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"frequencyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"frequency"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"levelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"level"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic frequency;



- (float)frequencyValue {
	NSNumber *result = [self frequency];
	return [result floatValue];
}

- (void)setFrequencyValue:(float)value_ {
	[self setFrequency:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveFrequencyValue {
	NSNumber *result = [self primitiveFrequency];
	return [result floatValue];
}

- (void)setPrimitiveFrequencyValue:(float)value_ {
	[self setPrimitiveFrequency:[NSNumber numberWithFloat:value_]];
}





@dynamic level;



- (float)levelValue {
	NSNumber *result = [self level];
	return [result floatValue];
}

- (void)setLevelValue:(float)value_ {
	[self setLevel:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLevelValue {
	NSNumber *result = [self primitiveLevel];
	return [result floatValue];
}

- (void)setPrimitiveLevelValue:(float)value_ {
	[self setPrimitiveLevel:[NSNumber numberWithFloat:value_]];
}





@dynamic set;

	






@end
