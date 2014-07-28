// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SWHiveRecord.h instead.

#import <CoreData/CoreData.h>


extern const struct SWHiveRecordAttributes {
	__unsafe_unretained NSString *date;
} SWHiveRecordAttributes;

extern const struct SWHiveRecordRelationships {
	__unsafe_unretained NSString *hive;
} SWHiveRecordRelationships;

extern const struct SWHiveRecordFetchedProperties {
} SWHiveRecordFetchedProperties;

@class SWHive;



@interface SWHiveRecordID : NSManagedObjectID {}
@end

@interface _SWHiveRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SWHiveRecordID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SWHive *hive;

//- (BOOL)validateHive:(id*)value_ error:(NSError**)error_;





@end

@interface _SWHiveRecord (CoreDataGeneratedAccessors)

@end

@interface _SWHiveRecord (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;





- (SWHive*)primitiveHive;
- (void)setPrimitiveHive:(SWHive*)value;


@end
