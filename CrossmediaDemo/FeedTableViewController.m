//
//  FeedTableViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedTableViewController.h"
#import "MediaController.h"
#import "Feed.h"
#import "FeedViewCell.h"
#import "NetworkManager.h"


@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

@synthesize feeds = _feeds;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;

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
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(didTouchAdd:)];
    
    
    self.navigationItem.title = @"Feed-Übersicht";
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    
    self.feeds = [[MediaController sharedInstance] feeds];
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didParseRSSFeed:) name:@"NewRSSData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailParsingRSSFeed:) name:@"FailedToLoadRSSData" object:nil];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Aktualisiere Daten...", nil)];
    [self setRefreshControl:refreshControl];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *feedCell = @"RSSFeedCell";
    FeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedCell];
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[FeedViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedCell];
    }
    
    [cell setFeed:feed];
    
    if (!feed.image && feed.imageURL)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:feed forIndexPath:indexPath];
        }
    }
    
    if(feed.hasNotBeenParsed && !feed.isParsing && !feed.cannotBeParsed)
    {
        [[MediaController sharedInstance] performSelectorInBackground:@selector(startParsingChannel:) withObject:feed];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Feed *)feed forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imageObject = feed;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.feeds count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Feed *feed = [self.feeds objectAtIndex:indexPath.row];
            
            if (!feed.image && feed.imageURL) // avoid the icon download if the app already has an icon
            {
                [self startIconDownload:feed forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        //FeedViewCell *cell = ((FeedViewCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView]);
        
        // Display the newly loaded image
        //[cell reloadImage:iconDownloader.feed.image];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [self.imageDownloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - Notification stuff
- (void)didParseRSSFeed:(NSNotification*)notification
{
    Feed *feed = [notification.userInfo objectForKey:@"feed"];
    /*int row = [self.feeds indexOfObject:feed];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.refreshControl endRefreshing];*/
    [self.refreshControl endRefreshing];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}

- (void)didFailParsingRSSFeed:(NSNotification *)notification
{
    if([[NetworkManager sharedInstance] hasInternetConnection])
    {
        Feed *feed = [notification.userInfo objectForKey:@"feed"];
        [self.tableView reloadData];
    
        int index = [self.feeds indexOfObject:feed];
        [self.feeds removeObject:feed];
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [[NetworkManager sharedInstance] showInternetError];
    }
}

#pragma mark - Segue Stuff

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    [[MediaController sharedInstance] setSelectedFeed:feed];
    
    [self userDidSelectARow];
}

#pragma mark - Refresh Handler

- (void)refresh
{
    [self refreshView: self.refreshControl];
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    [[MediaController sharedInstance] performSelectorInBackground:@selector(refreshAllChannels) withObject:nil];
}

#pragma mark - Deletion Handler

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self.feeds removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
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
