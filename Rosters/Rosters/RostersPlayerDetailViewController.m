//
//  RostersPlayerDetailViewController.m
//  Rosters
//
//  Created by Jake on 3/31/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

#import "RostersPlayerDetailViewController.h"
#import "RostersAddEditPlayerViewController.h"
#import "RostersPlayerWebViewViewController.h"

@interface RostersPlayerDetailViewController ()

@end

@implementation RostersPlayerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.firstNameLabel.text = self.player.firstName;
    self.lastNameLabel.text = self.player.lastName;
    self.positionLabel.text = self.player.position;

    if(self.player.headURL != nil && ![self.player.headURL isEqualToString:(@"")] && ![self.player.headURL isEqualToString:(@"http://sports.cbsimg.net/images/players/unknown_hat.gif")]){
        NSURL* url = [NSURL URLWithString:(self.player.headURL)];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:(url)];
        [self.headShotView loadRequest:(request)];
    }else{
        NSURL* url = [NSURL URLWithString:(@"http://sports.cbsimg.net/images/players/unknown_hat.gif")];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:(url)];
        [self.headShotView loadRequest:(request)];
    }
    if(self.player.url == nil || [self.player.url isEqualToString:@""]){
        self.moreInfoButton.enabled = NO;
    }else{
        self.moreInfoButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:(@"toPlayerEdit")]){
        RostersAddEditPlayerViewController* dest = [segue destinationViewController];
        dest.player = self.player;
    }else if([[segue identifier] isEqualToString:(@"toPlayerWeb")]){
        RostersPlayerWebViewViewController* dest = [segue destinationViewController];
        dest.playerUrl = self.player.url;
    }
}


@end
