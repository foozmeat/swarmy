// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWSampleSet.h instead.

#import <CoreData/CoreData.h>
#import "SWHiveRecord.h"

extern const struct SWSampleSetAttributes {
} SWSampleSetAttributes;

extern const struct SWSampleSetRelationships {
	__unsafe_unretained NSString *samples;
} SWSampleSetRelationships;

extern const struct SWSampleSetFetchedProperties {
} SWSampleSetFetchedProperties;

@class SWSample;


@interface SWSampleSetID : NSManagedObjectID {}
@end

@interface _SWSampleSet : SWHiveRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SWSampleSetID*)objectID;





@property (nonatomic, strong) NSSet *samples;

- (NSMutableSet*)samplesSet;





@end

@interface _SWSampleSet (CoreDataGeneratedAccessors)

- (void)addSamples:(NSSet*)value_;
- (void)removeSamples:(NSSet*)value_;
- (void)addSamplesObject:(SWSample*)value_;
- (void)removeSamplesObject:(SWSample*)value_;

@end

@interface _SWSampleSet (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitiveSamples;
- (void)setPrimitiveSamples:(NSMutableSet*)value;


@end
