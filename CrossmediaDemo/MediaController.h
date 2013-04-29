//
//  MediaController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedParser.h"
@class Feed;
@interface MediaController : NSObject <FeedParserProtocol>
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) Feed *selectedFeed;

+ (id)sharedInstance;

- (void)startParsingFeed:(Feed *)feed;

- (void)refreshAllFeeds;

- (void)loadFeeds;

- (void)saveFeeds;


@end
