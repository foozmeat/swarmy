//
//  HiveListController.h
//  Swarmy
//
//  Created by James Moore on 8/31/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

@class SWHive;
#import "SWEmptyTableView.h"

@interface SWHivePickerController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) SWEmptyTableView *tableView;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
