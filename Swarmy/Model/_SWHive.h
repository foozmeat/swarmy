// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWHive.h instead.

#import <CoreData/CoreData.h>


extern const struct SWHiveAttributes {
	__unsafe_unretained NSString *active;
	__unsafe_unretained NSString *name;
} SWHiveAttributes;

extern const struct SWHiveRelationships {
	__unsafe_unretained NSString *records;
} SWHiveRelationships;

extern const struct SWHiveFetchedProperties {
} SWHiveFetchedProperties;

@class SWHiveRecord;




@interface SWHiveID : NSManagedObjectID {}
@end

@interface _SWHive : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SWHiveID*)objectID;





@property (nonatomic, strong) NSNumber* active;



@property BOOL activeValue;
- (BOOL)activeValue;
- (void)setActiveValue:(BOOL)value_;

//- (BOOL)validateActive:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *records;

- (NSMutableSet*)recordsSet;





@end

@interface _SWHive (CoreDataGeneratedAccessors)

- (void)addRecords:(NSSet*)value_;
- (void)removeRecords:(NSSet*)value_;
- (void)addRecordsObject:(SWHiveRecord*)value_;
- (void)removeRecordsObject:(SWHiveRecord*)value_;

@end

@interface _SWHive (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveActive;
- (void)setPrimitiveActive:(NSNumber*)value;

- (BOOL)primitiveActiveValue;
- (void)setPrimitiveActiveValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveRecords;
- (void)setPrimitiveRecords:(NSMutableSet*)value;


@end
