//
//  IconDownloader.h
//  SalesDJ
//
//  Created by Hendrik Näther on 16.01.13.
//  Copyright (c) 2013 itCampus. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IconDownloaderDelegate;
@class ImageObject;

@interface IconDownloader : NSObject

@property (nonatomic, strong) ImageObject *imageObject;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate
- (void)imageDidLoad:(NSIndexPath *)indexPath;
@end
