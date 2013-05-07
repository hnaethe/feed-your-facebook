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

- (void)startParsingFeed:(Feed *)feed
{
    feed.isParsing = YES;
    
    FeedParser *parser = [[FeedParser alloc] init];
    parser.delegate = self;
    
    [feed.feedItems removeAllObjects];
    [parser parseXMLFileFromFeed:feed];
}

- (void)parserDidFinish:(FeedParser *)parser
{
    parser.feed.isParsing = NO;
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:parser.feed,@"feed", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRSSData" object:nil userInfo:dict];
}

- (void)refreshAllFeeds
{
    for (Feed *feed in feeds) {
        FeedParser *parser = [[FeedParser alloc] init];
        parser.delegate = self;
        
        [feed.feedItems removeAllObjects];
        [parser parseXMLFileFromFeed:feed];
    }
}

- (void)loadFeeds
{
    feeds = [[NSMutableArray alloc] init];
    
    if(!dataManager)
    {
         dataManager = [[DataManager alloc] initWithFileName:@"test.plist"];
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
    
    /*Feed *feed = [[Feed alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.mountainpanoramas.com/news.rss" ]];
     
     [feeds addObject:feed];*/

}

- (void)saveFeeds
{
    for (Feed *feed in feeds) {
        [dataManager saveFeed:feed];
    }
}


@end
