// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWLogEntry.h instead.

#import <CoreData/CoreData.h>
#import "SWHiveRecord.h"

extern const struct SWLogEntryAttributes {
	__unsafe_unretained NSString *level;
	__unsafe_unretained NSString *logentrytype;
	__unsafe_unretained NSString *note;
} SWLogEntryAttributes;

extern const struct SWLogEntryRelationships {
} SWLogEntryRelationships;

extern const struct SWLogEntryFetchedProperties {
} SWLogEntryFetchedProperties;






@interface SWLogEntryID : NSManagedObjectID {}
@end

@interface _SWLogEntry : SWHiveRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SWLogEntryID*)objectID;





@property (nonatomic, strong) NSNumber* level;



@property int16_t levelValue;
- (int16_t)levelValue;
- (void)setLevelValue:(int16_t)value_;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* logentrytype;



@property int16_t logentrytypeValue;
- (int16_t)logentrytypeValue;
- (void)setLogentrytypeValue:(int16_t)value_;

//- (BOOL)validateLogentrytype:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* note;



//- (BOOL)validateNote:(id*)value_ error:(NSError**)error_;






@end

@interface _SWLogEntry (CoreDataGeneratedAccessors)

@end

@interface _SWLogEntry (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveLevel;
- (void)setPrimitiveLevel:(NSNumber*)value;

- (int16_t)primitiveLevelValue;
- (void)setPrimitiveLevelValue:(int16_t)value_;




- (NSNumber*)primitiveLogentrytype;
- (void)setPrimitiveLogentrytype:(NSNumber*)value;

- (int16_t)primitiveLogentrytypeValue;
- (void)setPrimitiveLogentrytypeValue:(int16_t)value_;




- (NSString*)primitiveNote;
- (void)setPrimitiveNote:(NSString*)value;




@end
