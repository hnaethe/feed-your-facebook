//
//  MediaController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "MediaController.h"
#import "Feed.h"

@implementation MediaController
@synthesize feeds;
@synthesize selectedFeed;

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
     FeedParser *parser = [[FeedParser alloc] init];
    parser.delegate = self;

    [parser parseXMLFileFromFeed:feed];
}

- (void)parserDidFinish:(FeedParser *)parser
{
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
    
    NSMutableArray *loadedFeedURLs = [[NSUserDefaults standardUserDefaults] objectForKey:@"RSSFeeds"];
    if(loadedFeedURLs)
    {
        for (NSString *urlString in loadedFeedURLs) {
            Feed * feed = [[Feed alloc] initWithURL:[[NSURL alloc] initWithString:urlString]];
            [feeds addObject:feed];
        }
    }
    
    /*Feed *feed = [[Feed alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.mountainpanoramas.com/news.rss" ]];
     
     [feeds addObject:feed];*/

}

- (void)saveFeeds
{
    NSMutableArray *feedURLs = [[NSMutableArray alloc] initWithCapacity:[feeds count]];
    for (Feed *feed in feeds) {
        [feedURLs addObject:feed.url.absoluteString];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:feedURLs forKey:@"RSSFeeds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
