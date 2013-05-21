//
//  DataManager.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 04.05.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed;
@interface DataManager : NSObject

- (id)initWithFileName:(NSString *)fileName;

- (void)resetStore;

- (void)saveFeed:(Feed *)feed;

- (NSMutableArray *)loadFeeds;

@end
