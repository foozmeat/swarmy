// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWHive.m instead.

#import "_SWHive.h"

const struct SWHiveAttributes SWHiveAttributes = {
	.active = @"active",
	.name = @"name",
};

const struct SWHiveRelationships SWHiveRelationships = {
	.records = @"records",
};

const struct SWHiveFetchedProperties SWHiveFetchedProperties = {
};

@implementation SWHiveID
@end

@implementation _SWHive

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SWHive" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SWHive";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SWHive" inManagedObjectContext:moc_];
}

- (SWHiveID*)objectID {
	return (SWHiveID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"activeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"active"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic active;



- (BOOL)activeValue {
	NSNumber *result = [self active];
	return [result boolValue];
}

- (void)setActiveValue:(BOOL)value_ {
	[self setActive:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveActiveValue {
	NSNumber *result = [self primitiveActive];
	return [result boolValue];
}

- (void)setPrimitiveActiveValue:(BOOL)value_ {
	[self setPrimitiveActive:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic records;

	
- (NSMutableSet*)recordsSet {
	[self willAccessValueForKey:@"records"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"records"];
  
	[self didAccessValueForKey:@"records"];
	return result;
}
	






@end
