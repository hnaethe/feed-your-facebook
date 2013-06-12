//
//  FeedTableViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 21.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedViewController.h"


@interface FeedViewController ()
@property (nonatomic, strong) FeedTableViewController *tableViewController;
@end

@implementation FeedViewController
@synthesize tableViewController = _tableViewController;

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
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(didTouchAdd:)];
    
    self.tableViewController = [[FeedTableViewController alloc] init];
    self.tableViewController.delegate = self;
    [self.view addSubview:self.tableViewController.tableView];
    
    
    self.navigationItem.title = @"Feed-Übersicht";
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.tableViewController.tableView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didTouchAdd:(id)sender
{
    [self performSegueWithIdentifier:@"addFeedSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] compare:@"addFeedSegue"] == 0)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else if([[segue identifier] compare:@"feedItemSegue"] == 0)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    }

}

- (void)userDidSelectARow
{
    [self performSegueWithIdentifier:@"feedItemSegue" sender:self];
}
@end
