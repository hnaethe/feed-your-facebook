//
//  IconDownloader.m
//  SalesDJ
//
//  Created by Hendrik Näther on 16.01.13.
//  Copyright (c) 2013 itCampus. All rights reserved.
//

#import "IconDownloader.h"
#import "Feed.h"

#define kSmallIconSize 43

@implementation IconDownloader
@synthesize feed, indexPathInTableView, delegate;

- (void)startDownload
{
    //NSURL *url = [[NSURL alloc] initWithString:feed.imageURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:feed.imageURL];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:3];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error)
     {
         error ? [self loadingImageFailedWithResponse:response andError:error] : [self loadingImageReceivedResponse:response andData: data];
     }];
}


- (void)loadingImageReceivedResponse:(NSURLResponse *)response andData:(NSData *)data
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (image.size.width != kSmallIconSize || image.size.height != kSmallIconSize)
	{
        CGSize itemSize = CGSizeMake(kSmallIconSize, kSmallIconSize);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.feed.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.feed.image = image;
    }
        
    // call our delegate and tell it that our icon is ready for display
    [delegate imageDidLoad:self.indexPathInTableView];

}

- (void)loadingImageFailedWithResponse:(NSURLResponse *)response andError:(NSError *)error
{
    #warning incomplete implementation
}

- (void)cancelDownload
{
    #warning incomplete implementation
}


@end
