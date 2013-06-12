//
//  FeedItemTableViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 22.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItemTableViewController.h"
#import "Feed.h"
#import "FeedItem.h"
#import "FeedItemViewCell.h"
#import "MediaController.h"
#import "FacebookHandler.h"

@interface FeedItemTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) Feed *feed;
@end

@implementation FeedItemTableViewController
@synthesize tableView = _tableView;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize feed = _feed;

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.title = @"Feeds";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(didTouchSettings:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReloadFeeds:) name:@"NewFeedItemData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchFeedItem:) name:@"NewFeedItem" object:nil];
    
    self.feed = [[MediaController sharedInstance] selectedFeed];
    [[MediaController sharedInstance] performSelectorInBackground:@selector(startParsingFeedItems:) withObject:self.feed];
}

- (void)didReloadFeeds:(NSNotification *)notification
{

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didFetchFeedItem:(NSNotification *)notification
{
    /*FeedItem *item = (FeedItem*)[notification.userInfo objectForKey:@"feedItem"];
    int index = [self.feed.feedItems indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if([self.feed.feedItems count] == (index + 1))
    {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }*/
    
    
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
    return [self.feed.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *feedItemCell = @"RSSFeedItemCell";
    FeedItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedItemCell];
    
    FeedItem *feedItem = [self.feed.feedItems objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[FeedItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedItemCell];
    }
    
    [cell setFeedItem:feedItem];
    
    if (!feedItem.image && feedItem.imageURL)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:feedItem forIndexPath:indexPath];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(FeedItem *)feedItem forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imageObject = feedItem;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
   if ([self.feed.feedItems count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            FeedItem *feedItem = [self.feed.feedItems objectAtIndex:indexPath.row];
            
            if (!feedItem.image && feedItem.imageURL) // avoid the icon download if the app already has an icon
            {
                [self startIconDownload:feedItem forIndexPath:indexPath];
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
        FeedItemViewCell *cell = ((FeedItemViewCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView]);
        
        // Display the newly loaded image
        //[cell reloadImage:iconDownloader.feed.image];
        
        NSMutableArray *arrayForIndexPaths = [[NSMutableArray alloc] init];
        [arrayForIndexPaths addObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:arrayForIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - Segue Stuff

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedItem *feedItem = [self.feed.feedItems objectAtIndex:indexPath.row];
    [[FacebookHandler sharedInstance] publishStoryWithFeedItem:feedItem];
}

- (void)didTouchSettings:(id)sender
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] compare:@"settingsSegue"] == 0)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

@end
