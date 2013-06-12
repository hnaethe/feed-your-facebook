//
//  FeedItemViewCell.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 22.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight 63

@class FeedItem;
@interface FeedItemViewCell : UITableViewCell

- (void)setFeedItem:(FeedItem *)feedItem;

@end
