//
//  FeedTableViewController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 21.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface FeedTableViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, IconDownloaderDelegate>

@end
