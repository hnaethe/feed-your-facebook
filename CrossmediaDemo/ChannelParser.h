//
//  ChannelParser.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 09.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@class ChannelParser;
typedef void(^HNChannelParserCompletionHandler)(ChannelParser *parser, BOOL didParseFeeds, NSError *error);

@interface ChannelParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) Feed *feed;

- (void)parseChannelFromFeed:(Feed *)rssFeed completionHandler:(HNChannelParserCompletionHandler)completionHandler;

@end