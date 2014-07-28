//
//  HiveListController.m
//  Swarmy
//
//  Created by James Moore on 8/31/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

#import "SWHivePickerController.h"
#import "SWHive.h"
#import "SWEmptyTableView.h"

@interface SWHivePickerController ()

@end

@implementation SWHivePickerController

#pragma mark - Table View

- (id)init
{
	self = [super init];

	if (self) {
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.labelText = @"No Hives Found.";

}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}

	_fetchedResultsController = [SWHive MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"name" ascending:YES delegate:self];

	return _fetchedResultsController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSUInteger sec = (NSUInteger) section;

	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:sec];

	return (NSInteger)[sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hiveTableCell"];
	[self configureCell:cell atIndexPath:indexPath];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SWHive *currentHive = [self.fetchedResultsController objectAtIndexPath:indexPath];
	currentHive.active = YES;

	[tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
		SWHive *hive = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = hive.name;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

	SWHive *currentHive = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if (currentHive.isActive) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;

	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

}

@end
