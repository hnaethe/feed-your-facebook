//
//  FeedItemTableViewController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 22.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface FeedItemTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, IconDownloaderDelegate, UIScrollViewDelegate>

@end
