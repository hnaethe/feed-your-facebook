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

@class Feed;
@interface MediaController : NSObject <FeedItemParserProtocol, ChannelParserProtocol>
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) Feed *selectedFeed;

+ (id)sharedInstance;

- (void)startParsingChannel:(Feed *)feed;

- (void)refreshAllChannels;

- (void)refreshAllFeedItems;

- (void)loadFeedsFromData;

- (void)saveFeeds;


@end
