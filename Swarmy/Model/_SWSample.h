// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWSample.h instead.

#import <CoreData/CoreData.h>


extern const struct SWSampleAttributes {
	__unsafe_unretained NSString *frequency;
	__unsafe_unretained NSString *level;
} SWSampleAttributes;

extern const struct SWSampleRelationships {
	__unsafe_unretained NSString *set;
} SWSampleRelationships;

extern const struct SWSampleFetchedProperties {
} SWSampleFetchedProperties;

@class SWSampleSet;




@interface SWSampleID : NSManagedObjectID {}
@end

@interface _SWSample : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SWSampleID*)objectID;





@property (nonatomic, strong) NSNumber* frequency;



@property float frequencyValue;
- (float)frequencyValue;
- (void)setFrequencyValue:(float)value_;

//- (BOOL)validateFrequency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* level;



@property float levelValue;
- (float)levelValue;
- (void)setLevelValue:(float)value_;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SWSampleSet *set;

//- (BOOL)validateSet:(id*)value_ error:(NSError**)error_;





@end

@interface _SWSample (CoreDataGeneratedAccessors)

@end

@interface _SWSample (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveFrequency;
- (void)setPrimitiveFrequency:(NSNumber*)value;

- (float)primitiveFrequencyValue;
- (void)setPrimitiveFrequencyValue:(float)value_;




- (NSNumber*)primitiveLevel;
- (void)setPrimitiveLevel:(NSNumber*)value;

- (float)primitiveLevelValue;
- (void)setPrimitiveLevelValue:(float)value_;





- (SWSampleSet*)primitiveSet;
- (void)setPrimitiveSet:(SWSampleSet*)value;


@end
