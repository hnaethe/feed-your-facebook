//
//  FeedTableViewController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface FeedTableViewController : UITableViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, IconDownloaderDelegate>

@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)refresh;
@end