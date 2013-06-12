//
//  FeedTableViewController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@protocol FeedTableViewControllerProtocol;
@interface FeedTableViewController : UITableViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, IconDownloaderDelegate>

@property (nonatomic, weak) id<FeedTableViewControllerProtocol>delegate;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)refresh;

@end

@protocol FeedTableViewControllerProtocol
@optional

- (void)userDidSelectARow;
@end
