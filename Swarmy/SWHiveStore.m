	//
	//  HiveStore.m
	//  Swarmy
	//
	//  Created by James Moore on 8/31/12.
	//  Copyright (c) 2012 Panic. All rights reserved.
	//

#import "SWHiveStore.h"
#import "SWHive.h"
#import "SWLogEntry.h"
#import "SWHiveRecord.h"
#import "SWSampleSet.h"
#import "SWSample.h"

@interface SWHiveStore ()

@end

@implementation SWHiveStore

+ (SWHiveStore *)defaultStore
{
	static dispatch_once_t onceToken;
	static SWHiveStore *defaultStore = nil;
	dispatch_once(&onceToken, ^{
		defaultStore = [[super alloc] initUniqueInstance];
	});

	return defaultStore;
}

- (SWHiveStore *)initUniqueInstance
{
	self = [super init];

	if (self) {
	}

	return self;

}

- (NSManagedObjectContext *)context
{
	return [NSManagedObjectContext MR_contextForCurrentThread];
}

- (SWHive *)activeHive
{
	SWHive *activeHive;
	activeHive = [SWHive MR_findFirstByAttribute:@"active" withValue:[NSNumber numberWithBool:YES]];
	
	if (!activeHive) {
		activeHive = [SWHive MR_findFirstOrderedByAttribute:@"name" ascending:YES];
		activeHive.active = YES;
	}

	return activeHive;
}

- (void)migrateDataFromVersion:(int)version
{
	if (version == 0) {
		return;
	}

	if (version < 200) {
		// move the sqlite DB to app support
		DLog(@"Migrating from version %i", version);

		NSURL *docFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *appSupportFolder = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *swarmyFolder = [appSupportFolder URLByAppendingPathComponent:@"Swarmy"];

		NSArray *filenames = @[@"Swarmy.sqlite", @"Swarmy.sqlite-shm", @"Swarmy.sqlite-wal"];
		NSError *error;

		NSFileManager *fm = [NSFileManager defaultManager];

		if (![fm fileExistsAtPath:swarmyFolder.path isDirectory:NULL]) {
			[fm createDirectoryAtURL:swarmyFolder withIntermediateDirectories:YES attributes:nil error:&error];
		}

		for (NSString *file in filenames) {
			NSURL *source = [docFolder URLByAppendingPathComponent:file];
			NSURL *destination = [swarmyFolder URLByAppendingPathComponent:file];

			[fm moveItemAtURL:source toURL:destination error:&error];

			if (error) {
				DLog(@"Error moving %@: %@", file, error.localizedDescription);
			}

		}

	}

}

- (void)createDefaultDataIfNeccessary
{
	if ([SWHive MR_countOfEntities] == 0) {

		SWHive *hiveOne = [SWHive MR_createEntity];
		hiveOne.name = @"My First Hive";

		SWHive *hiveTwo = [SWHive MR_createEntity];
		hiveTwo.name = @"My Second Hive";

		SWHive *hiveThree = [SWHive MR_createEntity];
		hiveThree.name = @"My Third Hive";

		[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

	}
}

@end
