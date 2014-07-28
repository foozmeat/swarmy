//
//  HiveTableViewController.m
//  Swarmy
//
//  Created by James Moore on 8/31/12.
//  Copyright (c) 2012 Panic. All rights reserved.
//

#import "SWHiveTableViewController.h"
#import "SWHive.h"
#import "SWHiveDataListViewController.h"
#import "SWEmptyTableView.h"

@interface SWHiveTableViewController ()

@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation SWHiveTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.labelText = @"No Hives Found.\nUse the + button to add one.";
	self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewHive:)];

	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

	if (self.tableView.hasRows) {
		self.toolbarItems = @[ self.editButtonItem, space, self.addButton ];
	}
}

- (IBAction)insertNewHive:(id)sender
{

	SWHive *newHive = [SWHive MR_createEntity];
	newHive.name = @"New Hive";

	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

	[self setEditing:YES animated:YES];

}
//- (IBAction)toggleEditing:(id)sender {
//	[self.tableView setEditing:!self.tableView.isEditing animated:YES];
//}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];

	if (!editing && self.activeTextField) {
		[self.activeTextField resignFirstResponder];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];

	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:textField.tag inSection:0];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

	cell.textLabel.text = textField.text;
	self.activeTextField = nil;
	cell.textLabel.hidden = NO;
	[textField removeFromSuperview];

	NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[object setValue:cell.textLabel.text forKey:@"name"];

	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Override this here because we don't want the checkbox from the parent class
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		SWHive *hive = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[hive MR_deleteEntity];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
	return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	SWHive *hive = [self.fetchedResultsController objectAtIndexPath:indexPath];

	SWHiveDataListViewController *hdc = [segue destinationViewController];
	hdc.hive = hive;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (self.tableView.editing) {

		if (self.activeTextField) {
			[self.activeTextField resignFirstResponder];
		}

		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

		UITextField *hiveTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		CGRect editFrame = cell.contentView.frame;
		editFrame.origin.x -= 23;

		hiveTextField.frame = editFrame;

		hiveTextField.text = cell.textLabel.text;
		hiveTextField.adjustsFontSizeToFitWidth = YES;
		hiveTextField.textColor = [UIColor blackColor];
		hiveTextField.font = [UIFont boldSystemFontOfSize:17.0f];
		hiveTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		hiveTextField.delegate = self;
		hiveTextField.tag = indexPath.row;

		self.activeTextField = hiveTextField;

		cell.textLabel.hidden = YES;

		[cell.contentView addSubview:hiveTextField];

		[hiveTextField becomeFirstResponder];

	} else {
    [self performSegueWithIdentifier:@"viewDetail" sender:self];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

}

#pragma mark - Fetched results controller

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
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];

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
