//
//  FeedViewCell.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 21.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 53

@class Feed;

@interface FeedViewCell : UITableViewCell
- (void)setFeed:(Feed *)feed;
@end
