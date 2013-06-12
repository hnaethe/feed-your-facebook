//
//  MediaController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "MediaController.h"
#import "Feed.h"
#import "DataManager.h"

@interface MediaController ()
@property (nonatomic, strong) DataManager *dataManager;
@end

@implementation MediaController
@synthesize feeds;
@synthesize selectedFeed;
@synthesize dataManager;

+ (id)sharedInstance
{
    static MediaController *instance = nil;
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [[MediaController alloc] init];
        }
    } 
    return instance;
}

- (id)init
{
    if((self = [super init]))
    {
        // do sth.
    }
    return self;
}

- (void)createFeedWithURL:(NSString *)url
{
    Feed * feed = [[Feed alloc] initWithURL:[NSURL URLWithString:url]];
    [feeds addObject:feed];
    feed = nil;
    
    [self startParsingChannel:feed];
}

- (void)startParsingChannel:(Feed *)feed
{
    feed.isParsing = YES;
    
    ChannelParser *parser = [[ChannelParser alloc] init];
    parser.delegate = self;
    
    [parser parseChannelFromFeed:feed];
}

- (void)channelParserDidFinish:(ChannelParser *)parser
{
    parser.feed.isParsing = NO;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:parser.feed,@"feed", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRSSData" object:nil userInfo:dict];
}


- (void)startParsingFeedItems:(Feed *)feed
{
    feed.isParsing = YES;
    
    FeedItemParser *parser = [[FeedItemParser alloc] init];
    parser.delegate = self;
    
    [feed.feedItems removeAllObjects];
    
    [parser parseFeedItemsFromFeed:feed];
}

- (void)feedItemParserFinishedItem:(FeedItem *)feedItem
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:feedItem,@"feedItem", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewFeedItem" object:nil userInfo:dict];
}

- (void)feedItemParserDidFinish:(FeedItemParser *)parser
{
    parser.feed.isParsing = NO;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:parser.feed,@"feed", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewFeedItemData" object:nil userInfo:dict];
}

- (void)refreshAllChannels
{
    for (Feed *feed in feeds) {
        [self startParsingChannel:feed];
    }
}

- (void)refreshAllFeedItems
{
    for (Feed *feed in feeds) {
        [self startParsingFeedItems:feed];
    }
}

- (void)loadFeedsFromData
{
    feeds = [[NSMutableArray alloc] init];
    
    if(!dataManager)
    {
         dataManager = [[DataManager alloc] initWithFileName:@"data.plist"];
    }
    
    NSMutableArray *loadedFeedURLs = [dataManager loadFeeds];
    if([loadedFeedURLs count] > 0)
    {
        for (NSURL *url in loadedFeedURLs) {
            Feed * feed = [[Feed alloc] initWithURL:url];
            [feeds addObject:feed];
        }
    }
    else
    {
        Feed * feed = [[Feed alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.mountainpanoramas.com/news.rss"]];
        [feeds addObject:feed];
        
        Feed * feed2 = [[Feed alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.spiegel.de/schlagzeilen/tops/index.rss"]];
        [feeds addObject:feed2];
        
        [dataManager saveFeed:feed];
        [dataManager saveFeed:feed2];
    }
}

- (void)saveFeeds
{
    for (Feed *feed in feeds) {
        [dataManager saveFeed:feed];
    }
}


@end
