//
//  HiveDetailController.m
//  Swarmy
//
//  Created by James Moore on 9/6/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

#import "SWHiveDataListViewController.h"
#import "SWHive.h"
#import "SWLogEntry.h"
#import "SWHiveRecord.h"
#import "SWEmptyTableView.h"
#import "SWSampleSet.h"

#import "RJTableViewCell.h"
#import "SWHiveStore.h"

@interface SWHiveDataListViewController ()

@property (strong, nonatomic) SWEmptyTableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

static NSString *CellIdentifier = @"detailTableCell";

@implementation SWHiveDataListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.labelText = @"No Entries Found.";
	
	if (self.tableView.hasRows) {
		self.toolbarItems = @[ self.editButtonItem ];
	}
	
	[self.tableView registerClass:[RJTableViewCell class] forCellReuseIdentifier:CellIdentifier];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.title = [self.hive name];

}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger sec = (NSUInteger) section;
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:sec];

	return (NSInteger) [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	[self configureCell:cell atIndexPath:indexPath];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWHiveRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];

	if ([record isKindOfClass:SWSampleSet.class]) {
		return 44.0f;
	}
	
	RJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailTableCell"];

	// Configure the cell for this indexPath
//	SWLogEntry *logEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];

	// Set the width of the cell to match the width of the table view. This is important so that we'll get the
	// correct height for different table view widths, since our cell's height depends on its width due to
	// the multi-line UILabel word wrapping. Don't need to do this above in -[tableView:cellForRowAtIndexPath]
	// because it happens automatically when the cell is used in the table view.
	cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));

	// Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
	// (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
	// in the UITableViewCell subclass
	[cell setNeedsLayout];
	[cell layoutIfNeeded];

	// Get the actual height required for the cell
	CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

	// Add an extra point to the height to account for internal rounding errors that are occasionally observed in
	// the Auto Layout engine, which cause the returned height to be slightly too small in some cases.
	height += 1;

	return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		SWLogEntry *logEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[logEntry MR_deleteEntity];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
	return NO;
}

- (void)configureCell:(RJTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	SWHiveRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.titleLabel.text = [record formattedDate];

	if ([record isKindOfClass:SWSampleSet.class]) {
		cell.bodyLabel.text = @"Sound Level Samples";
	} else if ([record isKindOfClass:SWLogEntry.class]) {
		cell.bodyLabel.text = [(SWLogEntry *) record note];
	} else {
		cell.bodyLabel.text = @"Unknown Record Type!";
	}

	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];


}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hive == %@", self.hive];

	_fetchedResultsController   = [SWHiveRecord MR_fetchAllSortedBy:@"date"
																											ascending:NO
																									withPredicate:predicate
																												groupBy:nil
																											 delegate:self
																											inContext:[NSManagedObjectContext MR_contextForCurrentThread]];


//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hive == %@", self.hive];
//	fetchRequest.predicate = predicate;
//	
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWHiveRecord" inManagedObjectContext:[[SWHiveStore defaultStore] context]];
//	[fetchRequest setEntity:entity];
//	
//	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
//	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//	
////	[fetchRequest setFetchBatchSize:20];
//	[fetchRequest setFetchLimit:100];
//		
//  NSString *cacheName = [NSString stringWithFormat:@"HiveData-%@", self.hive.name];
//	
//	_fetchedResultsController =
//	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//																			managedObjectContext:[[SWHiveStore defaultStore] context]
//																				sectionNameKeyPath:nil
//																								 cacheName:nil];
//	_fetchedResultsController.delegate = self;
//	
//	NSError *error = nil;
//	
//	if (![_fetchedResultsController performFetch:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Error fetching log entries %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}
//	
//	self.navigationController.title = [NSString stringWithFormat:@"%@ (%@)",self.navigationController.title, @5];
	
	return _fetchedResultsController;

}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];

			break;

		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];

			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
	UITableView *tableView = self.tableView;

	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

			break;

		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

			break;

		case NSFetchedResultsChangeUpdate:
			[self configureCell:(RJTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];

			break;

		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];

			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

@end
