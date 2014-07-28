// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWSampleSet.m instead.

#import "_SWSampleSet.h"

const struct SWSampleSetAttributes SWSampleSetAttributes = {
};

const struct SWSampleSetRelationships SWSampleSetRelationships = {
	.samples = @"samples",
};

const struct SWSampleSetFetchedProperties SWSampleSetFetchedProperties = {
};

@implementation SWSampleSetID
@end

@implementation _SWSampleSet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SWSampleSet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SWSampleSet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SWSampleSet" inManagedObjectContext:moc_];
}

- (SWSampleSetID*)objectID {
	return (SWSampleSetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic samples;

	
- (NSMutableSet*)samplesSet {
	[self willAccessValueForKey:@"samples"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"samples"];
  
	[self didAccessValueForKey:@"samples"];
	return result;
}
	






@end
