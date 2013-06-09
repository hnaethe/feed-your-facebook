//
//  FeedFetcher.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@protocol  FeedItemParserProtocol;
@interface FeedItemParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) id<FeedItemParserProtocol>delegate;

- (void)parseFeedItemsFromFeed:(Feed *)rssFeed;

@property (nonatomic, strong) Feed *feed;

@end

@protocol FeedItemParserProtocol <NSObject>

@required

- (void)feedItemParserDidFinish:(FeedItemParser *)parser;

@end