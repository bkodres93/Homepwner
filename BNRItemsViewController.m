//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 6/11/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@interface BNRItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (UIView *)headerView
{
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}


// TABLE VIEW METHODS

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                        forIndexPath:indexPath];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    if (indexPath.row == items.count) {
        cell.textLabel.text = @"No more items!";
    }
    else {
        BNRItem *item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        if (items.count != indexPath.row) {
            BNRItem *item = items[indexPath.row];
            [[BNRItemStore sharedStore] removeItem:item];
        
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return sourceIndexPath;
    }
    else if (proposedDestinationIndexPath.row == [[[BNRItemStore sharedStore] allItems] count]){
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [[[BNRItemStore sharedStore] allItems] count]) {
        BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
        
        // Get the items and give the detail view-controller the selected item
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        
        detailViewController.item = items[indexPath.row];
        
        // Push it onto the top of the navigation controller's stack
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    
}


- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}



// OVERRIDDEN VIEW METHODS

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    
    UIView *header = self.headerView;
    
    [self.tableView setTableHeaderView:header];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    
    
}

- (IBAction)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        
        // Change text of button to reflect the state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    }
    else {
        
        // Again, change the button
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        // Do the opposite
        [self setEditing:YES animated:YES];
    }
}

@end
