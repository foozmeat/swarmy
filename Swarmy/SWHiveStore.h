//
//  HiveStore.h
//  Swarmy
//
//  Created by James Moore on 8/31/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

@class SWHive;

@interface SWHiveStore : NSObject

+ (SWHiveStore *)defaultStore;
- (void)createDefaultDataIfNeccessary;

- (void)migrateDataFromVersion:(int)version;

- (SWHive *)activeHive;
- (NSManagedObjectContext *)context;

@end
