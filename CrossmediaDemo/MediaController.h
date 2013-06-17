//
//  MediaController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemParser.h"
#import "ChannelParser.h"
#import "FeedTableViewController.h"

@class Feed;
typedef void(^HNBackgroundRefreshCompletionHandler)(BOOL didParseFeeds);

@interface MediaController : NSObject <FeedItemParserProtocol>
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) Feed *selectedFeed;

+ (id)sharedInstance;

- (void)createFeedWithURL:(NSString *)url;

- (void)startParsingChannel:(Feed *)feed;

- (void)startParsingFeedItems:(Feed *)feed;

- (void)refreshAllChannels;

- (void)fetchChannelsWithCompletionHandler:(HNBackgroundRefreshCompletionHandler)completionHandler;

- (void)refreshAllFeedItems;

- (void)loadFeedsFromData;

- (void)saveFeeds;


@end
