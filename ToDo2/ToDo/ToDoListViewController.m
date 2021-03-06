//
//  ToDoViewController.m
//  ToDo
//
//  Created by Ryan Hardt on 3/7/14.
//  Copyright (c) 2014 Ryan Hardt. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoListItem.h"
#import "ToDoListItemDetailViewController.h"
#import "ToDoListItemTableViewCell.h"
#import "ToDoListSettingsTableViewController.h"
#import "AppDelegate.h"

@interface ToDoListViewController ()
@property(nonatomic, strong) AppDelegate* appDelegate;
@property(nonatomic, strong) NSManagedObjectContext* moc;
@end

@implementation ToDoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.deleteOnComplete = [NSMutableString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:DeleteOnCompleteKey]];
    
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.toolbarItems = @[settingsButton];
    self.navigationController.toolbarHidden = NO;
    
    self.appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = [self.appDelegate managedObjectContext];
    self.toDoList = [self.appDelegate getToDoList];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([self.deleteOnComplete isEqualToString:@"YES"]) {
        ToDoListItem* item;
        for(int i=0; i<[self.toDoList count]; ++i) {
            item = [self.toDoList objectAtIndex:i];
            if(item.isCompleted) {
                [self.toDoList removeObject:(item)];
                [self.moc deleteObject:(item)];
                --i;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addToDoListItem
{
    ToDoListItem* itemToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoListItem" inManagedObjectContext:self.moc];
    itemToAdd.title = @"New ToDo Item";
    [self.toDoList addObject:itemToAdd];
    // Create an index path for the new item
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // Update the tableview with cool animations
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"ShowSettingsSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.toDoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListItemCell";
    ToDoListItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ToDoListItem* item = [self.toDoList objectAtIndex:indexPath.row];
    cell.item = item;
    cell.titleTextField.text = item.title;
    if(item.isCompleted) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //always check to see which segue it is
    if([segue.identifier isEqualToString:@"ShowDetailView"]) {
        ToDoListItemDetailViewController* dest = [segue destinationViewController];
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        ToDoListItem* item;
        item = [self.toDoList objectAtIndex:indexPath.row];
        dest.item = item;
    } else if([segue.identifier isEqualToString:@"ShowSettingsSegue"]) {
        ToDoListSettingsTableViewController* dest = [segue destinationViewController];
        dest.deleteOnComplete = self.deleteOnComplete;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"");
        ToDoListItem* toBeDeletedItem = [self.toDoList objectAtIndex:indexPath.row];
        NSLog(@"");
        [self.toDoList removeObject:toBeDeletedItem];
        NSLog(@"");
        [self.moc deleteObject:toBeDeletedItem];
        NSLog(@"");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
