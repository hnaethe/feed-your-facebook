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

@interface FeedItemTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) Feed *feed;
@end

@implementation FeedItemTableViewController
@synthesize tableView;
@synthesize imageDownloadsInProgress;
@synthesize feed;

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
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.title = @"Feeds";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(didTouchSettings:)];
    
    self.feed = [[MediaController sharedInstance] selectedFeed];
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
    return [feed.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *feedItemCell = @"RSSFeedItemCell";
    FeedItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:feedItemCell];
    
    FeedItem *feedItem = [feed.feedItems objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[FeedItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feedItemCell];
    }
    
    [cell setFeedItem:feedItem];
    
    /*if (!feedItem.image && feed.imageURL)
    {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:feed forIndexPath:indexPath];
        }
    }
    
     */
    return cell;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(FeedItem *)feed forIndexPath:(NSIndexPath *)indexPath
{
    /*IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.feed = feed;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }*/
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
   /* if ([self.feed.feedItems count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            FeedItem *feedItem = [feed.feedItems objectAtIndex:indexPath.row];
            
            if (!feed.image && feed.imageURL) // avoid the icon download if the app already has an icon
            {
                [self startIconDownload:feed forIndexPath:indexPath];
            }
        }
    }*/
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath
{
    /*IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        FeedViewCell *cell = ((FeedViewCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView]);
        
        // Display the newly loaded image
        //[cell reloadImage:iconDownloader.feed.image];
        
        NSMutableArray *arrayForIndexPaths = [[NSMutableArray alloc] init];
        [arrayForIndexPaths addObject:indexPath];
        [tableView reloadRowsAtIndexPaths:arrayForIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];*/
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

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*[atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    [[MediaController sharedInstance] setSelectedFeed:feed];
    
    [self performSegueWithIdentifier:@"feedItemSegue" sender:self];*/
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