//
//  FeedFetcher.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@protocol  FeedParserProtocol;
@interface FeedParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) id<FeedParserProtocol>delegate;

- (void)parseXMLFileFromFeed:(Feed *)rssFeed;

@property (nonatomic, strong) Feed *feed;

@end

@protocol FeedParserProtocol <NSObject>

@required

- (void)parserDidFinish:(FeedParser *)parser;

@end