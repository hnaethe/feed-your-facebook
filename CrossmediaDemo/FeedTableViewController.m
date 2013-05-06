//
//  FeedTableViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 21.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedViewCell.h"

#import "MediaController.h"
#import "Feed.h"

@interface FeedTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation FeedTableViewController
@synthesize tableView;
@synthesize feeds;
@synthesize imageDownloadsInProgress;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self  action:@selector(didTouchRefresh:)];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.title = @"Feed-Übersicht";
    [self.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didParseRSSFeed:) name:@"NewRSSData" object:nil];
    
    feeds = [[MediaController sharedInstance] feeds];
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
    return [feeds count];
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
    
    if(feed.hasNotBeenParsed && !feed.isParsing)
    {
        [[MediaController sharedInstance] performSelectorInBackground:@selector(startParsingFeed:) withObject:feed];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Feed *)feed forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.feed = feed;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
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
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
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
    [imageDownloadsInProgress removeObjectForKey:indexPath];
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
    //Feed *feed = [notification.userInfo objectForKey:@"feed"];
    //[tableView reloadSections:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

#pragma mark - Segue Stuff

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [atableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    [[MediaController sharedInstance] setSelectedFeed:feed];
    
    [self performSegueWithIdentifier:@"feedItemSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] compare:@"feedItemSegue"] == 0)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)didTouchRefresh:(id)sender
{
    [[MediaController sharedInstance] performSelectorInBackground:@selector(refreshAllFeeds) withObject:nil];
}

@end
