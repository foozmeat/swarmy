//
//  HiveDetailController.h
//  Swarmy
//
//  Created by James Moore on 9/6/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

@import UIKit;
#import "SWHive.h"

@interface SWHiveDataListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SWHive *hive;

@end
