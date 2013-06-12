//
//  FeedFetcher.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@class FeedItem;

@protocol  FeedItemParserProtocol;
@interface FeedItemParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id<FeedItemParserProtocol>delegate;

- (void)parseFeedItemsFromFeed:(Feed *)rssFeed;

@property (nonatomic, strong) Feed *feed;

@end

@protocol FeedItemParserProtocol <NSObject>

@required

- (void)feedItemParserDidFinish:(FeedItemParser *)parser;

- (void)feedItemParserFinishedItem:(FeedItem *)feedItem;

@end