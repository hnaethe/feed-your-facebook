//
//  ChannelParser.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 09.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Feed;
@protocol ChannelParserProtocol;

@interface ChannelParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id<ChannelParserProtocol>delegate;
@property (nonatomic, strong) Feed *feed;

- (void)parseChannelFromFeed:(Feed *)rssFeed;

@end


@protocol ChannelParserProtocol

@required

- (void)channelParserDidFinish:(ChannelParser *)parser;

@end