//
//  BrewersPositionTableViewController.m
//  Brewers
//
//  Created by Ryan Hardt on 3/17/14.
//  Copyright (c) 2014 Ryan Hardt. All rights reserved.
//

#import "BrewersPositionTableViewController.h"
#import "BrewersPlayersTableViewController.h"
#import "BrewersPlayer.h"
#import "AppDelegate.h"

@interface BrewersPositionTableViewController ()

@end

@implementation BrewersPositionTableViewController

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
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.toolbarItems = @[settingsButton];
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSettings"]){
        NSLog(@"Here we go");
    }else{
        BrewersPlayersTableViewController* dest = [segue destinationViewController];
        Position position = (Position)[self.tableView indexPathForSelectedRow].row+1;
        dest.players = [self playersForPosition:position];
        dest.position = position;
        dest.navigationItem.title = [BrewersPlayer nameForPosition:position];
    }
}

-(NSMutableArray*)playersForPosition:(Position)position
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* moc = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"BrewersPlayer" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortByName = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"position = %i", position];
    [fetchRequest setPredicate:predicate];
    
    NSError* error = nil;
    NSMutableArray* fetchResults = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
    
    if(!fetchResults) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    } else if([fetchResults count]==0) {
        //if no players, obtain players from web service
        fetchResults = [self getPlayersFromWebServiceForPosition:position withMoc:moc];
    }
    
    return fetchResults;
}

-(NSMutableArray*)getPlayersFromWebServiceForPosition:(Position)position withMoc:(NSManagedObjectContext*)moc{
    
    NSMutableArray* players = [[NSMutableArray alloc]init];
    
    //construct string for url
    NSString* api = @"http://api.cbssports.com/fantasy/players/search?SPORT=baseball&version=3.0&response_format=json&pro_team=MIL";
    
    NSString* positionParameter = [NSString stringWithFormat:@"&position=%@", [BrewersPlayer identifierForPosition:position]];
    
    NSString* formattedString = [api stringByAppendingString:(positionParameter)];
    
    NSURL* apiWithParameters = [NSURL URLWithString:formattedString];
    NSLog(@"%@",formattedString);
    NSData* data = [NSData dataWithContentsOfURL:apiWithParameters];
    
    //get data
    NSError* error = nil;
    NSDictionary* jsonResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSDictionary* bodyOfResults = [jsonResults objectForKey:@"body"];
    NSMutableArray* playerResults = [bodyOfResults objectForKey:@"players"];
    
    //construct players
    BrewersPlayer* player;
    for (NSDictionary* cplayer in playerResults){
        player = [NSEntityDescription insertNewObjectForEntityForName:@"BrewersPlayer" inManagedObjectContext:moc];
        player.firstName = [cplayer valueForKey:@"firstname"];
        player.lastName = [cplayer valueForKey:@"lastname"];
        player.position = [NSNumber numberWithInt:position];
        player.infoUrl = [@"http://www.cbssports.com/mlb/players/playerpage/" stringByAppendingString:[cplayer valueForKey:@"id"]];
        NSURL* hs = [[NSURL alloc] initWithString:[cplayer valueForKey:@"photo_url"]];
        player.headshot = [NSData dataWithContentsOfURL:hs];
        [players addObject:player];
    };
    
    return players;
}

@end
